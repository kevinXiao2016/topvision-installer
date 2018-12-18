#!/bin/bash
### BEGIN INIT INFO
# Provides:          nm3000
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: nm3000
### END INIT INFO
#chkconfig:2345 80 90
#description:nm3000
#INSTALL NM3000 AS LINUX SERVICE 

case $1 in

start)
    echo NM3000 Service Start;;
stop)
    echo NM3000 Service Stop;;
*);;
esac