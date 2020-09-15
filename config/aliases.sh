export EDITOR='emacs --no-window'
alias rm='trash'
alias ealias='emacs --no-window ~/.aliases.sh'
alias sshlist='cat ~/.ssh/config'
alias in='sudo apt-get install -y'
alias out='sudo apt-get purge'
alias q='exit'
alias up='sudo apt-get update && sudo apt-get upgrade'
alias d='wget -c'
alias c='clear'
alias cl='sudo apt-get clean;sudo apt-get -y autoremove --purge; sudo apt-get -y purge `deborphan`'
alias m='mount | column -t'
alias l='ls -lAh --color'
alias sl='sudo ls -lah --color'
alias ll='ls -lAh --color'
alias ls='ls --color'
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
alias hs='history | tail -n50'
alias s='sudo !!'
alias xp='xbacklight +10'
alias xm='xbacklight -10'
alias dm='sudo dmesg -cHw'
alias bw='wget http://test-debit.free.fr/image.iso -O /dev/null'
alias sudo='sudo '
alias n='sudo netstat -lptnu'
alias si='sudo ifconfig'
alias afs='apt-file search'
alias b='watch -n1'
alias pt='ping -c1 google.de'
alias cc='sync; echo 3 | sudo tee /proc/sys/vm/drop_caches'
alias dds='sudo pkill -USR1 dd'
alias setenv='setpythonenv python-3'

function res(){
  if [ $6 ] ; then
    width1="$(echo $2 | cut -dx -f1)"
    width2="$(echo $4 | cut -dx -f1)"
    (( width2 += width1 ))
    xrandr --output $1 --mode $2 --pos 0x0 --output $3 --mode $4 --pos ${width1}x0 --output $5 --mode $6 --pos ${width2}x0
  else
    if [ $4 ] ; then
      width="$(echo $2 | cut -dx -f1)" 
      xrandr --output $1 --mode $2 --primary --pos 0x0 --output $3 --mode $4 --pos ${width}x0
    else
      if [ $2 ] ; then
	xrandr --output $1 --mode $2
      else
	if [ $1 ] ; then
	  xrandr --output eDP-1 --mode $1
	else
	  xrandr
	fi
      fi
    fi
  fi
}

function connect(){
    if [ $1 ] ; then
        sudo dhclient -v $1
    else
        sudo dhclient -v enx106530018c34
    fi
}

function wifi(){
  if [ $1 ] ; then
    nmcli d wifi connect $1 password $2 iface wlp2s0
  else
    sudo iwlist wlp2s0 scan | grep ESSID
  fi

}

function mkc() {
  mkdir -p $1 && cd $1
}

function debchange () {
  zless "/usr/share/doc/$1/changelog.Debian.gz"
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

function databackup () {
  function exit_backup() {
    echo "** Trapped CTRL-C"
    sudo umount /media/backup
  }
  #trap exit_backup INT
  sudo fsck -y /dev/disk/by-label/data_backup
  sudo mount /media/backup &&\
    rsync -av --info=progress2 --exclude 'lost+found' --exclude '.Trash-*' --delete-after /media/data/ /media/backup/ &&\
    sync &&\
    sudo umount /media/backup
}

function srvsave () {
  rsync --delete-after --rsync-path="sudo rsync" -aAX --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} srv.sav:/ /media/data/info/os/srv-backup
}

function kc () {
  sudo apt-get purge $(for tag in "linux-image" "linux-headers"; do dpkg-query -W -f'${Package}\n' "$tag-[0-9]*.[0-9]*.[0-9]*" | sort -V | awk 'index($0,c){exit} //' c=$(uname -r | cut -d- -f1,2); done)
}

function vl() {
  dir=$(realpath "$1")
  editor "$dir"/$(ls -t $dir | head -1)
}

function la() {
  dir=$(realpath "$1")
  echo "$dir"/$(ls -t $dir | head -1)
}

function naton() {
  sudo iptables -t nat -A POSTROUTING -o "$1" -j MASQUERADE && echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
}

function natoff() {
  sudo iptables -t nat -D POSTROUTING -o "$1" -j MASQUERADE && echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward
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

function re() {
  sudo ifconfig $1 down; sudo ifconfig $1 up
}

function setpythonenv(){
    name=$1
    export PYTHONPATH=$PYTHONPATH:~/src/
    export JUPYTER_PATH=$JUPYTER_PATH:$HOME/src/eval
    source ~/.venvs/$name/bin/activate
}
