@echo off
rem コンソール表示をutf8に設定
chcp 65001 >nul


rem ########################################################
rem # パッケージインストール
rem ########################################################
rem Gitインストール
winget install --id Git.Git -e --source winget

rem Tortoise-Gitインストール
winget install --id TortoiseGit.TortoiseGit -e --source winget



rem ########################################################
rem # インストールパッケージのPATH設定（システムPATHのみ）
rem ########################################################
setlocal enabledelayedexpansion

rem === Git のインストール先を確認 ===
set GITCMD=C:\Program Files\Git\cmd
set GITBIN=C:\Program Files\Git\bin
set GITPATH=

if exist "%GITCMD%" (
    set GITPATH=%GITCMD%
) else if exist "%GITBIN%" (
    set GITPATH=%GITBIN%
)

rem === 追加したいパスを列挙（Gitが見つかった場合は追加） ===
set TARGETS=
if defined GITPATH (
    set TARGETS=%GITPATH%
)
set TARGETS=%TARGETS%

rem === 現在のシステム PATH をレジストリから取得 ===
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set CURPATH=%%B

rem === 重複除去処理 ===
set CLEANPATH=!CURPATH!
for /f "tokens=1 delims=;" %%D in ("!TARGETS!") do (
    set CLEANPATH=!CLEANPATH:%%D;=!
    set CLEANPATH=!CLEANPATH:%%D=!
)

rem === パス追加処理（存在確認＋追記） ===
set NEWPATH=!CLEANPATH!
for /f "tokens=1 delims=;" %%D in ("!TARGETS!") do (
    if exist "%%D" (
        echo 追加対象: %%D
        set NEWPATH=!NEWPATH!;%%D
    ) else (
        echo ディレクトリが存在しません: %%D
    )
)

rem === セミコロン整理 ===
if "!NEWPATH:~0,1!"==";" set NEWPATH=!NEWPATH:~1!
if "!NEWPATH:~-1!"==";" set NEWPATH=!NEWPATH:~0,-1!

echo 修正後システム PATH = !NEWPATH!
setx /M PATH "!NEWPATH!"

endlocal
exit /b