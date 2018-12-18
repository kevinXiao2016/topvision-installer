#!/bin/sh
# backup
./mysqldump --defaults-file=../my.cnf -uroot -pems --default-character-set=utf8 --opt --extended-insert=false --hex-blob -R -x ems > ./backup/bak.sql
