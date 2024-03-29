#!/bin/bash

sudo apt install ffmpeg

(echo "Имя,Расширение,Время изменения,Размер,Длительность")>./files.xls #First string creation
files()									#Function needed to run script recursively
{
(
for file in "$1"/*							#Counting for each file
do

  #Name
  fname=$(echo "${file##*./}")						#name without ./  in the beginning
  name=$(echo "${fname}"|rev|cut -f2- -d.|cut -f1 -d/| rev)		#just the name of the file, without extension
  if [[ $name == "*" ]]; then						#skipping "garbage"
	continue
  fi
  printf "$name\t"
  
  #Extension
  ext=$(echo "${fname}"|rev|cut -f1 -d.|cut -f1 -d/| rev)		#extension as everything after the last dot
  if [ -d "$file" ]; then
	ext="Folder"
  elif [[ $ext == $name ]]; then					#checking if file has no extension
	ext="None"
  fi	
  printf "$ext\t"

  #Ch-Ch-Ch-Ch-Changes
  #It`s time when changes are made
  time=$(echo $(stat --printf="%z" "$file"))
  printf "$time\t"
	
  #Size
  if [ -d "$file" ]; then
	size="Folder"
	num=""
  else
  	size=$(wc -c <"$file")
  	num="b"
  	if (("$size" > "1023")); then 					#counting in Kb if file is at least one Kb
		size=$(echo "$size/1024"|bc)
		num="Kb"
  		if (("$size" > "1023")); then				#counting in Mb if file is at least one Mb
			size=$(echo "$size/1024"|bc)
			num="Mb"
		fi
	fi
  fi

  printf "$size$num\t"

  #Length
  if [ -f "$file" ]; then
	length=$(ffprobe -v quiet -print_format ini -show_format "$file" | grep duration | sed s/duration=//)
	printf "$length"
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
