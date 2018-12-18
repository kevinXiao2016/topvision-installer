@echo off

set MYSQL_DIRNAME=.\
if "%OS%" == "Windows_NT" set MYSQL_DIRNAME=%~dp0%
%~d0
cd %MYSQL_DIRNAME%

@Title Mysql Server Console

:ems
if exist ..\data\ems goto run
mkdir ..\data\ems

:run
.\mysqld.exe --defaults-file="..\my.cnf" --console

pause