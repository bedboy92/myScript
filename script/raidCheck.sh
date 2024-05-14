#!/bin/bash

function HP_RaidCheck() {
#HP Server Raid Check
ProductName=$(dmidecode -s system-product-name)
if [[ $ProductName == *Gen10* ]]; then
        ssacli ctrl all show config
elif [[ $ProductName == *Gen9* ]]; then
        hpssacli ctrl all show config
        if [ $? -eq 127 ]; then
                ssacli ctrl all show config
        fi
else
        hpacucli ctrl all show config
        if [ $? -eq 127 ]; then
                hpssacli ctrl all show config
                if [ $? -eq 127 ]; then
                        ssacli ctrl all show config
                fi
        fi
fi
}

function IBM_RaidCheck() {
#Lenovo Server Raid Check
bit=$(getconf LONG_BIT)
if [ $bit -eq 64 ]; then
        /opt/MegaRAID/MegaCli/MegaCli64 -ShowSummary -aALL
#	if [ $? -eq 127 ]; then
#		echo -e "Raid Tool non exist..."
#	fi
elif [ $bit -eq 32 ]; then
        /opt/MegaRAID/MegaCli/MegaCli -ShowSummary -aALL
#	if [ $? -eq 127 ]; then
#                echo -e "Raid Tool non exist..."
#        fi
fi
}
