@echo off
rem --- UTF-8 表示対策 (PowerShell ターミナルでの文字化け軽減) ---
rem コンソールのコードページを UTF-8 に設定
chcp 65001 >nul
rem PowerShell ホストで実行される場合、出力エンコーディングを UTF-8 に設定
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::InputEncoding = [System.Text.Encoding]::UTF8; $OutputEncoding = New-Object System.Text.UTF8Encoding($false)" >nul 2>&1

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