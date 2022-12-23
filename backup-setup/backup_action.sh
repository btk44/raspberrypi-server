#!/bin/bash

backup_drive_uuid=SOMEUUIDNUMBEROFTHEDRIVE # see sudo blkid
backup_drive_mount=/directory/to/your/mounting/piont/
backup_source=/directory/to/backup/ # remember to add / at the end 
backup_target=$backup_drive_mount/subfolder/in/mounted/drive 
backup_log=/path/to/your/logfile.txt
now=$(date)

case $1 in

  m) # run: "sh backup_action.sh m"
    sudo mount UUID=$backup_drive_uuid $backup_drive_mount >> $backup_log # this command sometimes fails (very rare) and bloks ssh
    ;;

  u) # run: "sh backup_action.sh u"
    sudo umount $backup_drive_mount >> $backup_log
    ;;

  b) # run: "sh backup_action.sh b"
    echo "\n\n--------------------------------------------------------\nLog from date: $now :\n" >> $backup_log
    sudo rsync -avh --delete $backup_source $backup_target >> $backup_log
    echo "\n--------------------------------------------------------" >> $backup_log
    ;;

  *)
    echo "unknown action"
    ;;
esac
