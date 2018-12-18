@echo off

set MYSQL_DIRNAME=.\
if "%OS%" == "Windows_NT" set MYSQL_DIRNAME=%~dp0%
%~d0
cd %MYSQL_DIRNAME%

@Title Topvision Mysql Server Console

net stop "Topvision Mysql"

.\mysqld.exe --remove "Topvision Mysql" --defaults-file="..\my.cnf"
