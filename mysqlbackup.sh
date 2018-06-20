#!/bin/bash
# author: sunday
# date: 20180611
# 排除数据库，自动化备份所有数据库
#GRANT SELECT, SHOW DATABASES, LOCK TABLES, EVENT,SHOW VIEW, RELOAD,SUPER,REPLICATION CLIENT ON *.* TO 'backup'@'localhost' identified by 'wLJt+hYgiHO4P3YsjzPwmE0d4jM+';
#flush privileges;

MySQL=/usr/local/webserver/mysql/bin/mysql
MySQLDUMP=/usr/local/webserver/mysql/bin/mysqldump
BACKUP_PATH=/data/bak/mysql
DATABASE_CONN_NAME=`$MySQL -ubackup -hlocalhost -p'wLJt+hYgiHO4P3YsjzPwmE0d4jM+' -e "show databases;"`
DATABASE_NAME=`echo $DATABASE_CONN_NAME | sed 's/\(Database \|mysql \|sys \|information_schema \|performance_schema \)//g'`
TIME=`date +%F`

for DB_NAME in $DATABASE_NAME;do
  $MySQLDUMP--set-gtid-purged=OFF --single-transaction --routines --triggers --master-data=2 --flush-logs -ubackup -hlocalhost -p'wLJt+hYgiHO4P3YsjzPwmE0d4jM+' $DB_NAME > $BACKUP_PATH/$DB_NAME-$TIME.sql
  #echo $DB_NAME-$TIME
  tar -czf $BACKUP_PATH/$DB_NAME-$TIME.tar.gz $BACKUP_PATH/$DB_NAME-$TIME.sql
  find $BACKUP_PATH -type f -name "*.sql" | xargs rm -rf
  #find $BACKUP_PATH -type f -name "*.sql.tar.gz" -mtime +7 | xargs rm -rf
done

