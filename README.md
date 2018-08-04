# README

### ライブラリ

-   [plataformatec/devise](https://github.com/plataformatec/devise)
-   [twbs/bootstrap](https://github.com/twbs/bootstrap)
-   [vuejs/vue](https://github.com/vuejs/vue)
-   [shrinerb/shrine](https://github.com/shrinerb/shrinea)
-   [rmosolgo/graphql-ruby](https://github.com/rmosolgo/graphql-ruby)
-   [Netflix/fast_jsonapi](https://github.com/Netflix/fast_jsonapi)


### セットアップ

```sh
# 環境変数の設定
$ export RUBY_IMAGE=ruby:2.4.2-alpine3.6 DEVELOPER_NAME=ofl PROJECT_NAME=entry_point_2018 APP_VERSION=0.1

# Dockerイメージのビルド
$ docker build -t "$DEVELOPER_NAME"/"$PROJECT_NAME":"$APP_VERSION" --build-arg PROJECT_NAME="$PROJECT_NAME" .

# Railsの起動
$ docker-compose up -d

# http://localhost:3000で表示される

# コマンドラインで操作
$ docker-compose exec rails sh

# ログの確認
$ docker-compose logs
```

### テスト、Rubocopの自動実行

```sh
$ docker-compose exec rails sh

# rails内のシェルで
$ bundle exec guard
```

### テスト

```sh
$ docker-compose exec rails sh

# rails内のシェルで
$ bin/rspec
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
$ kubectl create -f .kube-secrets.yml

# ./kube 以下のmanifestを適用する
$ kubectl create -f ./kube

# ダッシュボードでコンテナの起動を確認
$ minikube dashboard

# RailsのURLを確認
$ minikube service rails-service --url
```
