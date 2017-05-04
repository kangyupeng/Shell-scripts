#!/bin/sh
# 1129004103@qq.com

#usage:
#-------------------------------------------------------------------
# dbname，你需要备份数据库名字。
# dbname,dbusername,修改为对应数据库用户名和密码。
# db_backup_name,为导出后的sql文件名字，根据需要自己起名即可。
#-------------------------------------------------------------------


dbname="ceshi_20170501"
dbusername="-uroot"
dbpassword="-p123456"
backup_time=`date +"%Y%m%d%H"`
db_backup_dir="/data/DataBack"
db_backup_name="test"
format=".tar.gz"


#导出指定数据库
if [[ -d $db_backup_dir ]]; then
    /usr/bin/mysqldump $dbusername $dbpassword $dbname > $db_backup_dir/$db_backup_name-$backup_time.sql
    mkdir $db_backup_dir/log
    echo "Backup success." $backup_time >> $db_backup_dir/log/dbback.log
else
    cd /home;mkdir -p dataBackup/log
    /usr/local/mysql/bin/mysqldump $dbusername $dbpassword $dbname > $db_backup_dir/$db_backup_name-$backup_time.sql
    echo "Backup2 success." $backup_time >>  $db_backup_dir/log/dbback.log
fi

#将备份文件压缩为tar.gz格式

cd $db_backup_dir
if [[ -f $db_backup_name-$backup_time.sql ]]; then
    tar -czvf $db_backup_name-$backup_time$format $db_backup_name-$backup_time.sql
    echo "Compression complete." $backup_time >> $db_backup_dir/log/dbbak.log
fi

#删除导出的sql文件
cd $db_backup_dir
if [[ -f $db_backup_name-$backup_time.sql ]]; then
    rm -rf $db_backup_name-$backup_time.sql
    echo "Delete Sql file success." $backup_time >> $db_backup_dir/log/delsql.log
fi

#清除历史备份仅保留七天
find $db_backup_dir -type f -mtime +7 | xargs rm -f
