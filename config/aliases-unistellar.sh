alias mnt_nas='if [ ! -e ~/nas/App ]; then
  mount_smbfs //amartinB@nas.unistellar.com/data_1 ~/nas/
fi'
alias mnt_nasdata='if [ ! -e ~/nasdata/data ]; then
  mount_smbfs //amartin@nasdata.unistellar.com/data ~/nasdata/
fi'
alias eliasuni='emacs ~/install/config/aliases-unistellar.sh'
alias s3evraw='s3fs s3-evraw-us-east-1 /media/s3 -o uid=1000,gid=1000,umask=0007,endpoint="eu-west-3"'
alias s3evdark='s3fs s3-darkframes-us-east-1 /Users/alexis/s3_dark -o uid=1000,gid=1000,umask=0007,endpoint="eu-west-3"'
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
alias evstream_legacy='/home/alexis/src/eVsoft_tools/zmq/zmq_sub tcp://192.168.100.1:13009 | /home/alexis/src/eVsoft_tools/zmq/szbuf2frm | ffplay -probesize 128 -framerate 60/1 -fflags nobuffer -f png_pipe - > /dev/null 2>&1'
alias autn='ssh -C -f evgw -L 13009:192.168.100.1:13009 -N'
alias aulv='zmq_sub tcp://127.0.0.1:13009 | szfrm2buf | ffplay -probesize 128 -framerate 60/1 -'
alias auev='zmq_sub tcp://127.0.0.1:13009 | szfrm2buf | ffplay -probesize 128 -framerate 60/1 -fflags nobuffer -f png_pipe -'
alias aurlv='zmq_sub tcp://127.0.0.1:13009 | szfrm2buf | tee video.h264 | ffplay -probesize 128 -framerate 60/1 -'
alias datetoevscope='ssh evscope date -us @`( date -u +"%s" )`'
alias vpnuni='sudo openfortivpn marseille.unistellar.com:11443 -u amartin'
alias downloadevsoftlog='evclient -F ../../../media/rw/evsoft.log 192.168.100.1'
alias startdynamo="java -Djava.library.path=~/external_src/dynamodb/DynamoDBLocal_lib -jar ~/external_src/dynamodb/DynamoDBLocal.jar -dbPath ~/data -sharedDb"

function aws_ssh() {
    user="ubuntu"
    identify_key="~/.ssh/id_ed25519_gitlab_perso"
    target_host="aws_sandbox"
        
    servers=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,Tags[0].Value,State.Name, NetworkInterfaces[0].Association.PublicIp]' --output text)
    line_number=1

    # Iterate through each line in the variable
    while IFS= read -r line; do
	# Print the line number and the line content
	echo "[$line_number] $line"
  
	# Increment the line number
	((line_number++))
    done <<< "$servers"

    echo "Which server you want to connect to: "

    # Read the user input into a variable
    read user_number
    selected_line=$(echo "$servers" | sed -n "${user_number}p")

    IFS=$'\t' read -ra words <<< "$selected_line"
    if [ "${words[2]}" == "stopped" ]; then
	echo "Start instance!"
	aws ec2 start-instances --instance-ids ${words[0]}

	status=$(aws ec2 describe-instance-status --instance-id ${words[0]}  --output text)
	echo $status
	while [ "$status" == "" ]; do
	    # Sleep for one second
	    sleep 1
	    status=$(aws ec2 describe-instance-status --instance-id i-08412aaf3d4c61339 --output text)
	done
	sleep 1
    fi
    instance=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,Tags[0].Value,State.Name,NetworkInterfaces[0].Association.PublicIp]' --instance-id ${words[0]} --output text)
    IFS=$'\t' read -ra words <<< "$instance"
    ip=${words[3]}

    # Find the line number containing "Host aws_sandbox"
    line_number=$(grep -n "Host $target_host" ~/.ssh/config | cut -d: -f1)

    # Find the line number containing "HostName" just after the target host
    hostname_line_number=$((line_number + 1))
    hostname_line=$(sed -n "${hostname_line_number}p" ~/.ssh/config)

    # Modify the HostName line if found
    if [[ $hostname_line == *"HostName"* ]]; then
	sed -i '' "${hostname_line_number}s/.*/    HostName $ip/" ~/.ssh/config
    fi

    ssh $target_host
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
    make CXXFLAGS="-std=c++17 -flto -O2 -DNDEBUG -DNMMAL" APPS="$name" DESTDIR=~ install
}

function pevbuildpc(){
    name=$1
    make CXXFLAGS="-O2 -std=c++17 -fno-rtti -flto -DNDEBUG -DNDEV -DNMMAL" APPS="$name" DESTDIR=~ install
}
