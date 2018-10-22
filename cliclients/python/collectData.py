#!/usr/bin/env python
import os
infocmds = {
  "hw": {
    "network": {
      "eth0": {
        "ip4": "ip -f inet -o addr show eno1|cut -d\  -f 7 | cut -d/ -f 1",
        "ip6": "ip -6 -o addr show eth0 | cut -d\  -f 7 | cut -d/ -f 1",
        "mac": "cat /sys/class/net/eth0/address",
        "status": "cat /sys/class/net/eth0/operstate"
      }
    },
    "cpu": {
      "count": "grep -c ^processor /proc/cpuinfo",
      "mhz": "lscpu | egrep \"CPU max MHz.*([0-9]+)\.\" | egrep -o \"[1-9][0-9]+\""
    },
    "ram": {
      "mb": "grep MemTotal /proc/meminfo | awk '{print $2}'"
    },
    "disk": {
      "sda": {
        "gb": "fdisk -l /dev/sda | grep GiB | awk '{print $3}'"
      }
    }
  }
}


def getch():
  return os.popen("ip -f inet -o addr show eno1|cut -d\  -f 7 | cut -d/ -f 1").read().replace("\n","")

# print(getch())

def getshell(cmd):
  return os.popen(cmd).read().replace("\n","")


def walkCMDs(cmdlist,prefix):
  for key, item in cmdlist.items():  
    if isinstance(item,dict):
      walkCMDs(item,prefix+"."+key)
    else:
      # print(prefix+"."+key+":"+item)
      reItem = getshell(item)
      if not reItem:
        continue
      print(prefix+"."+key+":"+reItem)



walkCMDs(infocmds,'server.lxtest01')