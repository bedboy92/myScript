#!/bin/bash

#source ./script/*
#source ./script/printNginxVhost.sh

## why?!!??!?!?!?!?!??!?!?!?!??!?!
#source_list=$(ls -al ./script | grep ".sh" | awk '{print $9}')
#echo "$source_list" | while read file 
#do
#	echo "./script/${file}"
#	source ./script/${file}
#done

## To source script file...
source_list=`ls -al ./script | grep ".sh" | awk '{print $9}'`
for file in $source_list
do
	source ./script/${file}
done

web_service=$(netstat -ntlup | grep -v "8080" | grep "80" | awk '{print $7}' | awk -F"/" '{print $2}')

if [[ "$web_service" == *"httpd"* ]] || [[ "$web_service" == *"apache"* ]]; then
	PrintApacheInfo
	PrintApacheVhost
elif [[ "$web_service" == *"nginx"* ]]; then
	PrintNginxInfo
	PrintNginxVhost
fi

