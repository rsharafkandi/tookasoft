#!/bin/bash

# script name: mysql_full_backup.sh
#
# revision  date        by                 description
#---------------------------------------------------------------------------
# 1.00   25th Oct 2016  Ramin Sharafkandi  The script was developed and scheduled to be run
#                                          on db-3 machine
#
# Purpose: This script is run by crontab daemon and makes a full sql dump of all databases of
# mariadb running instance. to run script safely these conditions must be met:
# a) script must run on the machin running mariadb
# b) mariadb root password must be saved in .my.cnf file located at the home folder of user running
#    script
# c) enough space must be available at location pointed to by dump_parent_folder
# to secure the process it's better to make the permissions of file .my.cnf equal to 0400
# ie. readable by owner.
#
# This script checks the path pointed to by $dump_parent_folder variable and if it's not a separate
# mounted filesystem, then it exits

dump_parent_folder="/Data/mysql"
today_date=`date +%Y%m%d`
dump_folder=`echo ${dump_parent_folder}/${today_date}`

mnt_cnt=`mount -l | grep -c "$dump_parent_folder"`
if  [ "$mnt_cnt" -lt 1 ]; then
  echo "ERROR! $dump_parent_folder is not mounted! exiting ..."
  exit 1
fi

mkdir -p $dump_folder
cur_time=`date +"%Y-%m-%d-%H:%M:%S"`
filename=`echo all-db-${cur_time}.sql.gz`
/usr/bin/mysqldump -u root --all-databases --default-character-set=utf8 --single-transaction | gzip >${dump_folder}/${filename}
