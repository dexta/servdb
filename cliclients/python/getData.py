#!/usr/bin/env python

import os
import re
import json


# regEx grep relevant data

# bash -c ip address
# counter , name, status, state, mtu
# (^[0-9]{1,2})\:\s([a-z0-9\_\-]+)\:\s\<([A-Z\_\-\,]+)\>\smtu\s([0-9]+).*state\s([A-z]+)\s.*
REG_NAME = re.compile('(^[0-9]{1,2})\:\s([a-z0-9\_\-]+)\:\s\<([A-Z\_\-\,]+)\>\smtu\s([0-9]+).*state\s([A-z]+)\s.*')
# capture the mac address of the ethnet device
# \s*link\/ether\s([0-9a-f\:]+)\sbrd
REG_ETHER = re.compile('\s*link\/ether\s([0-9a-f\:]+)\sbrd')
# ip v4 address and slash netmask
# \s+inet\s([0-9]{1,3}\.[0-9]{1,3}\.[0-9]\.[0-9])\/([0-9]{1,2})\sbrd\s
REG_IP4 = re.compile('\s+inet\s([0-9]{1,3}\.[0-9]{1,3}\.[0-9]\.[0-9])\/([0-9]{1,2})\s')
# ip 6 address and netmask
# \s+inet6\s([0-9a-f\:]+)\/([0-9]+)
REG_IP6 = re.compile('\s+inet6\s([0-9a-f\:]+)\/([0-9]+)')

# bash -c fdisk -l
# disk path with full volume
# ^Disk\s(\/[a-z]+\/[a-z]+)\:\s([0-9\.]+)\sGiB
REG_DISKPATH = re.compile('^Disk\s\/([a-z]+)\/([a-z]+)\:\s([0-9\.]+)\s([a-zA-Z])')
# disk pathbase
REG_DISKBASE = re.compile('^\/[a-z]+\/([a-z]+)[0-9]+')
# all disk partitions and there sizes
# ^(\/[a-z]+\/[a-z]+[0-9]+)[0-9\*\s]+\s([0-9]+[0-9\.]+[MGT])
# ^\/([a-z]+)\/([a-z]+[0-9]+)[0-9\*\s]+\s([0-9]+[0-9\.]+[MGT])
REG_DISKPART = re.compile('^\/([a-z]+)\/([a-z]+[0-9]+)[0-9\*\s]+\s([0-9]+[0-9\.]+[MGT])')


activeEntry = ''
netEntrys = {}
counter = 0


lines = os.popen("ip address").readlines()

for line in lines:
  # counter += 1
  # if counter >= 20:
  #   break
  if REG_NAME.match(line):
    firstLine = REG_NAME.search(line)
    NAME = firstLine.group(2)
    try:
      tmp = netEntrys[firstLine.group(2)]
      print("entry allready here")
      print(netEntrys[firstLine.group(2)])
      continue
    except:
      pass
      # print("new entry "+firstLine.group(2))

    newEntryNAMES = {"nr":firstLine.group(1),"option":firstLine.group(3),"mtu":firstLine.group(4),"state":firstLine.group(5)}
    netEntrys[NAME] = newEntryNAMES
    # print(newEntryNAMES)
    activeEntry = NAME
  
  elif REG_ETHER.match(line):
    netEntrys[NAME]["mac"] = REG_ETHER.search(line).group(1)

  elif REG_IP4.match(line):
    netEntrys[NAME]["ip4"] = REG_IP4.search(line).group(1)
    netEntrys[NAME]["ip4Netmask"] = REG_IP4.search(line).group(2)

  elif REG_IP6.match(line):
    netEntrys[NAME]["ip6"] = REG_IP6.search(line).group(1)
    netEntrys[NAME]["ip6Netmask"] = REG_IP6.search(line).group(2)


fdiskl = os.popen("fdisk -l").readlines()

activeEntry = ''
diskEntrys = {}

for disks in fdiskl:
  if REG_DISKPATH.match(disks):
    fsLi = REG_DISKPATH.search(disks)
    try:
      tmp = diskEntrys[fsLi.group(2)]
      # print("entry allready here")
      # print(netEntrys[fsLi.group(2)])
      continue
    except:
      pass
      # print("new entry "+fsLi.group(2))

    activeEntry = fsLi.group(2)
    diskEntrys[fsLi.group(2)] = {"size":fsLi.group(3)+fsLi.group(4)}
  elif REG_DISKPART.match(disks):
    print(REG_DISKBASE.search(disks).group(1))
    if activeEntry == REG_DISKBASE.search(disks).group(1):
      diskDetails = REG_DISKPART.search(disks)
      diskEntrys[activeEntry][diskDetails.group(2)] = diskDetails.group(3)




print(json.dumps(netEntrys, indent=2))

print(json.dumps(diskEntrys, indent=2))