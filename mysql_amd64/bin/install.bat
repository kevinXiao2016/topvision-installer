@echo off

set MYSQL_DIRNAME=.\
if "%OS%" == "Windows_NT" set MYSQL_DIRNAME=%~dp0%
%~d0
cd %MYSQL_DIRNAME%

@Title Topvision Mysql Server Console

.\mysqld.exe --install "Topvision Mysql" --defaults-file="%MYSQL_DIRNAME%..\my.cnf"
