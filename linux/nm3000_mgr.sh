#!/bin/bash
### BEGIN INIT INFO
# Provides:          nm3000_mgr
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: nm3000_mgr
### END INIT INFO
#chkconfig:2345 80 90
#description:nm3000_mgr
#INSTALL NM3000 MGR AS LINUX SERVICE 

case $1 in

start)
    cd nm3000Path/ems/enginemgr/bin
    ./engineMgrStart.sh;;
stop)
    cd nm3000Path/ems/enginemgr/bin
    ./engineMgrStop.sh;;
restart)
    cd nm3000Path/ems/enginemgr/bin
    ./engineMgrStop.sh
    ./engineMgrStart.sh;;
*);;
esac