@echo off
set DIRNAME=.\

if "%OS%" == "Windows_NT" set DIRNAME=%~dp0%
%~d0
cd %DIRNAME%

cmd.exe /c ant -buildfile checkstyle.xml
pause
