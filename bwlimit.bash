#!/bin/bash

iface=eth0
start_port=1
end_port=65535

if [ $# -lt 1 ]
then
    rate=1mbps
elif [ "$1" == "-h" -o "$1" == "--help" ]
then
    echo "usage: $0 [rate]"
    echo
    echo "where rate is e.g. 10mbps or 10mbit"
    echo "(meaning 10 MB/s or 10 Mb/s, respectively);"
    echo "for more information, see: http://linux.die.net/man/8/tc"
    exit
else
    rate="$1"
fi

iptables -t mangle -A POSTROUTING -o $iface -p tcp --sport $start_port:$end_port -j CLASSIFY --set-class 1:1
tc qdisc add dev $iface parent root handle 1:0 htb
tc class add dev $iface parent 1:0 classid 1:1 htb rate $rate
