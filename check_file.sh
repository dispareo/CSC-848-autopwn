#!/bin/bash
apt-get update
apt-get install incron -y 

#inotifywait -m /usr/share/responder/logs/ -e create |
#    while read dir action file; do
#        ./send_it.sh
#    done
systemctl enable incron
echo "root" >> /etc/incron.allow
echo "pi" >> /etc/incron.allow
#If not pi, change to whatever your "regular" user is


echo "/usr/share/responder/logs/*.txt IN_CREATE echo ${PWD}/send_it.sh" >> incrontab

touch ${PWD}/incron.file

