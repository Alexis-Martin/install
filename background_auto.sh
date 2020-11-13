#!/bin/bash

url="https://apod.nasa.gov/apod/"
date=`date +%y%m%d`
page="ap$date.html"

wget -O /tmp/$page "$url$page"
img=`cat /tmp/$page | grep IMG | cut -d \" -f2`
imgname=`echo $img | rev | cut -d / -f1 | rev`
wget -O /tmp/$imgname "$url$img"
rm /tmp/$page
dir=".wallpapers"

if [ ! -d "$HOME/$dir" ];
then
mkdir "$HOME/$dir"
fi

ext=`echo $imgname | rev | cut -d . -f1 | rev`

if [[ ${ext,,} == png || ${ext,,} == jpg || ${ext,,} == jpeg || ${ext,,} == tiff || ${ext,,} == bmp ]]
then
    mv /tmp/$imgname "$HOME/$dir/"
    ls "$HOME/$dir"
    PID=$(pgrep cinnamon-sessio | head -n1)
    export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
    gsettings set org.cinnamon.desktop.background picture-uri file://$HOME/$dir/$imgname
fi
