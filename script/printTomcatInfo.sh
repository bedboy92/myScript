#!/bin/bash

function PrintTomcatInfo() {

apache_bin=$(ps -ef | grep "httpd" | grep -v "grep" | awk '{print $8}' | head -n 1)

if [[ -n $apache_bin ]]; then
	apache_root=`$apache_bin -V | grep "HTTPD_ROOT" | awk -F '"' '{print $2}'`
#	jk=`$apache_bin -D DUMP_MODULES | grep jk_module | grep -v "grep"`
#           AH00112: Warning: DocumentRoot [/source/kssfedu/kssfedu] does not exist
#           AH00112: Warning: DocumentRoot [/source/kssfedu/kssfedu] does not exist
	jk=$(cat "$apache_root/conf/httpd.conf" | grep mod_jk.so)

	if [[ -n $jk ]]; then 
	        worker=$(find "$apache_root" -name "workers.properties")

		# worker is null, function exit
		if [[ -z $worker ]]; then
			return 0; 
		fi

		#worker.list=exam1, exam2, exam3 ==> ajp_name_list=exam1, exam2, exam3
		ajp_name_list=$(cat "$worker" | grep list | grep -v "#" | awk -F "=" '{print $2}' | sed -e 's/, / /g')
      	 	ajp_count=$(cat "$worker" | grep list | grep -v "#" |  awk -F "=" '{print $2}' | awk -F ", " '{print NF}')

		#To Save for VirtualHost ServerName
		server_name=()
		#To Save for ajp Port
		ajp_port=()
		#To Save for Tomcat Directory
		tomcat_home=()
		#To Save for Tomcat Excution Account
		exc_user=()
		#To Save for Tomcat Port

		#Package Install
                if [[ $apache_root == *"/etc/httpd"* ]]; then
                        vhosts_conf=$(find "$apache_root/conf" -name "*vhost*.conf")
		#Source Install
                else
                        vhosts_conf="$apache_root/conf/extra/httpd-vhosts.conf"
                fi

		# vhosts_conf is null, function exit
		if [[ -z $vhosts_conf ]]; then
			return 0;
		fi

		while read line;
		do
			virtualhost+="$line"$','
			if [[ "$line" == *"</VirtualHost>"* ]]; then
				for ajp_name in $ajp_name_list
				do
					if [[ "$virtualhost" == *"$ajp_name"* ]]; then
						server_name+=("`echo $virtualhost | \
                        			awk -F "," ' {
                                			for (i=1; i<=NF; i++) {
                                        			if ($i ~ "ServerName") {
                                                			print $i 
                                                			break
                                        			}
                                			}
                        			}'`")
						ajp_port+=("`cat "$worker" | grep port | grep "$ajp_name" | awk -F "=" '{print $2}'`")
					fi
				done 
				virtualhost=""
			fi
		done < "$vhosts_conf"

		for ((i=0 ; i < ajp_count; i++))
		do
			tomcat_pid=$(netstat -ntlup | grep "${ajp_port[i]}" | awk '{print $7}' | awk -F "/" '{print $1}')
			tomcat_port+=("`netstat -ntlup | grep "$tomcat_pid" | grep -v "${ajp_port[i]}"| grep "LISTEN" | grep -v "127.0.0.1" | awk '{print $4}' | awk -F ":" '{print $4}'`")
			
			tomcat_home+=("`ps -ef | grep "$tomcat_pid" | sed -e 's/\ /\n/g' | grep "^-Dcatalina.home" | awk -F "=" '{print $2}'`")
			exc_user+=("`ps -ef | grep "$tomcat_pid" | grep -v "grep" | awk '{print $1}'`")
			
			if [[ -z ${tomcat_port[i]} ]]; then
                                tomcat_port[i]=`cat "${tomcat_home[i]}/conf/server.xml" | grep "${ajp_port[i]}" | awk -F "redirectPort" '{print $2}' | awk -F "\"" '{print $2}'`
                        fi

		done

		#Print Tomcat Information
		echo -e "\033[32m[Tomcat Information]\033[0m"

		rows="%-7s |%-30s |%-10s |%-40s\n"
		printf "%-7s %-31s %-11s %-40s\n" User Domain Port Directory
		for ((i=0 ; i < ajp_count; i++))
		do
			server_name[i]=`echo ${server_name[i]} | awk '{print $2}'`
			printf "$rows" "${exc_user[i]}" "${server_name[i]}" "${ajp_port[i]}" "${tomcat_home[i]}"
		done
	
	fi

fi

}

PrintTomcatInfo
