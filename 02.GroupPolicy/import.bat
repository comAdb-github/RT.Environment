
@echo off
rem import.bat - LGPO バックアップからローカルにグループポリシーを適用する

rem --- UTF-8 表示対策 (PowerShell ターミナルでの文字化け軽減) ---
rem コンソールのコードページを UTF-8 に設定
chcp 65001 >nul
rem PowerShell ホストで実行される場合、出力エンコーディングを UTF-8 に設定
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::InputEncoding = [System.Text.Encoding]::UTF8; $OutputEncoding = New-Object System.Text.UTF8Encoding($false)" >nul 2>&1

rem スクリプトのディレクトリ
set SCRIPT_DIR=%~dp0
set LGPO_DIR=%SCRIPT_DIR%LGPO\LGPO_30\
set IMPORT_DIR=%SCRIPT_DIR%GroupPolicy

echo Script Dir Path = %SCRIPT_DIR%
echo LGPO Dir Path = %LGPO_DIR%
echo Import Dir Path = %IMPORT_DIR%

rem 管理者権限チェック
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 管理者権限で実行してください。
    pause
    exit /b 1
)

rem LGPO.exe の存在確認
if not exist "%LGPO_DIR%LGPO.exe" (
    echo LGPO.exe が見つかりません: %LGPO_DIR%LGPO.exe
    echo LGPO フォルダを確認してください。
    pause
    exit /b 1
)

rem Import 実行
cd /d "%LGPO_DIR%"

echo LGPO を使って %IMPORT_DIR% からポリシーを適用します...
LGPO.exe /g "%IMPORT_DIR%"
if %errorlevel% equ 0 (
    echo GroupPolicy の適用が完了しました。
) else (
    echo LGPO.exe /g が失敗しました。エラーコード: %errorlevel%
    echo LGPO のヘルプを表示します。
    LGPO.exe /?
)

pause
