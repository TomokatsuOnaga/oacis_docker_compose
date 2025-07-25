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

### 設定したこと
1. mongo db の URL を変更した `mongo:27017`
2. redis の URL を変更した `reis://redis:6379`
### 導入したこと
- ホストマシン（Mac）の ssh-agent を Docker（ubuntu） 内からも参照したい

### 対応したこと
- 
