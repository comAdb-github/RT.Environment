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

rem 7zip.exe(ISO.bz2解凍用)インストール
winget install --id 7zip.7zip -e --source winget

rem Google Cloud CLI インストール
winget install --id Google.CloudSDK


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
    set GITPATH=!GITBIN!
)
rem === 追加したいパスを列挙（Gitが見つかった場合は追加） ===
set GITTARGETS=
if defined GITPATH (
    set GITTARGETS=!GITPATH!
)

echo === 7zip のインストール先を確認 ===
set SZIPCMD=C:\Program Files\7-Zip
set SZIPPATH=

if exist "%SZIPCMD%" (
    set SZIPPATH=!SZIPCMD!
)
echo === 追加したいパスを列挙（Gitが見つかった場合は追加） ===
set SZIPTARGETS=
if defined SZIPPATH (
    set SZIPTARGETS=!SZIPPATH!
)


echo === 現在のシステム PATH をレジストリから取得 ===
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set CURPATH=%%B

echo === パス結合サブルーチン呼び出し--git-- ===
set RET_JOINPATH=
call :JOINPATH "!CURPATH!" "!GITTARGETS!"

rem === パス結合サブルーチン呼び出し--7zip-- ===
echo RET_JOINPATH=!RET_JOINPATH!
call :JOINPATH "!RET_JOINPATH!" "!SZIPTARGETS!"
set NEWPATH=!RET_JOINPATH!

echo === セミコロン整理 ===
if "!NEWPATH:~0,1!"==";" set NEWPATH=!NEWPATH:~1!
if "!NEWPATH:~-1!"==";" set NEWPATH=!NEWPATH:~0,-1!

echo 修正後システム PATH = !NEWPATH!
setx /M PATH "!NEWPATH!"

endlocal
exit /b


rem ########################################################
rem # サブルーチン：追加したいパスを列挙
rem # arg1: 現在のPATH文字列
rem # arg2: 追加したいパス文字列（セミコロン区切り）
rem ########################################################
:JOINPATH
@REM setlocal enabledelayedexpansion
set ARG1=%~1
set ARG2=%~2
echo "JOINPATH ARG1= !ARG1!"
echo "JOINPATH ARG2= !ARG2!"
echo === 重複除去処理 ===
set LCL_CLEANPATH=!ARG1!
for /f "tokens=1 delims=;" %%D in ("!ARG2!") do (
    set LCL_CLEANPATH=!LCL_CLEANPATH:%%D;=!
    set LCL_CLEANPATH=!LCL_CLEANPATH:%%D=!
)

echo === パス追加処理（存在確認＋追記） ===
set LCL_NEWPATH=!LCL_CLEANPATH!
for /f "tokens=1 delims=;" %%D in ("!ARG2!") do (
    if exist "%%D" (
        echo 追加対象: %%D
        set LCL_NEWPATH=!LCL_NEWPATH!;%%D
    ) else (
        echo ディレクトリが存在しません: %%D
    )
)

echo === 結果返却 ===
set RET_JOINPATH=!LCL_NEWPATH!
echo "JOINPATH RET=!RET_JOINPATH!"
@REM endlocal
exit /b