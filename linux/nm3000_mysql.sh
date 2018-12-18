#!/bin/bash
### BEGIN INIT INFO
# Provides:          nm3000_mysql
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: nm3000_mysql
### END INIT INFO
#chkconfig:2345 80 90
#description:nm3000_mysql
#INSTALL NM3000 MYSQL AS LINUX SERVICE 

case $1 in

start)
    cd nm3000Path/ems/
    ./startmysql.sh;;
stop)
    cd nm3000Path/ems/
    ./stopmysql.sh;;
restart)
    cd nm3000Path/ems/
    ./stopmysql.sh
    ./startmysql.sh;;
*);;
esac