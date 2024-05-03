#!/bin/bash

function PrintTomcatInfo () {

tomcat_bin=$(ps -ef | grep tomcat | grep -v "grep")

if [[ -n $tomcat_bin ]]; then

        lineCount=0

        echo "$tomcat_bin" | while read line; do
        tomcat_home=`echo "$line" | sed -e 's/\ /\n/g' | grep "^-Dcatalina.base" | awk -F"=" '{print $2}'`

        tomcat_info=$tomcat_home/bin/version.sh
        tomcat_version=$($tomcat_info | grep "^Server version:" | awk -F": " '{print $2}')
        java_version=$($tomcat_info | grep "^JVM Version" | awk -F": " '{print $2}')

        echo -e "\033[34m""Tomcat "$((++lineCount))"\033[0m"
        echo "Java Version : " $java_version
        echo "Tomcat Home : " $tomcat_home
        echo -e "Tomcat Version : " $tomcat_version "\n"

        done
fi

}

