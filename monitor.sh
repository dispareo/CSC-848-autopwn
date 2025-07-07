inotifywait -m /usr/share/responder/logs -e create |
    while read dir action file; do
        /home/pi/CSC-848-autopwn/send_it.sh $file
    done