inotifywait -m /usr/share/responder/logs/ -e create |
    while read dir action file; do
        ./send_it.sh
    done
