# [oacis_docker](../../../../crest-cassia/oacis_docker) からの変更点

## 行ったこと

### 4コンテナ構成にした
- mongo db
- redis
- rails (ruby)
- workers (ruby)

### Docker の原則に従いたい
- 1プロセス1コンテナ
- プロセスの exit は、コンテナの exit

### 導入したこと
- ホストマシン（Mac）の ssh-agent を Docker（ubuntu） 内からも参照したい
