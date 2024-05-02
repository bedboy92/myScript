#/bin/bash



function PrintApacheVhost() {

apache_bin=$(ps -ef | egrep "httpd|apache" | grep -v "grep" | awk '{print $8}' | head -n 1)

if [[ -n $apache_bin ]]; then
        apache_vhost_list=`$apache_bin -S`
        apache_vhost_port=$(netstat -ntlup | egrep "httpd | apache" | awk '{print $4}' | awk -F":" '{print $4}')

        apache_port_count=0

        echo "$apache_vhost_port" | while read port_line;
        do

                if [[ "$apache_vhost_list" == *"$port_line"* ]]; then
                        echo -e "\033[34m"$((++lineCount))"." $port_line "vhosts list""\033[0m"

                        echo "$apache_vhost_list" | while read vhost_line;
                        do
                                ## ex) 211.172.246.110:443    is a NameVirtualHost not print
                                if [[ "$vhost_line" == *"NameVirtualHost"* ]]; then
                                        continue
                                fi

                                if [[ "$vhost_line" == *"namevhost"* ]] && [[ "$vhost_line" == *"$port_line"*  ]]; then
                                        vhost=`echo "$vhost_line" | awk '{print $4}'`
                                        echo -e $vhost
                                elif [[ "$vhost_line" == *"$port_line"* ]]; then
                                        vhost=`echo "$vhost_line" | awk '{print $2}'`
                                        echo -e $vhost
                                fi
                        done
                        echo -e ""
                fi

        done

fi


}

function PrintApacheInfo() {

apache_bin=$(ps -ef | egrep "httpd|apache" | grep -v "grep" | awk '{print $8}' | head -n 1)
if [[ -n $apache_bin ]]; then
        apache_version=`$apache_bin -v`

        echo -e "Apache Version : " $apache_version"\n"
fi

}

