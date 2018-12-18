@echo off

set MYSQL_DIRNAME=.\
if "%OS%" == "Windows_NT" set MYSQL_DIRNAME=%~dp0%
%~d0
cd %MYSQL_DIRNAME%

.\mysql.exe --defaults-file="..\my.cnf" -h127.0.0.1 -uroot -pems ems < .\backup\bak.sql

pause