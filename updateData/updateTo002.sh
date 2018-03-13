#!/bin/bash
#

#
# Usage Function
#
usage() {
  echo "Usage: $0 containerID"
  exit 1
}

if [ -z "$1" ]; then
  usage;
else
  cat ./version002.sql | docker exec -i $1 /usr/bin/mysql -utestdbuser -ptestdbpassword testdatabase
fi


