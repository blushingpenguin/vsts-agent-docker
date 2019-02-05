#!/bin/bash
set -e
service mongodb start
# stuff still tries to connect to ::1 even
# with "::1 localhost" removed from hosts
# cat /etc/hosts |grep -v :: > hosts
# cat hosts > /etc/hosts
# rm hosts
./start.sh
