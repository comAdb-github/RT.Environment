# ホストマシン環境構築



## 概要

1. プロジェクトCLONE  
    `git clone https://infrastructure-tf-inst-190516636370-git.asia-northeast1.sourcemanager.dev/infrastructure-tf-479108/rt-environment.git`
2. パッケージインストール  
    `.\installPackage.bat`
3. レジストリ設定  
    01.Registry\setting.reg
4. gpeditインポータ（LGPO）インストール  
    `https://www.microsoft.com/en-us/download/details.aspx?id=55319`
5. gpedit インポート  
    `02.GroupPolicy\import.bat`



## 付録

### gitリポジトリ構築
1. GCloudCLI環境初期化  
    `50.GCloud\01.initGcloud.bat`
2. プロジェクト・インスタンス作成・リポジトリ作成・リポジトリPUSH  
    `50.GCloud\02.createRepository.bat`


## トラブルシューティング
1. Tortoise-Gitのオペレーションでエラーが出る場合。
    1. gitの所有者不整合をパッチ  
        `git config --global --add safe.directory "{プロジェクトディレクトリのフルパス}/.git"`
    2. ディレクトリの所有者を設定する  
        `icacls "{プロジェクトディレクトリのフルパス}" /setowner "%USERNAME%" /T`
