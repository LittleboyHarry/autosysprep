@echo off
if not "%1"=="elevated" (powershell start -verb runas '%0' elevated & exit /b)
cd /d %~dp0\scripts
powershell -exec bypass -file auto-sysprep.ps1
echo.
echo FINISHED SETUP!
echo.
pause