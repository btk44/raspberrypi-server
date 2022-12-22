#!/bin/bash

backup_drive_uuid=SOMEUUIDNUMBEROFTHEDRIVE # see sudo blkid
backup_drive_mount=/directory/to/your/mounting/piont/
backup_source=/directory/to/backup/ # remember to add / at the end 
backup_target=$backup_drive_mount/subfolder/in/mounted/drive 
backup_log=/path/to/your/logfile.txt
now=$(date)

echo "\n\n--------------------------------------------------------\nLog from date: $now :\n" >> $backup_log

sudo mount UUID=$backup_drive_uuid $backup_drive_mount >> $backup_log # this command sometimes fails (very rare) and bloks ssh
sleep 30
sudo rsync -avh --delete $backup_source $backup_target >> $backup_log 
sudo umount $backup_drive_mount >> $backup_log

echo "\n--------------------------------------------------------" >> $backup_log

