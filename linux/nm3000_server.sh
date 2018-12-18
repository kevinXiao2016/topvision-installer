#!/bin/bash
### BEGIN INIT INFO
# Provides:          nm3000_server
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: nm3000_server
### END INIT INFO
#chkconfig:2345 80 90
#description:nm3000_server
#INSTALL NM3000 SERVER AS LINUX SERVICE 

case $1 in

start)
    cd nm3000Path/ems/
    ./startems.sh;;
stop)
    cd nm3000Path/ems/
    ./stopems.sh;;
restart)
    cd nm3000Path/ems/
    ./stopems.sh
    sleep 10
    ./startems.sh;;
*);;
esac