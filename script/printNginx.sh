#/bin/bash

function PrintNginxVhost() {

nginx_bin=$(ps -ef | grep nginx | grep -v "grep" | grep master | awk '{print $11}')
if [[ -n $nginx_bin ]]; then
        nginx_vhost_list=`$nginx_bin -T | grep server_name`

	echo -e ""
	echo -e "\033[34m""Nginx vhosts list""\033[0m"
        echo "$nginx_vhost_list" | while read vhost_line
        do
                # Delete unnecessary lines
                if [[ "$vhost_line" == *"#"* ]] || [[ "$vhost_line" == *"_;"* ]] || [[ "$vhost_line" == *"fastcgi"* ]]; then
                        continue
                fi

                # String Pattern (server_name) remove
                real_vhost=`echo ${vhost_line//server_name/""}`

		echo $real_vhost
        done
fi

}

function PrintNginxInfo() {

nginx_bin=$(ps -ef | grep nginx | grep -v "grep" | grep master | awk '{print $11}')
if [[ -n $nginx_bin ]]; then
        nginx_version=`$nginx_bin -v > /dev/null`
#        echo -e "Nginx Version : " $nginx_version"\n"
fi
}



