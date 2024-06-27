##/bin/sh

function PrintSysInfo() {

hostname=$(hostname)
ipaddr=$(curl -s ifconfig.me)
uptime=$(uptime | awk -F " " '{print $3,$4}')

os=$(cat /etc/os-release | grep "PRETTY_NAME" | awk -F '"' '{print $2}')
if [[ "$os" == *"Cent"* ]]; then
	os=$(cat /etc/redhat-release)
fi


model=$(dmidecode -s system-product-name)
cpu=$(cat /proc/cpuinfo | grep -m 1 'model name' | awk -F ":" '{print $2}')
cpuCount=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)EA 
cpuCore=$(cat /proc/cpuinfo | grep -m 1 'cpu cores' | awk -F: '{print $2}')Core
cpuThread=$(dmidecode -t Processor | grep Thread | grep -v "Hardware" | awk -F ":" '{print $2}')Thread
pMem=$(free -m | grep Mem | awk '{print $2}')
sMem=$(free -m | grep Swap | awk '{print $2}')

echo -e "\033[32m     [ $hostname ]                           \033[0m"
echo "                                                               "
echo -e "\033[0m - OS : \033[32m $os                                 "
echo -e "\033[0m - Server Model : \033[32m $model                    "
echo -e "\033[0m - IP Address : \033[32m $ipaddr                     "
echo -e "\033[0m - System Uptime : \033[32m $uptime                  "
echo -e "\033[0m - CPU : \033[32m ${cpu} * $cpuCount                 "
echo -e "\033[32m          $cpuCore ${cpuThread}                     "
echo -e "\033[0m - Phys Memory : \033[32m ${pMem}M                   "
echo -e "\033[0m - Swap Memory : \033[32m ${sMem}M \033[0m\n         "

}
