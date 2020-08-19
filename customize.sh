#! /bin/bash

echo "
Do you have internet and are you sudoer?
if yes press [Enter] else [Ctrl-C]"

read foo

PWD=`pwd`

while true;
do 
    read -p "Are you the only user (Y/N)? " ONEUSER
    if [[ ${ONEUSER,,} == y || ${ONEUSER,,} == yes ]]
    then
        ONEUSER=1
        break
    fi
    if [[ ${ONEUSER,,} == n || ${ONEUSER,,} == no ]]
    then
        ONEUSER=0
        break
    fi
done
export ONEUSER

while true;
do 
    read -p "Do you want to install optional packages (you can now modified the list $PWD/install-packages/optional-packages.list) (Y/N)? " OPTIONAL
    if [[ ${OPTIONAL,,} == y || ${OPTIONAL,,} == yes ]]
    then
        OPTIONAL=1
        break
    fi
    if [[ ${OPTIONAL,,} == n || ${OPTIONAL,,} == no ]]
    then
        OPTIONAL=0
        break
    fi
done
export OPTIONAL

while true;
do 
    read -p "Do you want to install unistellar packages (you can now modified the list $PWD/install-packages/unistellar-packages.list) (Y/N)? " UNISTELLAR
    if [[ ${UNISTELLAR,,} == y || ${UNISTELLAR,,} == yes ]]
    then
        UNISTELLAR=1
        break
    fi
    if [[ ${UNISTELLAR,,} == n || ${UNISTELLAR,,} == no ]]
    then
        UNISTELLAR=0
        break
    fi
done
export UNISTELLAR

PIP=0
P=`cat install-packages/default-packages.list`
if [[ `echo $P | grep -w python3` ]]
then
    PIP=1
fi
P=`cat install-packages/optional-packages.list`
if [[ $OPTIONAL == 1 && `echo $P | grep -w python3` ]]
then
    PIP=1
fi
P=`cat install-packages/unistellar-packages.list`
if [[ $UNISTELLAR==1 &&  `echo $P | grep -w python3` ]]
then
    PIP=1
fi

if [[ $PIP == 1 ]]
then
    while true;
    do 
        read -p "Do you want to install optional python packages (you can now modified the list $PWD/config-packages/python_files/optional.txt) (Y/N)? " PIPOPTIONAL
        if [[ ${PIPOPTIONAL,,} == y || ${PIPOPTIONAL,,} == yes ]]
        then
            PIPOPTIONAL=1
            break
        fi
        if [[ ${PIPOPTIONAL,,} == n || ${PIPOPTIONAL,,} == no ]]
        then
            PIPOPTIONAL=0
            break
        fi
    done
    export PIPOPTIONAL

    while true;
    do 
        read -p "Do you want to install unistellar python packages (you can now modified the list $PWD/config-packages/python_files/unistellar.txt) (Y/N)? " PIPUNISTELLAR
        if [[ ${PIPUNISTELLAR,,} == y || ${PIPUNISTELLAR,,} == yes ]]
        then
            PIPUNISTELLAR=1
            break
        fi
        if [[ ${PIPUNISTELLAR,,} == n || ${PIPUNISTELLAR,,} == no ]]
        then
            PIPUNISTELLAR=0
            break
        fi
    done
    export PIPUNISTELLAR
fi

#update system
# sudo apt-get update
# sudo apt-get upgrade


#install default packages
PKGS=`cat install-packages/default-packages.list`

# for i in $PKGS
# do
#     sudo apt-get install -y $i
# done

CONFS=`ls -p config-packages | grep -v /`

for i in $CONFS
do
    if [[ `echo $PKGS | grep -w "$i"` ]]
    then
        var="bash config-packages/$i"
        eval $var
    fi
done


# if [ ! -z "$DISPLAY" ]
# then
# 	sudo apt-get -qq -y install $(cat pkg-x.list)
# 	mkdir -p ~/.config/terminator
# 	[ -f ~/.config/terminator/config ] && rm ~/.config/terminator/config
# 	[ ! -h  ~/.config/terminator/config ] && ln -s $PWD/terminator.config ~/.config/terminator/config
# 	sudo mkdir -p /root/.config/terminator
# 	sudo [ -f /root/.config/terminator/config ] && sudo rm /root/.config/terminator/config
# 	sudo [ ! -h /root/.config/terminator/config ] && sudo ln -s $PWD/terminator.config /root/.config/terminator/config
# fi

# #HTOP
# mkdir -p ~/.config/htop
# sudo mkdir -p /root/.config/htop
# [ -f ~/.config/htop/htoprc ] && rm ~/.config/htop/htoprc
# [ ! -h ~/.config/htop/htoprc ] && ln -s $PWD/htoprc ~/.config/htop/htoprc
# sudo [ -f /root/.config/htop/htoprc ] && sudo rm /root/.config/htop/htoprc
# sudo [ ! -h /root/.config/htop/htoprc ] && sudo ln -s $PWD/htoprc /root/.config/htop/htoprc

# #VIM
# [ -f ~/.vimrc ] && rm ~/.vimrc
# [ ! -h ~/.vimrc ] && ln -s $PWD/vimrc ~/.vimrc
# sudo [ -f /root/.vimrc ] && sudo rm /root/.vimrc
# sudo [ ! -h /root/.vimrc ] && sudo ln -s $PWD/vimrc /root/.vimrc

# #FONT SOURCE CODE PRO
# FONT_HOME=~/.fonts # actually this path is better : ~/.local/share/fonts
# FONT_ROOT=/root/.local/share/fonts

# mkdir -p "$FONT_HOME/adobe-fonts/source-code-pro"
# sudo mkdir -p "$FONT_ROOT/adobe-fonts/source-code-pro"

# (git clone \
#    --branch release \
#    --depth 1 \
#    'https://github.com/adobe-fonts/source-code-pro.git' \
#    "$FONT_HOME/adobe-fonts/source-code-pro" && \
# fc-cache -f -v "$FONT_HOME/adobe-fonts/source-code-pro")

# (sudo git clone \
#    --branch release \
#    --depth 1 \
#    'https://github.com/adobe-fonts/source-code-pro.git' \
#    "$FONT_ROOT/adobe-fonts/source-code-pro" && \
# sudo fc-cache -f -v "$FONT_ROOT/adobe-fonts/source-code-pro")

# #BASH
# [ ! -h ~/.aliases.sh ] && ln -s $PWD/aliases.sh ~/.aliases.sh
# sudo [ ! -h /root/.aliases.sh ] && sudo ln -s $PWD/aliases.sh /root/.aliases.sh

# [ ! -h ~/.bash_command_timer.sh ] && ln -s $PWD/bash_command_timer.sh ~/.bash_command_timer.sh
# sudo [ ! -h /root/.bash_command_timer.sh ] && sudo ln -s $PWD/bash_command_timer.sh /root/.bash_command_timer.sh

# [ -f ~/.bashrc ] && rm ~/.bashrc
# [ ! -h ~/.bashrc ] && ln -s $PWD/bashrc ~/.bashrc
# sudo [ -f /root/.bashrc ] && sudo rm /root/.bashrc
# sudo [ ! -h /root/.bashrc ] && sudo ln -s $PWD/bashrc /root/.bashrc

# #APT
# echo "Dpkg::Progress-Fancy 1;
# APT::Color 1;" | sudo tee /etc/apt/apt.conf.d/99progressbar > /dev/null

# sudo apt-file update

# echo "Ready!"
# bash
