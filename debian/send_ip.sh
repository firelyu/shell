#!/bin/sh

FROM="Raspberry Pi <liaoyu17@gmail.com>"
TO='liaoyu17@gmail.com'
SUBJECT='Raspberry Pi IP address'

ETH='eth0'

hostname="$(hostname)"
date="$(date +'%F %X')"
ipinfo=`ifconfig $ETH`

sendmail -t <<EOF
From: $FROM 
To: $TO
Content-type: text/html;charset=utf-8
Subject: $SUBJECT
<html>
    <body>
        <p>Date : $date</p>
        <p>Hostname : $hostname</p>
        <p>IP : $ipinfo</p>
    </body>
</html>
EOF
