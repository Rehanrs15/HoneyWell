#!/bin/bash

mac=`ifconfig |awk '/HWaddr/ {print $5;exit;}'`  #Extracting mac address
doWork()
{
INTERFACE=`ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)'`         #Employee connected interface
if [ -z $INTERFACE ];
then
echo "Not connected to internet"
elif [[ $INTERFACE == w* ]] ; then 
rmac=`sudo iwconfig $INTERFACE | grep "Access Point" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'`  #WIFI
echo "Connected to WIFI"
else 
def=`netstat -rn | grep -m 1 '0.0.0.0' | awk '{print $2}'`              #default gateway
	if [ -z $def ];
	then
	echo "Not connected to internet"
	else 
	rmac=`arp -n $def |awk '/ether/ {print $3}'`  #Ethernet
	echo "Connected to Eternet"
	fi
fi



mac="$(echo "${mac//:}")"
mac=`echo $mac | tr 'a-z' 'A-Z'`
rmac="$(echo "${rmac//:}")"
rmac=`echo $rmac | tr 'a-z' 'A-Z'`




echo $mac
echo $rmac

#------------------------wget post request----------------------------------------#
if [ -z $rmac ];
then
echo "No post request"
else
wget -O- -q --header="Content-type:application/json" --post-data='{"mac":'\""$mac"\"',"rmac":'\""$rmac"\"'}' "http://agileseat.890m.com/agile/fill.php"
echo "post req successful"
fi
#--------------------------------------------------------------------#
}
#----------------------------------------------------
while true;
do
doWork
echo "----------------------NEXT CALL----------------------------------------"
sleep 10m
done
