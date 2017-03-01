railsの開発環境をvagrant上のcentos7に構築します。
以下の環境で動作確認。
- OS: macOS Sierra 10.12.3
- Vagrant 1.8.1
- Virtualbox 5.0.18
- ruby 2.3.1
- rails 4.2.2
- postgresql 9.2.18
- nodejs 4.7.3

# 事前準備
- vagrantのインストール
- virtualboxのインストール
- virtualboxのpluginのインストール
```
$ vagrant plugin install vagrant-vbguest
```

# 開発環境構築手順
- 以下のコマンドを実行
```
$ vagrant up --provider virtualbox
```

上記コマンドから`bin/setup.sh`を呼び出し、以下の作業も実施される。
- locale, keymap, timezoneの設定
- rubyのインストール
  - バージョン管理はrbenvで行う
- nodejsのインストール
  - uglifierなどのgemで必要

## postgresqlの設定

以下の作業は手動で行う。(自動化TBD)

- postgresユーザーのパスワード変更
```
$ sudo passwd postgres
Changing password for user postgres.
New password:  #パスワードを適当に設定する
Retype new password:
```
- postgresqlにvagrantユーザーを追加
```
$ su - postgres
$ createuser vagrant -s
$ psql
postgres=# \password vagrant # vagrantユーザにパスワードを設定
Enter new password: #パスワードを適当に設定する
Enter it again:
postgres=# \q # psqlプロンプト終了
$ exit
```
- pg_hba.confの81行目付近を以下のように書き換える (peer > md5)
```
$ sudo vi /var/lib/pgsql/9.5/data/pg_hba.conf

# "local" is for Unix domain socket connections only
# local   all             all                                     peer
local   all             all                                     md5

$ sudo systemctl restart postgresql-9.5.service
```

# 動作確認
- 作業ディレクトリの作成
```
$ mkdir /vagrant/hello_app
$ cd /vagrant/hello_app
```

- railsのインストール
```
$ bundle init
$ vi Gemfile

# Gemfileを以下のように編集
source "https://rubygems.org"

gem "rails", "4.2.2"
gem 'pg', '0.17.1'

# ホストOSとの共有フォルダ内にinstallするとrails関係のコマンドの実行速度が遅くなる（原因不明）
$ bundle install --path ~/bundler/hello_app/vendor/bundle
```

- railsプロジェクトの作成とDB設定
```
$ bundle exec rails new . --database=postgresql
$ vi config/database.yml

# database.ymlを編集し、defaultにusernameとpasswordを設定
default:
  ...
  username: vagrant
  password: # 先ほど設定したパスワード

$ bin/rake db:create
```

- `http://localhost:3000`にアクセスし、Ruby on Railsのwelcomeページが表示されることを確認する
```
bin/rails server -b 0.0.0.0 -p 3000
```
