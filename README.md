# ホストマシン環境構築



## 概要

1. プロジェクトCLONE  
    `git clone git@github.com:comAdb-github/RT.Environment.git`
2. パッケージインストール  
    `.\installPackage.bat`
3. レジストリ設定  
    01.Registry\setting.reg
4. gpeditインポータ（LGPO）インストール  
    `https://www.microsoft.com/en-us/download/details.aspx?id=55319`
5. gpedit インポート  
    `02.GroupPolicy\import.bat`



## 付録


## トラブルシューティング
1. Tortoise-Gitのオペレーションでエラーが出る場合。
    1. gitの所有者不整合をパッチ  
        `git config --global --add safe.directory "{プロジェクトディレクトリのフルパス}/.git"`
    2. ディレクトリの所有者を設定する  
        `icacls "{プロジェクトディレクトリのフルパス}" /setowner "%USERNAME%" /T`
