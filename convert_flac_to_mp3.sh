#!/bin/bash

filtro=$(echo "$1" | grep \ )
if [[ $filtro ]];then
  name_directory=$(echo $1 | tr "\ " "_")
  mv "$1" "$name_directory"
else
  name_directory=$1
fi

if [[ "$name_directory" != *"/"* ]]; then
  dir="$name_directory/"
else
  dir="$name_directory"
fi


directory=$(ls -v $dir)
output="converted_mp3"

if [ ! -d $output ]; then
  mkdir -p $output/$dir
fi

for item in $dir*; do
  finalName=$(echo $item | tr "\ " "_")
  mv "$item" "$finalName"
  input=$finalName
  name=${finalName%\.flac*}
  mp3Generate="$output/$name.mp3"
  ffmpeg -i $input -ab 320k -map_metadata 0 -id3v2_version 3 $mp3Generate
done

echo "___________________"
echo "___________________"
echo
echo " Finished, files saved in '$output/$dir' directory."
echo "___________________"
echo "___________________"
