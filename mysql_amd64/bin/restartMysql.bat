@echo off
@Title Topvision Mysql
set DIRNAME=.\

if "%OS%" == "Windows_NT" set DIRNAME=%~dp0%
%~d0
cd %DIRNAME%

net stop "Topvision Mysql"
net start "Topvision Mysql"

pause