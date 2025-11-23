@echo off
rem コンソール表示をutf8に設定
chcp 65001 >nul

# gloudを初期化
gcloud init

# 必要なコンポーネントをインストール
gcloud components install beta

pause