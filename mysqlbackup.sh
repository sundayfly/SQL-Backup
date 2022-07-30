#!/bin/bash
# author: sunday
# date: 20180611
# 排除数据库，自动化备份所有数据库
#GRANT SELECT, SHOW DATABASES, LOCK TABLES, EVENT,SHOW VIEW, RELOAD,SUPER,REPLICATION CLIENT ON *.* TO 'backup'@'localhost' identified by 'wLJt+hYgiHO4P3Ysd4jM+';
#flush privileges;
export PATH=/usr/local/webserver/mysql/bin/:$PATH

BACKUP_PATH=/data/bak/local/mysql
SECRET="-ubackup -hlocalhost -pwLJt+hYgiHO4P3Ysd4jM+"
TIME=`date +%F`

#列表
DB_NAMES=(`mysql $SECRET -e "show databases;" | grep -Ev "Database|mysql|sys|_schema|_buffer|_access_log|_test"`)

for DB_NAME in ${DB_NAMES[*]};do
    mysqldump $SECRET --default-character-set=utf8mb4 --set-gtid-purged=OFF --single-transaction --master-data=2 --triggers --routines --events --hex-blob $DB_NAME > $BACKUP_PATH/$DB_NAME-$TIME.sql
    tar -czf $BACKUP_PATH/$DB_NAME-$TIME.tar.gz $BACKUP_PATH/$DB_NAME-$TIME.sql
    find $BACKUP_PATH -type f -name "*.sql" | xargs rm -rf
done

find $BACKUP_PATH -type f -name "*.tar.gz" -mtime +365 | xargs rm -rf
