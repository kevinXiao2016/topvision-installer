#!/bin/sh
# Set execute permissions

cd $2
case $1 in
start)
    ./mysqld --defaults-file=../my.cnf --user=$3;;
stop)
    ./mysqladmin -h127.0.0.1 -P3003 -uroot -pems shutdown;;
*);;
esac
