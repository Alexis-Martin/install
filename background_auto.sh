#!/bin/bash

url="https://apod.nasa.gov/apod/"
date=`date +%y%m%d`
page="ap$date.html"
wget "$url$page"
img=`cat $page | grep IMG | cut -d \" -f2`
wget "$url$img"
imgname=`echo $img | rev | cut -d / -f1 | rev`
rm $page
dir=".wallpapers"

if [ ! -d "$HOME/$dir" ];
then
mkdir "$HOME/$dir"
fi

ext=`echo $imgname | rev | cut -d . -f1 | rev`

if [[ ${ext,,} == png || ${ext,,} == jpg || ${ext,,} == jpeg || ${ext,,} == tiff || ${ext,,} == bmp ]]
then
    mv $imgname $dir/
    gsettings set org.cinnamon.desktop.background picture-uri "file://$HOME/$dir/$imgname"
fi
