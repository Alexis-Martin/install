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

# update system
echo "Step 1 : Update system"
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1

echo "Step 2 : install default packages and configure them"
#install default packages
PKGS=`cat install-packages/default-packages.list`

for i in $PKGS
do
    sudo apt-get install -y $i > /dev/null 2>&1
done

CONFS=`ls -p config-packages | grep -v /`

for i in $CONFS
do
    if [[ `echo $PKGS | grep -w "$i"` ]]
    then
        var="bash config-packages/$i"
        eval $var
        #> /dev/null 2>&1
    fi
done

#install optional packages
if [[ $OPTIONAL == 1 ]]
then
    PKGS=`cat install-packages/optional-packages.list`

    for i in $PKGS
    do
        sudo apt-get install -y $i  > /dev/null 2>&1
    done

    CONFS=`ls -p config-packages | grep -v /`

    for i in $CONFS
    do
        if [[ `echo $PKGS | grep -w "$i"` ]]
        then
            var="bash config-packages/$i"
            eval $var > /dev/null 2>&1
        fi
    done
fi

#install unistellar packages
if [[ $UNISTELLAR == 1 ]]
then

    PKGS=`cat install-packages/unistellar-packages.list`

    for i in $PKGS
    do
        sudo apt-get install -y $i  > /dev/null 2>&1
    done

    CONFS=`ls -p config-packages | grep -v /`

    for i in $CONFS
    do
        if [[ `echo $PKGS | grep -w "$i"` ]]
        then
            var="bash config-packages/$i"
            eval $var > /dev/null 2>&1
        fi
    done
fi

#FONT SOURCE CODE PRO
FONT_HOME=~/.local/share/fonts

mkdir -p "$FONT_HOME/adobe-fonts/source-code-pro"

(git clone \
   --branch release \
   --depth 1 \
   'https://github.com/adobe-fonts/source-code-pro.git' \
   "$FONT_HOME/adobe-fonts/source-code-pro" && \
fc-cache -f -v "$FONT_HOME/adobe-fonts/source-code-pro")

if [[ $ONEUSER == 1 ]]
then
    FONT_ROOT=/root/.local/share/fonts
    sudo mkdir -p "$FONT_ROOT/adobe-fonts/source-code-pro"

    (sudo git clone \
          --branch release \
          --depth 1 \
          'https://github.com/adobe-fonts/source-code-pro.git' \
          "$FONT_ROOT/adobe-fonts/source-code-pro" && \
         sudo fc-cache -f -v "$FONT_ROOT/adobe-fonts/source-code-pro")
fi

[ ! -h ~/.bash_command_timer.sh ] && ln -s $PWD/bash_command_timer.sh ~/.bash_command_timer.sh
if [[ $ONEUSER == 1 ]]
then
    sudo [ ! -h /root/.bash_command_timer.sh ] && sudo ln -s $PWD/bash_command_timer.sh /root/.bash_command_timer.sh
fi

# #BASH
[ -f ~/.aliases.sh ] && rm ~/.aliases.sh
[ ! -h ~/.aliases.sh ] && ln -s $PWD/config/aliases.sh ~/.aliases.sh
if [[ $ONEUSER == 1 ]]
then
    sudo [ -f /root/.aliases.sh ] && sudo rm /root/.aliases.sh
    sudo [ ! -h /root/.aliases.sh ] && sudo ln -s $PWD/config/aliases.sh /root/.aliases.sh
fi

if [[ $UNISTELLAR == 1 ]]
then
    [ -f ~/.aliases-unistellar.sh ] && rm ~/.aliases-unistellar.sh
    [ ! -h ~/.aliases-unistellar.sh ] && ln -s $PWD/config/aliases-unistellar.sh ~/.aliases-unistellar.sh

    if [[ $ONEUSER == 1 ]]
    then
        sudo [ -f /root/.aliases-unistellar.sh ] && sudo rm /root/.aliases-unistellar.sh
        sudo [ ! -h /root/.aliases-unistellar.sh ] && sudo ln -s $PWD/config/aliases-unistellar.sh /root/.aliases-unistellar.sh
    fi
fi

[ -f ~/.bashrc ] && rm ~/.bashrc
[ ! -h ~/.bashrc ] && ln -s $PWD/config/bashrc ~/.bashrc
if [[ $ONEUSER == 1 ]]
then
    sudo [ -f /root/.bashrc ] && sudo rm /root/.bashrc
    sudo [ ! -h /root/.bashrc ] && sudo ln -s $PWD/config/bashrc /root/.bashrc
fi

#APT
echo "Dpkg::Progress-Fancy 1;
APT::Color 1;" | sudo tee /etc/apt/apt.conf.d/99progressbar > /dev/null

sudo apt-file update

#upgrade if some package are outdated and remove useless packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

echo "Ready!"
# bash
