# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### セットアップ

```sh
$ export RUBY_IMAGE=ruby:2.4.2-alpine3.6
$ export DEVELOPER_NAME=ofl
$ export PROJECT_NAME=entry_point_2018
$ export APP_VERSION=0.1

$ docker pull $RUBY_IMAGE

# Gemfileを生成
$ docker run --rm -v "$PWD":/usr/src/"$PROJECT_NAME" -w /usr/src/"$PROJECT_NAME" $RUBY_IMAGE bundle init

# Dockerfileを生成、編集後
$ docker build -t "$DEVELOPER_NAME"/"$PROJECT_NAME" .

# rails new
$ docker run --rm -it -v "$PWD":/usr/src/"$PROJECT_NAME" "$DEVELOPER_NAME"/"$PROJECT_NAME" rails new . -BT

# docker-compose.ymlを追加
# config/database.ymlの修正
$ docker-compose build

$ docker-compose up -d
```

### minikubeで動かす

```sh
# minikube環境をリセット
$ minikube stop

# minikubeをスタート
$ minikube start --vm-driver hyperkit --insecure-registry localhost:5000

# ディレクトリのdocker環境をminikubeのものにする
$ eval $(minikube docker-env)

# イメージのビルド
$ docker build -t "$DEVELOPER_NAME"/"$PROJECT_NAME":"$APP_VERSION" .

# 秘密情報を読み込む
$ kubectl create -f .kube-secrets.yaml

# ./kube 以下のmanifestを適用する
$ kubectl create -f ./kube

# ダッシュボードでコンテナの起動を確認
$ minikube dashboard

# RailsのURLを確認
$ minikube service rails-service --url
```

### よく使うコマンド

```sh
$ docker-compose run --rm app bundle install

# DBリセット
$ docker-compose run --rm app rails db:migrate:reset && rails db:seed

# DB作りたくなったら
$ docker-compose run --rm app rake db:create

# マイグレーションしたくなったら
$ docker-compose run --rm app rake db:migrate

# seed実行したくなったら
$ docker-compose run --rm app rake db:seed

# コントローラー作成したくなったら(controller_nameを変更してどうぞ)
$ docker-compose run --rm app rails generate controller controller_name

# Model作成したくなったら(model_nameを変更してどうぞ 引数にname:stringとかでnameカラムを作れます。)
$ docker-compose run --rm app rails generate model model_name name:string

# ルーティング変更したくなったら(config/routes.rbを編集後実行)
$ docker-compose run --rm app rake routes
```
