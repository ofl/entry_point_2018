# README
[![CircleCI](https://circleci.com/gh/ofl/entry_point_2018/tree/master.svg?style=svg)](https://circleci.com/gh/ofl/entry_point_2018/tree/master)

### ライブラリ

-   [plataformatec/devise](https://github.com/plataformatec/devise)
-   [twbs/bootstrap](https://github.com/twbs/bootstrap)
-   [vuejs/vue](https://github.com/vuejs/vue)
-   [shrinerb/shrine](https://github.com/shrinerb/shrinea)
-   [rmosolgo/graphql-ruby](https://github.com/rmosolgo/graphql-ruby)
-   [Netflix/fast_jsonapi](https://github.com/Netflix/fast_jsonapi)


### セットアップ

事前に ```.env.sample``` の内容を自分の環境に合わせて編集して ```.env``` というファイル名で保存しておく

```sh
# Railsを起動する
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

### 個別にテスト

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
