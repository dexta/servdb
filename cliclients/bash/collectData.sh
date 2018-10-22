#!/bin/bash

HOSTNAME=$(hostname)
ALLVAROUT=""
TARGETHOST="http://localhost:7423/inv/add"




ETH0_IP4=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)
ETH1_IP4=$(ip -f inet -o addr show eth1|cut -d\  -f 7 | cut -d/ -f 1)

ETH0_IP6=$(ip -6 -o addr show eth0 | cut -d\  -f 7 | cut -d/ -f 1)
ETH1_IP6=$(ip -6 -o addr show eth1 | cut -d\  -f 7 | cut -d/ -f 1)

ETH0_MAC=$(cat /sys/class/net/eth0/address)
ETH1_MAC=$(cat /sys/class/net/eth1/address)

ETH0_STATUS=$(cat /sys/class/net/eth0/operstate)
ETH1_STATUS=$(cat /sys/class/net/eth1/operstate)

CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
CPU_MHZ=$(lscpu | egrep "CPU max MHz.*([0-9]+)\." | egrep -o "[1-9][0-9]+")

RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')

DISK_GB_SDA=$(fdisk -l /dev/sda | grep GiB | awk '{print $3}')
DISK_GB_SDB=$(fdisk -l /dev/sdb | grep GiB | awk '{print $3}')
DISK_GB_SDC=$(fdisk -l /dev/sdc | grep GiB | awk '{print $3}')

if [[ -z "$HOSTNAME" ]]; then
	echo "no hostname exit with 1";
	exit 1;
fi

PREFIX_SERVER="server.$HOSTNAME"
ALLVAROUT="\"servername\":\"$HOSTNAME\""

if [ ! -z "$ETH0_IP4" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth0.ip4\":\"$ETH0_IP4\"";
fi

if [ ! -z "$ETH1_IP4" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth1.ip4\":\"$ETH1_IP4\"";
fi

if [ ! -z "$ETH0_IP6" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth0.ip6\":\"$ETH0_IP6\"";
fi

if [ ! -z "$ETH1_IP6" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth1.ip6\":\"$ETH1_IP6\"";
fi

if [ ! -z "$ETH0_MAC" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth0.mac\":\"$ETH0_MAC\"";
fi

if [ ! -z "$ETH1_MAC" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth1.mac\":\"$ETH1_MAC\"";
fi

if [ ! -z "$ETH0_STATUS" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth0.status\":\"$ETH0_STATUS\"";
fi

if [ ! -z "$ETH1_STATUS" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth1.status\":\"$ETH1_STATUS\"";
fi

if [ ! -z "$ETH0_IP4" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.network.eth0.ip4\":\"$ETH0_IP4\"";
fi

if [ ! -z "$CPU_COUNT" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.cpu.count\":\"$CPU_COUNT\"";
fi

if [ ! -z "$CPU_MHZ" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.cpu.mhz\":\"$CPU_MHZ\"";
fi

if [ ! -z "$RAM_KB" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.ram.kb\":\"$RAM_KB\"";
fi

if [ ! -z "$DISK_GB_SDA" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.disk.sda.gb\":\"$DISK_GB_SDA\"";
fi

if [ ! -z "$DISK_GB_SDB" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.disk.sdb.gb\":\"$DISK_GB_SDB\"";
fi

if [ ! -z "$DISK_GB_SDC" ]; then
	ALLVAROUT="$ALLVAROUT,\"$PREFIX_SERVER.hw.disk.sdc.gb\":\"$DISK_GB_SDC\"";
fi

ALLVAROUT="{$ALLVAROUT}"

# Working bad ugly solution 
echo $ALLVAROUT > /tmp/badgirldoitwell
curl --header "Content-Type: application/json" -X POST -d @/tmp/badgirldoitwell $TARGETHOST

# but the ugliness dont stop there

# Edisons 1k
# to simple
# curl --header "Content-Type: application/json" -X POST -d $ALLVAROUT $TARGETHOST