# Backup setup
The goal is to make automatic backup to external hard drive. I my case there are 2 external drives
* the one with operating system and all docker volumes
* the one for making backup of selected files

To achieve this we will use rsync command and crontab file.

## rsync:
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

## rsync files:
### backup_action.sh
The file handles mounting the external drive, making a backup and umounting the drive after. To make it work you have to provide:
* backup drive uuid - you can get it with command `sudo blkid`
* backup drive mounting point - create it before running the script with `mkdir`
* backup source - directory to source (remember to put / at the and)
* backup target - directory to copy files to (may be the same as backup drive mounting point)
* backup log - path to log file where you can read the command output

Note: why the script is umounting the external drive? It is done because when I skipped this part and unplugged the drive sometimes I was loosing data. When it is umounted we can remove the drive any time.

## crontab:
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
