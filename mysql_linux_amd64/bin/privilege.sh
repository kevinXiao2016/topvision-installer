#!/bin/sh
# change privilege

./mysql --defaults-file=../my.cnf -uroot -pems ems < ./privilege.sql

