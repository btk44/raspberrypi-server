# System preparation
Note: Used system: Ubuntu (Debian)
Note: all scripts are pointing to directory ~/server-setup - copy this folder to your home or modify scripts to use other directory

## files:

### 01-system-setup.sh 
Run script to update apt and install git and vim
```
sh 01-system-setup.sh
```

### 02-repos-git-pull.sh
Run script to download repositories:
* [pi-histed](https://github.com/novaspirit/pi-hosted) - I strongly recommend to get familiar with it. This repository and building home server with RPi and docker was inspired by pi-hosted
* [fanshim](https://learn.pimoroni.com/article/getting-started-with-fan-shim) - it is needed only if you have Pimoroni Fan installed on your RPi

```
sh 02-repos-git-pull.sh
```

### 03-fan-install.sh
Run script to install Pimoroni Fan service - if you're using the same fan

```
sh 03-fan-install.sh
```
