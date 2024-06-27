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

## Print web service 
web_service=$(netstat -ntlup | grep -v "8080" | grep "80" | awk '{print $7}' | awk -F"/" '{print $2}')

if [[ "$web_service" == *"httpd"* ]] || [[ "$web_service" == *"apache"* ]]; then
	PrintApacheInfo
	PrintApacheVhost
elif [[ "$web_service" == *"nginx"* ]]; then
	PrintNginxInfo
	PrintNginxVhost
fi

## Print was service
was_service=$(ps -ef | grep tomcat | grep -v "grep")

if [[ -n $was_service ]]; then
	PrintTomcatInfo
fi

## Print DB service
mysql_bin=$(ps -ef | grep mysql | grep -v "mysqld_safe" |grep -v "grep" | grep -v "bb")

if [[ -n $mysql_bin ]]; then
	PrintMysqlInfo
fi

## Raid Check 
echo -e "\033[34m""Raid Check...! ""\033[0m" 
product_name=$(dmidecode | grep Product)

mega_vendor="IBM, Lenovo, Dell, LENOVO"

if [[ "$product_name" == *"HP"* ]] ; then
	HP_RaidCheck
elif [[ "$product_name" == *"$mega_vendor"*  ]]; then
	IBM_RaidCheck
else
	echo -e "What is vendor??"
fi
