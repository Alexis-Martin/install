alias eliasuni='emacs ~/install/config/aliases-unistellar.sh'
alias sfrroute='echo '\''Switching to 192.168.0.254(ovh)'\''; sudo ip route del default via 192.168.0.1; sudo ip route add default via 192.168.0.254'
alias ovhroute='echo '\''Switching to 192.168.0.1(sfr)'\''; sudo ip route del default via 192.168.0.254; sudo ip route add default via 192.168.0.1'
alias s3evraw='s3fs s3-evraw-us-east-1 /media/s3 -o uid=1000,gid=1000,umask=0007,endpoint="eu-west-3"'
alias s3evdark='s3fs s3-darkframes-us-east-1 /media/s3_dark -o uid=1000,gid=1000,umask=0007,endpoint="eu-west-3"'
alias as='astyle --style=mozilla --indent=tab --attach-closing-while --align-pointer=name --keep-one-line-blocks --pad-header'
alias evbuild="./build.sh dirclean-all && ./build.sh"
alias evrebuild="./build.sh clean && ./build.sh"
alias pevrebuild="./build-prod.sh clean && ./build-prod.sh evsoft-dirclean && ./build-prod.sh"
alias evinstall="./build.sh install-to-pi"
alias devrebuild="./build-dev.sh clean && ./build-dev.sh evsoft-dirclean && ./build-dev.sh"
alias evsshadd='ssh-add ~/.ssh/id_pi_rsa'
alias evstackb='evbuildpc evstack'
alias evstackbprod='pevbuildpc evstack'
alias cpevdb='cp ./afdstarmap.db /home/alexis/src/eVsoft/buildroot/output/build/dataro'
alias scpevdb='scp evscope:/media/ro/afdstarmap.db /home/alexis/src/eVsoft/buildroot/output/build/dataro'
alias rmevlog='ssh evscope "rm -rf /media/rw/EnhancedVision_* /media/rw/Raw_* /media/rw/evsoft_*"'
alias cpevdata='rsync -avzz evscope:/media/rw/' #+ nom du dossier output
alias evstream='/home/alexis/src/eVsoft_tools/zmq/zmq_sub tcp://192.168.100.1:13009 | /home/alexis/src/eVsoft_tools/zmq/szbuf2frm | ffplay -probesize 128 -framerate 60/1 -fflags nobuffer -f png_pipe - > /dev/null 2>&1'
alias autn='ssh -C -f evgw -L 13009:192.168.100.1:13009 -N'
alias aulv='zmq_sub tcp://127.0.0.1:13009 | szfrm2buf | ffplay -probesize 128 -framerate 60/1 -'
alias auev='zmq_sub tcp://127.0.0.1:13009 | szfrm2buf | ffplay -probesize 128 -framerate 60/1 -fflags nobuffer -f png_pipe -'
alias aurlv='zmq_sub tcp://127.0.0.1:13009 | szfrm2buf | tee video.h264 | ffplay -probesize 128 -framerate 60/1 -'
alias datetoevscope='ssh evscope date -us @`( date -u +"%s" )`'
alias vpnuni='sudo openfortivpn marseille.unistellar.com:11443 -u amartin'

function ml_server(){
    name=$1
    if [[ "${name,,}" == start ]]; then
        aws ec2 start-instances --instance-ids i-088d9ab162c95faa4
    else
        aws ec2 stop-instances --instance-ids i-088d9ab162c95faa4
    fi
}

function evbuildpc(){
    name=$1
    make CXXFLAGS="-std=c++17 -flto -O2 -DNMMAL" APPS="$name" DESTDIR=~ install
}

function pevbuildpc(){
    name=$1
    make CXXFLAGS="-O2 -std=c++17 -fno-rtti -flto -DNDEBUG -DNDEV -DNMMAL" APPS="$name" DESTDIR=~ install
}
