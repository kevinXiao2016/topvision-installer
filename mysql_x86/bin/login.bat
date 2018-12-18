@echo off

set MYSQL_DIRNAME=.\
if "%OS%" == "Windows_NT" set MYSQL_DIRNAME=%~dp0%
%~d0
cd %MYSQL_DIRNAME%

@Title Mysql Console

.\mysql.exe --defaults-file="..\my.cnf" -h127.0.0.1 -P3003 -uroot -pems