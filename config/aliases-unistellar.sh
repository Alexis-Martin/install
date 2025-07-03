alias mnt_nas='if [ ! -e ~/nas/App ]; then
      mount_smbfs //amartin@nas.unistellar.com/data_1 ~/nas/
fi'
alias mnt_nasdata='if [ ! -e ~/nasdata/data ]; then
  mount_smbfs //amartin@nasdata.unistellar.com/data ~/nasdata/
fi'
alias mnt_mlvic='if [ ! -e ~/ml_vic/data ]; then
sshfs -o cipher=aes128-ctr -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,Compression=no,auto_cache,follow_symlinks victor@172.20.0.5:/home/victor/ ~/ml_vic
fi'
alias mnt_ml='if [ ! -e ~/ml/data ]; then
sshfs -o cipher=aes128-ctr -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,Compression=no,auto_cache,follow_symlinks alexis@172.20.0.5:/home/alexis/ ~/ml
fi'
alias eliasuni='emacs ~/install/config/aliases-unistellar.sh'
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

function app-to-pi(){
    app=$1
    echo $1
    tag=$(ssh -t analytics "cd ~/src/evbuilder/;git describe --tags --abbrev=0")
    echo "tag is " $tag
    ssh "root@$EVSTARGET" pkill $app
    echo "app killed " $app
    echo "copy ~/src/evbuilder/buildroot/output/build/evsoft-$tag/$app"
    scp analytics:~/src/evbuilder/buildroot/output/build/evsoft-$tag/$app ~/tmp
    scp -O ~/tmp/$app  "$EVSTARGET":/usr/bin
    
}

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
    make CXXFLAGS="-std=c++17 -flto -O2 -DNDEBUG -DNMMAL" TF_INC="-Ideps/imgproc/ispnet/tensorflow/include" TF_LDFLAGS="-Ldeps/imgproc/ispnet/tensorflow/lib" APPS="$name" DESTDIR=~ install
}

function pevbuildpc(){
    name=$1
    make CXXFLAGS="-O2 -std=c++17 -frtti -flto -DNDEBUG -DNDEV -DNMMAL" TF_INC="-Ideps/imgproc/ispnet/tensorflow/include" TF_LDFLAGS="-Ldeps/imgproc/ispnet/tensorflow/lib" APPS="$name" DESTDIR=~ install
}
