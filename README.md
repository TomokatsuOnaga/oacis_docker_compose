![GitHub Release](https://img.shields.io/github/v/release/TomokatsuOnaga/oacis_docker_compose)

[OACIS](https://github.com/crest-cassia/oacis) が動く docker compose リポジトリです

This is a docker compose file for OACIS.

# 特徴
- 1コンテナ1プロセスとし、また、ボリュームを活用して、起動と終了が高速になりました。
- WEBコンテナとワーカーコンテナを分けたので, 100ジョブ投入時のレスポンスが早くなりました。また、Docker Desktop から、それぞれのCPU使用率を監視可能です。
- 秘密鍵はホストパソコンの鍵を参照します。コンテナ内での秘密鍵とパスフレーズの登録は不要になりました。
- データの永続化はボリュームを用いています。アップデートの取り込みには、コンテナを破棄して起動すれば良いです。コンテナは気軽に破棄しても問題ありません。

# 構成など
- 4コンテナに分けた構成です。web, mongo db, redis, sidekiq から構成されます
- docker compose を使ってまとめて起動できます
- Apple Virtualization Framework に対応しています
- 注意点 host polling interval には対応していません

# 1. 事前準備
- xsub をスパコンにインストールして下さい
- 手元のパソコンからスパコンにsshで入れるようにして下さい `ssh fugaku` など
- このリポジトリの .ssh/config フォルダに docker 用の接続設定を書いて下さい。コンテナ内から oacis_docker_compose/.ssh/config ファイルが参照されます
  ```ssh-config
  Host fugaku
    HostName fugaku.hpc.kyushu-u.ac.jp
    IdentityFile ~/.ssh/id_ed25519_XXXX
    User ku10000001
  ```
- パソコンで ssh-add を使ってパスフレーズを登録しておいて下さい。コンテナ内から参照されます

# 2. 主要な使い方
## 1. 起動
```shell
$ docker compose up
```
または、バックグラウンドで実行する場合
```shell
$ docker compose up -d
```
docker compose up の出力例
![docker compose up の出力例](docs/docker_compose_up_stdout.png)

## 2. シェルにログイン
- ウェブサーバーにログイン
```zsh
$ docker compose exec -it web bash
```

- ジョブワーカーを担当する sidekiq サーバーにログイン
```zsh
$ docker compose exec -it sidekiq bash
```

## 3. 停止
```shell
$ docker compose stop
```

## 4. 再開
```shell
$ docker compose start
```

## 5. 終了（データはボリュームに残ります）
```shell
$ docker compose down
```

# 3. データの保存先とバックアップ方法
## データは3つのボリュームに保存されています
- mongo_data ボリューム　データベースの保存先
- result_development ボリューム　結果ファイルの保存先
- worker_logs ボリューム　ワーカーのログの保存先
ボリューム内のファイルは Docker Desktop アプリケーションから確認することができます

## バックアップ方法
下記の二つのボリュームをエクスポートして下さい。
- mongo_data ボリューム
- result_development ボリューム

# 4. 構成
- rails web httpsリクエストを処理するサーバー
- rails sidekiq ジョブワーカーを処理するサーバー
- mongo db データベース
- redis データベース

# 5. その他のコマンド
## Dockerfile を再度ビルドして起動
```zsh
$ docker compose down --rmi local && docker compose up
```
