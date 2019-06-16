#! /bin/bash

echo "
Have internet?
R U sudoer?
Press [Enter]"

read foo


PWD=`pwd`

sudo apt-get -y install $(cat pkg-srv.list)

if [ ! -z "$DISPLAY" ]
then
	sudo apt-get -qq -y install $(cat pkg-x.list)
	mkdir -p ~/.config/terminator
	[ -f ~/.config/terminator/config ] && rm ~/.config/terminator/config
	[ ! -h  ~/.config/terminator/config ] && ln -s $PWD/terminator.config ~/.config/terminator/config
	sudo mkdir -p /root/.config/terminator
	sudo [ -f /root/.config/terminator/config ] && sudo rm /root/.config/terminator/config
	sudo [ ! -h /root/.config/terminator/config ] && sudo ln -s $PWD/terminator.config /root/.config/terminator/config
fi

#HTOP
mkdir -p ~/.config/htop
sudo mkdir -p /root/.config/htop
[ -f ~/.config/htop/htoprc ] && rm ~/.config/htop/htoprc
[ ! -h ~/.config/htop/htoprc ] && ln -s $PWD/htoprc ~/.config/htop/htoprc
sudo [ -f /root/.config/htop/htoprc ] && sudo rm /root/.config/htop/htoprc
sudo [ ! -h /root/.config/htop/htoprc ] && sudo ln -s $PWD/htoprc /root/.config/htop/htoprc

#VIM
[ -f ~/.vimrc ] && rm ~/.vimrc
[ ! -h ~/.vimrc ] && ln -s $PWD/vimrc ~/.vimrc
sudo [ -f /root/.vimrc ] && sudo rm /root/.vimrc
sudo [ ! -h /root/.vimrc ] && sudo ln -s $PWD/vimrc /root/.vimrc

#FONT SOURCE CODE PRO
FONT_HOME=~/.fonts # actually this path is better : ~/.local/share/fonts
FONT_ROOT=/root/.local/share/fonts

mkdir -p "$FONT_HOME/adobe-fonts/source-code-pro"
sudo mkdir -p "$FONT_ROOT/adobe-fonts/source-code-pro"

(git clone \
   --branch release \
   --depth 1 \
   'https://github.com/adobe-fonts/source-code-pro.git' \
   "$FONT_HOME/adobe-fonts/source-code-pro" && \
fc-cache -f -v "$FONT_HOME/adobe-fonts/source-code-pro")

(sudo git clone \
   --branch release \
   --depth 1 \
   'https://github.com/adobe-fonts/source-code-pro.git' \
   "$FONT_ROOT/adobe-fonts/source-code-pro" && \
sudo fc-cache -f -v "$FONT_ROOT/adobe-fonts/source-code-pro")



#EMACS
[ -f ~/.emacs ] && rm ~/.emacs
[ ! -h ~/.emacs ] && ln -s $PWD/emacs ~/.emacs
sudo [ -f /root/.emacs ] && sudo rm /root/.emacs
sudo [ ! -h /root/.emacs ] && sudo ln -s $PWD/emacs /root/.emacs

#BASH
[ ! -h ~/.aliases.sh ] && ln -s $PWD/aliases.sh ~/.aliases.sh
sudo [ ! -h /root/.aliases.sh ] && sudo ln -s $PWD/aliases.sh /root/.aliases.sh

[ ! -h ~/.bash_command_timer.sh ] && ln -s $PWD/bash_command_timer.sh ~/.bash_command_timer.sh
sudo [ ! -h /root/.bash_command_timer.sh ] && sudo ln -s $PWD/bash_command_timer.sh /root/.bash_command_timer.sh

[ -f ~/.bashrc ] && rm ~/.bashrc
[ ! -h ~/.bashrc ] && ln -s $PWD/bashrc ~/.bashrc
sudo [ -f /root/.bashrc ] && sudo rm /root/.bashrc
sudo [ ! -h /root/.bashrc ] && sudo ln -s $PWD/bashrc /root/.bashrc

#APT
echo "Dpkg::Progress-Fancy 1;
APT::Color 1;" | sudo tee /etc/apt/apt.conf.d/99progressbar > /dev/null

sudo apt-file update

echo "Ready!"
bash
