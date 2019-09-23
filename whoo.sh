#!/bin/bash
(echo "Имя,Расширение,Время изменения,Размер,Длительность")>./files.xls
files()
{
(
for file in "$1"/*
do

  #Name
  fname=$(echo "${file##*./}")
  name=$(echo "${fname}"|rev|cut -f2- -d.|cut -f1 -d/| rev)
  if [[ $name == "*" ]]; then
	continue
  fi
  printf "$name\t"
  
  #Extension
  ext=$(echo "${fname}"|rev|cut -f1 -d.|cut -f1 -d/| rev)
  if [ -d "$file" ]; then
	ext="Folder"
  elif [[ $ext == $name ]]; then
	ext="None"
  fi	
  printf "$ext\t"

  #Ch-Ch-Ch-Ch-Changes
  #It`s time when changes are made
  time=$(echo $(stat --printf="%z" "$file"))
  printf "$time\t"
	
  #Size
  if [ -d "$file" ]; then
	size="Fol"
	num="der"
  else
  	size=$(wc -c <"$file")
  	num="b"
  	if (("$size" > "1023")); then 
		size=$(echo "$size/1024"|bc)
		num="Kb"
  		if (("$size" > "1023")); then
			size=$(echo "$size/1024"|bc)
			num="Mb"
		fi
	fi
  fi

  printf "$size$num\t"

  #Length
  if [[ $ext == "mkv" || $ext == "mp4" ]]; then
	printf $(mediainfo "$file"|head -n7|tail -n1|cut -c44-)
  elif [[ $ext == "mp3" ]]; then
	printf $(mediainfo "$file"|head -n5|tail -n1|cut -c44-)
  elif [[ $ext == "avi" ]]; then
	printf $(mediainfo "$file"|head -n6|tail -n1|cut -c44-)
  elif [[ -d "$file" && $(echo "$file"|wc -l) -ne 0 ]]; then
	printf "\n"
	files "$file"
	continue
  fi
  
  #Next Line
  printf "\n"

done)>>./files.xls
}
files .

