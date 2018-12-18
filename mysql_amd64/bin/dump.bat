@echo off

set MYSQL_DIRNAME=.\
if "%OS%" == "Windows_NT" set MYSQL_DIRNAME=%~dp0%
%~d0
cd %MYSQL_DIRNAME%

set %DATE% = date 

.\mysqldump.exe --defaults-file="..\my.cnf" -h127.0.0.1 -uroot -pems --default-character-set=utf8 --opt --extended-insert=false --hex-blob -R -x -f --ignore-table=ems.initialdatacmaction --ignore-table=ems.initialdatacpeaction --ignore-table=ems.cmaction --ignore-table=ems.event --ignore-table=ems.cpeaction --ignore-table=ems.perfcmcflowquality --ignore-table=ems.perfcmcerrorcodequality ems > .\backup\bak.sql

pause
