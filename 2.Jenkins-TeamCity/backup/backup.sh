#!/bin/bash

backup_files="/home/ubuntu/jar"

dest="/home/ubuntu/backup"


day=$(date +%T)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

date

tar czf $dest/$archive_file $backup_files

date
