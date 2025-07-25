# [oacis_docker](../../../../crest-cassia/oacis_docker) からの変更点

## 行ったこと

### 4コンテナ構成にした
1. mongo db
2. redis
3. rails (ruby)
4. workers (ruby)

### Docker の原則に従いたい
- 1プロセス1コンテナ
- プロセスの exit は、コンテナの exit
- 1プロセスなので、そのコマンドを CMD に記載する（ENTORYPOINT もあるが、通常は CMD が標準）

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

### 参照した本
[開発系エンジニアのためのDocker絵とき入門 ](https://www.amazon.co.jp/開発系エンジニアのためのDocker絵とき入門-鈴木亮/dp/4798071501)
