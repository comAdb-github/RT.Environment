@echo off
rem コンソール表示をutf8に設定
chcp 65001 >nul

set REPO_NAME=rt-environment
set PRJ_NAME=infrastructure-tf
set INST_ID=infrastructure-tf-inst
set PRJ_ID=infrastructure-tf-479108
set REG_NAME=asia-northeast1
set USER=bang.peigh@gmail.com
set BILL_ACCT=XXXXXX-XXXXXX-XXXXXX

rem ##############################################################################

rem プロジェクトの存在、およびIDを確認
gcloud projects list

rem 請求先アカウントの存在、およびIDを確認
gcloud beta billing accounts list

rem 請求先アカウントを紐づけ
gcloud beta billing projects link %PRJ_ID%  ^
  --billing-account=%BILL_ACCT%

rem インスタンス作成
gcloud beta source-manager instances create %INST_ID% ^
  --project=%PRJ_ID% ^
  --region=%REG_NAME%

rem インスタンス確認
gcloud beta source-manager instances list ^
  --project=%PRJ_ID% ^
  --region=%REG_NAME%

rem ##############################################################################

rem リポジトリ作成コマンド（インスタンス作成が完了したら実行する）
gcloud beta source-manager repos create %REPO_NAME% ^
  --instance=%INST_ID% ^
  --project=%PRJ_ID% ^
  --region=%REG_NAME%

rem リポジトリ確認
gcloud beta source-manager repos list ^
  --instance=%INST_ID% ^
  --project=%PRJ_ID% ^
  --region=%REG_NAME%


rem 認証クライアントを、windows標準からgcpに切り替え
git config --global --unset credential.helper
git config --system --unset credential.helper
git config --global credential."https://infrastructure-tf-inst-190516636370-git.asia-northeast1.sourcemanager.dev".helper gcloud.cmd

rem 念のため再認証
gcloud auth login
gcloud auth list


rem リモートリポジトリ設定
git remote set-url origin ^
  https://infrastructure-tf-inst-190516636370-git.asia-northeast1.sourcemanager.dev/infrastructure-tf-479108/rt-environment.git

# push
git push -u origin master



pause
