#!/bin/bash

#DB(MYSQL)

function PrintMysqlInfo() {

mysql_bin=$(ps -ef | grep mysql | grep -v "mysqld_safe" |grep -v "grep" | grep -v "bb")

if [[ -n $mysql_bin ]]; then

        lineCount=0

	echo -e "\033[34mMysql Infomation\033[0m"
        echo "$mysql_bin" | while read line; do

                # package install
                if [[ $mysql_bin == *"/usr/sbin"*  ]]; then
                        mysql_true_bin=`echo "$mysql_bin" | awk '{print $8}'`
                        mysql_version=$($mysql_true_bin -V)
                        mysql_true_version=`echo "$mysql_version" | awk '{print $3}' `
                        mysql_pid=`echo "$line" | awk '{print $2}'`

                        port_search=$(netstat -ntlup | grep $mysql_pid)
                        if [[ $port_search == *"tcp6"*  ]]; then
                                port=`echo "$port_search" | awk '{print $4}' | awk -F":" '{print $4}'`
                        else
                                port=`echo "$port_search" | awk '{print $4}' | awk -F":" '{print $2}'`
                        fi

			
                        echo "Mysql "$((++lineCount))
                        echo -e "Mysql Version : ". "\033[32m$mysql_true_version\033[0m"
                        echo -e "Port : ". "$\033[32mport\033[0m"
#                       echo -e "Directory : \033[32m/var/lib/mysql\033[0m"

                # source install
                else
                        baseDirectory=`echo "$line" | sed -e 's/\ /\n/g' | grep "^--basedir" | awk -F"=" '{print $2}'`
                        port=`echo "$line" | sed -e 's/\ /\n/g' | grep "^--port" | awk -F"=" '{print $2}'`
                        mysql_version=$($baseDirectory/bin/mysql --version | awk '{print $5}')

			echo "Mysql "$((++lineCount))
                        echo -e "Mysql Directory :". "\033[32m$baseDirectory\033[0m"
                        echo -e "Mysql Version :". "\033[32m$mysql_version\033[0m"
                        echo -e "Port :". "\033[32m$port\033[0m\n"

                fi

        done
fi

}
