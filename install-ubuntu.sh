#!/usr/bin/env bash

###############################################################################
#
#   [TITLE, DESCRIPTION]
#
#   AUTHOR: Maciej_Bak
#   AFFILIATION: Swiss_Institute_of_Bioinformatics
#   CONTACT: wsciekly.maciek@gmail.com
#   CREATED: 16-04-2020
#   LICENSE: MIT
#   USAGE: bash install-ubuntu.sh
#
###############################################################################

#cleanup () {
#    rc=$?
#    rm -rf backup
#    cd "$user_dir"
#    echo "Exit status: $rc"
#}
#trap cleanup EXIT

#set -eo pipefail  # ensures that script exits at first command that exits with non-zero status
#set -u  # ensures that script exits when unset variables are used
#set -x  # facilitates debugging by printing out executed commands

#user_dir=$PWD
#pipeline_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
#cd "$pipeline_dir"


# check for root privileges
if [[ $(id -u) -ne 0 ]]
    then
        echo "Please run the script as root."
        echo "Exiting..."
        echo $(date)
        exit 1
fi

# work in home directory
cd $HOME

# install git if it has not been already installed
# (the newest version)
sudo apt-get install git

# backup old configs
#mkdir backup || echo "Dicectory 'backup' already exists."
#cp .bashrc backup/.bashrc # always present
#cp .gitconfig backup/.gitconfig




# install my bash configuration
# https://github.com/AngryMaciek/custom_bash
#$ git clone https://github.com/AngryMaciek/custom_bash.git
#$ ln -s custom_bash/bashrc .bashrc
#$ touch custom_bash/bashrc.local

# copy all the current local bash configs into bashrc.local


# install cool software:
# iterm
# terminator
# sshfs
# Chrome
# tmux
# visual studio vs sublime






# remove unnecessary software

# update and upgrade apt

# Ubuntu comes with gcc and gfortran compilers
# test that

# download miniconda

#CPU_arch=$(uname -m)
#if [ CPU_arch == "x86_64" ]; then
#  Miniconda_installer="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
#elif [ CPU_arch == "i386" ] | [ CPU_arch == "i686" ]; then
#  Miniconda_installer="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh"
#fi
#wget Miniconda_installer

# install miniconda

#if [ CPU_arch == "x86_64" ]; then
#  bash Miniconda3-latest-Linux-x86_64.sh
#elif [ CPU_arch == "i386" ] | [ CPU_arch == "i686" ]; then
#  bash Miniconda3-latest-Linux-x86.sh
#fi

#rm -f Miniconda3-latest-Linux-x86_64.sh
#rm -f Miniconda3-latest-Linux-x86.sh

#source .bashrc










# install my textfile templates
# https://github.com/AngryMaciek/textfile-templates
#git clone https://github.com/AngryMaciek/textfile-templates.git;

#vim .bash_profle
# add the following line into the profile file:
# export PATH=$PATH":$HOME/textfile-templates"

#vim textfile-templates/template

#chmod +x textfile-templates/template

#source .bashrc




# install my cookiecutters
# https://github.com/AngryMaciek/cookiecutters
#conda install -c conda-forge cookiecutter
#git clone https://github.com/AngryMaciek/cookiecutters.git;

# install my conda env recipes
# https://github.com/AngryMaciek/conda-envs
#git clone https://github.com/AngryMaciek/conda-envs.git




# make symlinks to gitconfig dotfile

#sc4da
#custom pylintrc



#shellckech and lint this script at the end!
#trap? just like Alex does