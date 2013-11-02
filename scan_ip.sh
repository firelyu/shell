#!/bin/sh
# The shell scan the available IPs in the input network.
LOG_FILE='scan_ip.log'

head="$1"

count=0
echo $(date) | tee -a  $LOG_FILE
for last in {1..255}; do
    addr="$head.$last"
    ping -c 4 $addr 2>&1 > /dev/null
    if [ $? -ne 0 ]; then
        echo "$addr" | tee -a  $LOG_FILE
        count=$[$count + 1]
    fi
done

echo "There are totally $count available ip address." | tee -a  $LOG_FILE
