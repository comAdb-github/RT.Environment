@echo off
set SCRIPT_DIR=%~dp0
set LGPO_DIR=%SCRIPT_DIR%LGPO\LGPO_30\
set EXPORT_DIR=%SCRIPT_DIR%GroupPolicy

echo "Script Dir Path = %SCRIPT_DIR%"
echo "LGPO Dir Path = %LGPO_DIR%"
echo "EXPORT Dir Path = %LGPO_DIR%"

cd %LGPO_DIR%
cd
LGPO.exe /b "%EXPORT_DIR%"

pause