export EDITOR='emacs --no-window'
alias ealias='emacs --no-window ~/.aliases.sh'
alias sshlist='cat ~/.ssh/config'
alias q='exit'
alias d='wget -c'
alias c='clear'
alias m='mount | column -t'
alias ls='ls --color'
alias l='ls -lAh'
alias sl='sudo ls -lah'
alias ll='ls -lAh'
alias lt='ls -t'
alias h='htop'
alias df='df -h'
alias grep='grep --color'
alias ga='git add -A'
alias gs='git status'
alias gb='git branch'
alias gbv='git branch -avv'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdn='git diff --name-only'
alias gdv='git difftool --tool=vimdiff --no-prompt'
alias gl='git log'
alias gln='git log --name-only'
alias gll='git log --graph --oneline --decorate --all --remotes=origin'
alias gc='git checkout'
alias gp='git pull --recurse-submodules'
alias gg='git grep -i'
alias gcp='git cherry-pick'
alias gr='git remote -v'
alias gf='git fetch -p'
alias enw='emacs --no-window'
alias e='emacs'
alias t='tree -Ca -I ".git*" --noreport'
alias pd='qpdfview > /dev/null 2>&1'
alias lsbig='find . -type f -print0 | xargs -0 du -h | sort -rh | head -n 10'
alias beep='aplay -q /usr/share/orage/sounds/Spo.wav > /dev/null 2>&1'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias hs='history | tail -n50'
alias dm='sudo dmesg -cHw'
alias bw='wget http://test-debit.free.fr/image.iso -O /dev/null'
alias n='sudo netstat -lptnu'
alias si='sudo ifconfig'
alias afs='apt-file search'
alias b='watch -n1'
alias pt='ping -c1 google.de'
alias cc='sync; echo 3 | sudo tee /proc/sys/vm/drop_caches'
alias dds='sudo pkill -USR1 dd'
alias setenv='setpythonenv python-3'

function mkc() {
  mkdir -p $1 && cd $1
}

function f () {
find -type f -iname "*$**" -or -type d -iname "*$**" -and -not -path "*.git*" 2>/dev/null | egrep -i --color "$*"
}

function un () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar -I lbzip2 -xf $1     ;;
      *.tar.gz)    tar -I pigz -xf $1     ;;
      *.tar.xz)    tar -xf $1     ;;
      *.tgz)    	 tar -I pigz -xf $1     ;;
      *.bz2)       pbzip2 -d $1   ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *.lzma)      lzma -d -k $1  ;;
      *)     echo "'$1' cannot be extracted ()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function cz () {
  tar -I pigz -cf "`basename $1`.tar.gz" $1
}

function srvsave () {
  rsync --delete-after --rsync-path="sudo rsync" -aAX --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} srv.sav:/ /media/data/info/os/srv-backup
}

function vl() {
  dir=$(realpath "$1")
  editor "$dir"/$(ls -t $dir | head -1)
}

function la() {
  dir=$(realpath "$1")
  echo "$dir"/$(ls -t $dir | head -1)
}

function gls() {
  git log --all --grep="$1"
}

function ipfwd() {
  src=$1
  dst=$2
  port=$3
  sudo iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination $dst:$port
  sudo iptables -t nat -A POSTROUTING -p tcp -d $dst --dport $port -j SNAT --to-source $src
  sudo bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
}

function servethis() {
  IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
  echo "http://$IP:8000"
  python2.7 -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'
}

function setpythonenv(){
    name=$1
    if [[ -z $PYTHONPATH ]]; then
        export PYTHONPATH=~/src
    else
        export PYTHONPATH=~/src:$PYTHONPATH
    fi
    source ~/.venvs/$name/bin/activate
}

function mount_ext4(){
    diskutil list
    printf '\t- choose partition to mount: '
    read partition
    printf '\t- choose mount point: '
    read point
    sudo ext4fuse /dev/$partition $point -o allow_other && echo "done"
}
