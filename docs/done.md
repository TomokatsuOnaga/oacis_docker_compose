# [oacis_docker](../../../../crest-cassia/oacis_docker) からの変更点

## 概要

### 4コンテナ構成にした
1. mongo db
2. redis
3. rails (ruby)
4. workers (ruby)

## 目標としたこと

### Docker の原則に従いたい
- 1プロセス1コンテナ
- プロセスの exit は、コンテナの exit
- 1プロセスなので、そのコマンドを CMD に記載する（ENTORYPOINT もあるが、通常は CMD が標準）
- `./oacis_boot.sh` や `./oacis_start.sh` もこれまでの開発の結晶だが、Docker らしくできるといい

### できるといいこと
- `docker compose up`, `docker compose stop`, `docker compose start` や `docker compose down` が使えると良い
- mongo db などが、公式のイメージを使えると嬉しい
- QEMU もいいが、Apple Visualization Framework が使えるのも良い

## 行ったこと

### 設定したこと
1. mongoid.yml の URL を変更した `mongo:27017`
2. cable.yml の URL を変更した `reis://redis:6379`

### 対応したこと
1. mongoid.yml など、変更したファイルを Dockerfile にコピーした
2. web サーバーには、`CMD ["bundle", "exec", "rake", "daemon:start"]` を使っている
3. ワーカーには、`command: bundle exec ruby -r './config/environment' ./config/boot_job_submitter_worker.rb start` を試した
4. web サーバーを`CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]`を使うようになった
5. ワーカーのプロセスが exit しないように、調べた結果　Sidekiq を使い始めた

### 導入したこと
- ホストマシン（Mac）の ssh-agent を Docker（ubuntu） 内からも参照したい

## まとめ
- できるだけ既存のコードを残しつつ、Docker マルチコンテナ構成の書き方を取り入れた
- 4コンテナ構成で実行できた
- "host polling interval" などはまだ対応していないが、今後対応したい

## 参照した本
[開発系エンジニアのためのDocker絵とき入門 ](https://www.amazon.co.jp/開発系エンジニアのためのDocker絵とき入門-鈴木亮/dp/4798071501)

## 付録
### 細かな TIPS
- Dockerfile へのファイルの追加は、原則 `COPY` 命令が良い
- github リポジトリの追加は、`ADD` 命令が良い。更新のチェックを自動で行ってくれる
