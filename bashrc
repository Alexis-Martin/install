# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

set completion-ignore-case on

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions
if [ -f ~/.aliases.sh ]; then
	. ~/.aliases.sh
fi

if [ -f ~/.bash_command_timer.sh ]; then
	. ~/.bash_command_timer.sh
fi
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi
export MANPAGER="most"

if [ -n "$DISPLAY" ]; then
  xset b off
fi
export PATH=$PATH:~/.local/bin

#if [ -f ~/.local/bin/trello ]; then
#  echo "yes"
#  trello &
#fi

export PYTHONPATH=~/src/eVsoft_tools/FrameUtils:~/src/Stereopsys/src/:~/src/Stereopsys/3rdParty/python-zwoasi/:~/src/utils:~/src
PATH=$PATH:/home/alexis/src/flatbuffers
PATH=$PATH:/home/alexis/src/toolchain/bin
PATH=$PATH:/home/alexis/sbin:/home/alexis/bin
PATH=$PATH:/opt/microchip/xc16/v1.35/bin

# parse_git_branch() {
#      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }
# export PS1="\e[1m\e[92m\u@\h:\[\033[34m\]\w\e[0m]\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "

# export SPOC_HOME=/home/alexis/src/spoc
# export PYTHONPATH=/home/alexis/src/eVsoft_tools/FrameUtils:/home/alexis/src/utils:/home/alexis/src/spoc:/home/alexis/src/pipeline/utils/bkgSubstractor

# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.7

function spocenv() {
    export WORKON_HOME=/home/alexis/venvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.7
    source /home/alexis/.local/bin/virtualenvwrapper.sh
    workon spoc
} 

function djangoenv() {
    source /home/alexis/venvs/djangoenv/bin/activate
} 

