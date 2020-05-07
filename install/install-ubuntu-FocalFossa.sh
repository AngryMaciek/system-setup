#!/usr/bin/env bash

###############################################################################
#
#   Working environment setup for fresh operating system
#
#   AUTHOR: Maciej_Bak
#   AFFILIATION: Swiss_Institute_of_Bioinformatics
#   CONTACT: wsciekly.maciek@gmail.com
#   CREATED: 16-04-2020
#   LICENSE: MIT
#   USAGE: sudo bash install-ubuntu.sh
#
###############################################################################

SECONDS=0

SEP="############################################################"
echo $SEP

echo $(date)
echo "Script started"
echo $SEP

# check root privileges
if [[ $(id -u) -ne 0 ]]
    then
        echo $(date)
        echo "Please run this script with root privileges."
        echo "Exiting..."
        echo $SEP
        exit 1
fi

# check the CPU architecture
CPU_arch=$(uname -m)
if [[ $CPU_arch != "x86_64" ]]
    then
        echo $(date)
        echo "This script only works on 64bit systems, sorry!"
        echo "Exiting..."
        echo $SEP
        exit 1
fi

# prepare a clean-up function to call on EXIT signal
cleanup () {
    # This is not ideal, it assumes that an error occured
    # already after backup of the dotfies (most probable case).
    rc=$?
    # remove all new dotfiles
    rm -f .bashrc .gitconfig .pylintrc
    # restore old dotfiles
    cp Backup/.bashrc .bashrc
    if [[ -f Backup/.gitconfig ]]
        then
            mv Backup/.gitconfig .gitconfig
    fi
    # remove all new directories from $USER_HOME
    rm -rf Backup
    rm -rf custom_bash
    rm -rf google-chrome-stable_current_amd64.deb
    rm -rf AdbeRdr9.5.5-1_i386linux_enu.deb
    rm -rf textfile-templates
    rm -rf cookiecutters
    rm -rf Miniconda3-latest-Linux-x86_64.sh
    rm -rf miniconda3
    rm -rf .conda
    rm -rf conda-envs
    rm -rf SC4DA
    cd "$user_dir"
    echo "Installation aborted!"
    echo "Exit status: $rc"
    echo $SEP
}
trap cleanup EXIT SIGINT # move this after Backup?

# exit script on first non-zero exit-status command
# exit script when unset variables are used
# do not mask the return code
set -euo pipefail

# remember paths
user_dir=$PWD
install_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# work in $SUDO_USER home directory
USER_HOME=$(sudo -u $SUDO_USER -H -s eval 'echo $HOME')

# snap
snap install core

# install git if it has not been already installed
# (the newest version available)
echo $(date)
echo "Installing Git version control system"
apt-get install git -qq
echo $SEP

# backup old configs
echo $(date)
echo "Backing up old config files"
if [[ -d "Backup" ]]
    then
        echo "Directory '~/Backup' already exists!"
        echo "Exiting..."
        echo $SEP
        exit 1
fi
mkdir Backup
cp .bashrc Backup/.bashrc # .bashrc is always present
if [[ -f .gitconfig ]]
    then
        mv .gitconfig Backup/.gitconfig
fi
echo $SEP

# copy the dotflies
echo $(date)
echo "Copying configuration files"
sudo -u $SUDO_USER cp $install_dir/../dotfiles/.gitconfig .gitconfig
sudo -u $SUDO_USER cp $install_dir/../dotfiles/.pylintrc .pylintrc
echo $SEP

# install my bash configuration
# https://github.com/AngryMaciek/custom_bash
echo $(date)
echo "Configuring bash"
sudo -u $SUDO_USER git clone https://github.com/AngryMaciek/custom_bash.git
sudo -u $SUDO_USER rm -f .bashrc
sudo -u $SUDO_USER ln -s custom_bash/bashrc .bashrc
# bashrc.local is an additional space for all local bash configuration
sudo -u $SUDO_USER touch custom_bash/bashrc.local
echo $SEP

# update apt-get package lists
echo $(date)
echo "Updating package lists"
apt-get update --yes
echo $SEP

# fetch new versions of installed packages
echo $(date)
echo "Upgrading installed packages"
snap refresh
apt-get upgrade --yes
echo $SEP

# install compilers
echo $(date)
echo "Installing GCC, G++, GFORTRAN compilers"
apt-get install gcc -qq
gcc --version
apt-get install g++ -qq
g++ --version
apt-get install gfortran -qq
gfortran --version
echo $SEP

# install important software:
echo $(date)
echo "Installing important software"
apt-get install gparted -qq
hash gparted
snap install code --classic
sudo -u $SUDO_USER code --version
apt-get install guake -qq
guake --version
apt-get install htop -qq
htop --version
apt-get install terminator -qq
terminator --version
snap install tmux --classic
hash tmux
apt-get install sshfs -qq
sshfs --version
sudo -u $SUDO_USER wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install ./google-chrome-stable_current_amd64.deb -qq
google-chrome --version
sudo -u $SUDO_USER rm -f google-chrome-stable_current_amd64.deb
apt-get install vim -qq
vim --version
snap install slack --classic
hash slack
snap install bitwarden
hash bitwarden
snap install gimp
gimp --version
snap install inkscape
sudo -u $SUDO_USER inkscape --version
# install Adobe Reader
apt-get install \
gdebi-core \
libxml2:i386 \
libcanberra-gtk-module:i386 \
gtk2-engines-murrine:i386 \
libatk-adaptor:i386 \
-qq
sudo -u $SUDO_USER wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
yes | gdebi AdbeRdr9.5.5-1_i386linux_enu.deb & # workaround for this installer
sleep 180
sudo -u $SUDO_USER rm -rf AdbeRdr9.5.5-1_i386linux_enu.deb
acroread -version
echo $SEP



# remove unnecessary software
echo $(date)
echo "Uninstalling unnecessary software"
apt-get purge firefox* -qq
echo $SEP
#sudo apt-get clean
#sudo apt-get autoremove


# install my textfile templates
# https://github.com/AngryMaciek/textfile-templates
echo $(date)
echo "Cloning textfile templates"
sudo -u $SUDO_USER git clone https://github.com/AngryMaciek/textfile-templates.git
EXPORT_TEMPLATES="export PATH=$PATH\":$USER_HOME/textfile-templates\""
sudo -u $SUDO_USER echo $'' >> custom_bash/bashrc.local
sudo -u $SUDO_USER echo $EXPORT_TEMPLATES >> custom_bash/bashrc.local
sudo -u $SUDO_USER chmod +x textfile-templates/template
echo $SEP

# install my cookiecutters
# https://github.com/AngryMaciek/cookiecutters
echo $(date)
echo "Cloning cookiecutters"
sudo -u $SUDO_USER git clone https://github.com/AngryMaciek/cookiecutters.git;
echo $SEP

# download and install Miniconda3
echo $(date)
echo "Installing Miniconda3"
sudo -u $SUDO_USER wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo -u $SUDO_USER bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda3
sudo -u $SUDO_USER cat $install_dir/conda-init.txt >> .bashrc
sudo -u $SUDO_USER rm -f Miniconda3-latest-Linux-x86_64.sh
echo $SEP

# install my conda env recipes
# https://github.com/AngryMaciek/conda-envs
echo $(date)
echo "Building conda environments"
sudo -u $SUDO_USER git clone https://github.com/AngryMaciek/conda-envs.git
sudo -i -u $SUDO_USER bash -i conda-envs/Nextflow/create-virtual-environment.sh
sudo -i -u $SUDO_USER bash -i conda-envs/Python_Jupyter/create-virtual-environment.sh
sudo -i -u $SUDO_USER bash -i conda-envs/Python_DL/create-virtual-environment.sh
sudo -i -u $SUDO_USER bash -i conda-envs/R/create-virtual-environment.sh
sudo -i -u $SUDO_USER bash -i conda-envs/Snakemake/create-virtual-environment.sh
sudo -i -u $SUDO_USER bash -i conda-envs/code_linting/create-virtual-environment.sh
# ...and add bash aliases:
ALIAS_NEXTFLOW="alias conda-nextflow=\"conda activate ~/conda-envs/Nextflow/env\""
sudo -u $SUDO_USER echo $'' >> custom_bash/bashrc.local
sudo -u $SUDO_USER echo $ALIAS_NEXTFLOW >> custom_bash/bashrc.local
ALIAS_PYTHON_JUPYTER="alias conda-jupyter=\"conda activate ~/conda-envs/Python_Jupyter/env\""
sudo -u $SUDO_USER echo $'' >> custom_bash/bashrc.local
sudo -u $SUDO_USER echo $ALIAS_PYTHON_JUPYTER >> custom_bash/bashrc.local
ALIAS_PYTHON_DL="alias conda-dl=\"conda activate ~/conda-envs/Python_DL/env\""
sudo -u $SUDO_USER echo $'' >> custom_bash/bashrc.local
sudo -u $SUDO_USER echo $ALIAS_PYTHON_DL >> custom_bash/bashrc.local
ALIAS_R="alias conda-r=\"conda activate ~/conda-envs/R/env\""
sudo -u $SUDO_USER echo $'' >> custom_bash/bashrc.local
sudo -u $SUDO_USER echo $ALIAS_R >> custom_bash/bashrc.local
ALIAS_SNAKEMAKE="alias conda-snakemake=\"conda activate ~/conda-envs/Snakemake/env\""
sudo -u $SUDO_USER echo $'' >> custom_bash/bashrc.local
sudo -u $SUDO_USER echo $ALIAS_SNAKEMAKE >> custom_bash/bashrc.local
ALIAS_CODE_LINT="alias conda-lint=\"conda activate ~/conda-envs/code_linting/env\""
sudo -u $SUDO_USER echo $'' >> custom_bash/bashrc.local
sudo -u $SUDO_USER echo $ALIAS_CODE_LINT >> custom_bash/bashrc.local
echo $SEP

# install my general data analytic env
# https://github.com/AngryMaciek/SC4DA
#echo $(date)
#echo "Building main development environment (SC4DA)"
#sudo -u $SUDO_USER git clone https://github.com/AngryMaciek/SC4DA.git
#sudo -u $SUDO_USER conda env create --prefix SC4DA/env --file SC4DA/conda_packages.yaml
#echo $SEP

# clean conda: cache, lock files, unused packages and tarballs
echo $(date)
echo "Removing unused packages and cache from conda"
#sudo -u $SUDO_USER conda clean --all --yes
sudo -i -u $SUDO_USER bash -i conda-clean.sh # -i?
echo $SEP

# set a wallpaper
# https://askubuntu.com/questions/66914/how-to-change-desktop-background-from-command-line-in-unity
echo $(date)
echo "Setting a wallpaper"
#RESOLUTION=$(xdpyinfo | awk '/dimensions/{print $2}')
sudo -u $SUDO_USER gsettings set org.gnome.desktop.background picture-uri \
file://$USER_HOME/system-setup/ubuntu-wallpaper-3840x2160.jpg
echo $SEP

# Install GNOME Flashback desktop environment
echo $(date)
echo "Installing GNOME Flashback"
apt-get install gnome-session-flashback -qq
echo $SEP

duration=$SECONDS
duration_h=$(($duration / 3600))
duration_m=$((($duration / 60) % 60))
duration_s=$(($duration % 60))

# finish with rebooting the system
echo $(date)
echo "Setup time: "$duration_h"h"$duration_m"m"$duration_s"s"
echo "Setup completed successfully!"
echo "System will reboot in 60s"
echo $SEP
sleep 60
#reboot


###############################################################################
#
# Future releases: 
#
# * gnome flashback as default desktop, clean icons and panels (gnome dotfile?)
# * vs code config - dotfiles? plugins?
# * .guake
# * .terminator
# * include new repo with vimrc
# * include new repo with custom_zsh + install zsh
#
###############################################################################

# sc4da install

# reorder install: gnome on top? update, purge, upgrade, intall?

# test while clonning to different location and calling from another one!

# test trap function, ctrlC, dummy command with exit !=0

# #shellckech and lint this script at the end!