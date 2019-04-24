# Joruri CMS 2017 データベースプラグイン インストールマニュアル

## 1.想定環境

### システム

* OS: CentOS 7.2
* Webサーバ: nginx 1.12
* Appサーバ: unicorn 5.4
* Database: PostgreSQL 9.5
* Ruby: 2.6
* Rails: 5.2
* Joruri CMS 2017 Release4

## 2.Joruri CMS 2017インストール

Joruri CMS 2017のインストールを実施する

## 3.プラグイン機能の有効化

Joruri CMS 2017のプラグイン機能を有効化する。

    # su - joruri
    $ cd /var/www/joruri
    $ vi config/application.yml
```
  # ツールメニュー表示
  show_tool_menu: true #falseからtrueに変更
```
    $ bundle exec rake unicorn:restart RAILS_ENV=production


## 4.データベースプラグインのインストール

Joruri CMS 2017管理画面にアクセスし、下記のプラグインをインストール

* https://github.com/joruri/zplugin3-content-webdb

ツール　＞　プラグイン　＞　新規作成から下記の内容を登録する。

|項目名|設定値|
|:----------|:---------------|
|URL|https://github.com/|
|プラグイン名|joruri/zplugin3-content-webdb|
|タイトル|データベース|
|バージョン|master|

一覧画面から「アプリ再起動」を実施する。
「プラグイン名」欄にある「zomeki/zplugin3-content-webdb」リンクが有効になるので
クリックしてプラグイン関連のコンテンツ管理画面に遷移し、「インストール」を実施する。
