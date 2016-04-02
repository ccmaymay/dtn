#!/bin/bash

iface=eth0
start_port=1
end_port=65535

default_rate=100mbit

if [ $# -lt 1 ]
then
    rate=$default_rate
elif [ $# -gt 1 -o "$1" == "-h" -o "$1" == "--help" ]
then
    echo "Configure TCP bandwidth limit globally."
    echo "Usage: $0 [rate]"
    echo
    echo "  rate:  bandwidth limit, e.g., 10mbit"
    echo "         (see http://linux.die.net/man/8/tc for syntax);"
    echo "         default: $default_rate"
    exit
else
    rate="$1"
fi

iptables -t mangle -A POSTROUTING -o $iface -p tcp --sport $start_port:$end_port -j CLASSIFY --set-class 1:1
tc qdisc add dev $iface parent root handle 1:0 htb
tc class add dev $iface parent 1:0 classid 1:1 htb rate $rate
