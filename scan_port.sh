#!/bin/sh

for addr in `netstat -atn | sed 's/\s\+/ /g' | cut -d' ' -f3`; do
    curl -s http://$addr >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Available : $addr"
    fi
done
