#!/bin/bash
set -e
su mongodb -s /bin/bash -c "mongod -f /etc/mongod.conf"
mongo initMongo.js
su app -c "./start.sh"
