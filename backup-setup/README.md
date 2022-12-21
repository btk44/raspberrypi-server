# Backup setup
The goal is to make automatic backup to external hard drive. I my case there are 2 external drives
* the one with operating system and all docker volumes
* the one for making backup of selected files

To achieve this we will use rsync command and crontab file.

## :small_orange_diamond: rsync:
The command synchronizes source directory with target directory. I strongly recommend to read manual page to pick command arguments that will fit your needs. Command usage:
```
rsync -avh --delete source_directory/ target_directory/
```
Parameters used:
* a - archive mode
* v - increase verbosity
* h - display log in human readable form
* --delete - if there is a file deleted in source folder then in target it will be deleted as well

Above command will keep source and target directories the same (be careful with deleting files).

## :small_orange_diamond: rsync files:
###  :small_blue_diamond: backup_action.sh
The file handles mounting the external drive, making a backup and umounting the drive after. To make it work you have to provide:
* backup drive uuid - you can get it with command `sudo blkid`
* backup drive mounting point - create it before running the script with `mkdir`
* backup source - directory to source (remember to put / at the and)
* backup target - directory to copy files to (may be the same as backup drive mounting point)
* backup log - path to log file where you can read the command output

Note: why the script is umounting the external drive? It is done because when I skipped this part and unplugged the drive sometimes I was loosing data. When it is umounted we can remove the drive any time.

## :small_orange_diamond: crontab:
I strongly recommend reading at least one crontab tutorial to be familiar with time options. The format of crontab line looks like this:
```
* * * * * command_to_run
```
where each `*` represents time unit. To make it easier you can try out your options here [crontab guru](https://crontab.guru). 
In `crontab_file` there are three lines that will run `backup_action.sh` script. To make it work run command:
```
crontab -e
```
You will be prompted with text editor selection. Just pick the one you like and when the file is opened just paste `crontap_file` content with correct directories that will point to `backup_action.sh` file. Save and it is done.

## :small_orange_diamond: fstab:
If you want to have your disks automatically mounted after reboot there are two options:
* use crontab line: `@reboot sudo mount UUID=your_disk_uuid` - uuid can be checked with `blkid` command
* use fstab by adding a line from `fstab_sample_entry_for_auto_mount` file to /etc/fstab 
  * remember that each value has to be separated with `TAB`
  * you have to put correct UUID of your drive and file system (vfat, ntfs, ext4) - see `blkid` command
  * create mounting point first! so it will exist when mounting will take place
  * use auto and nofail flags! nofail is the most important because the system will not boot if your disk is absent or mounting will go wrong

I decided to use crontab and `backup_action.sh` script so my backup drive will be mounted when needed only. Then it is umounted so it can be safely unplugged at any time without data loss.

## :small_orange_diamond: issues and troubleshooting
Here's a list of problems I've encountered (the list will be updated if I find sth new):
* be careful with directories here - if your backup doesn't work be sure to check them and remember about '/' at the end
* if your going to unplug backup drive sometimes then remember to umount it - this will prevent data loss
* sometimes (in backup_action.sh) automatic mounting fails and I can't ssh into the server
