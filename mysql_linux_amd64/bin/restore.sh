#!/bin/sh
# restore
./mysql --defaults-file=../my.cnf -uroot -pems ems < ./backup/bak.sql

