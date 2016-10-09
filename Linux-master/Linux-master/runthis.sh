#!/bin/bash

`sudo chmod 777 /etc/rc.local`
`sudo chmod +x linux.sh`
`sudo sed -i 's/exit 0//g' /etc/rc.local`
`sudo readlink -f linux.sh >> /etc/rc.local`
`sudo echo "exit 0" >> /etc/rc.local`

echo "Successful"
