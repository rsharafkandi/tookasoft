#!/bin/bash

# script name: do_cleanup.sh
#
# revision  date        by                 description
#---------------------------------------------------------------------------
# 1.00   25th Oct 2016  Ramin Sharafkandi  The script was developed and scheduled to be run
#                                          on db-3 machine
#
# Purpose: This script is related to mysql_full_backup.sh and its purpose is to delete
# all backup older than 3 months (ie. 180 days)
#
# WARNING:
# script runs every night once and frees up some space. it deletes all files ending in ".sql.gz"
# in the "/Data/mysql" path, so do care copying files whose names match this pattern or you loose
# your data in an unrecoverable way

dump_parent_folder="/Data/mysql"

mnt_cnt=`mount -l | grep -c "$dump_parent_folder"`
if  [ "$mnt_cnt" -lt 1 ]; then
  echo "ERROR! $dump_parent_folder is not mounted! exiting ..."
  exit 1
fi

find $dump_parent_folder -name "*.sql.gz" -mtime +180 -delete
