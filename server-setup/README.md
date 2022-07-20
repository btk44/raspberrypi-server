# System preparation
## :small_orange_diamond: installing operating system:
For the installation use Raspberry Pi Imager available here: [link](https://www.raspberrypi.com/software/).
It lets choose OS you want and setup some general options like hostname, user, wifi connection, SSH, etc. After running Imager on your machine (not RPi):
* select Raspbery Pi OS (other) -> Raspberry Pi OS Lite (64-bit)
* in settings (little cog wheel icon in bottom right corner):
  * set hostname - to be able to connect to RPi using its name instead of IP address
  * enable SSH using password authentication
  * set username and password 
  * enable wifi (optional - you can always disable it later) 
* instead of using sd card that was added to RPi I recommend installing system on external SSD 2.5" drive and connected it to USB3 port (yes, that works!)

Now turn on your RPi and let it boot (it may take some time). To connect via SSH you need to know your RPi's IP address or in case setting hostname worked you can use the name.
* open terminal / cmd window in your (other) computer
* type `ssh your_username_from_settings@your_hostname_from_settings` and hit enter
* in case hostname is not working you have to check RPi's IP by:
  * checking it in your router (usually this is available in web browser going to address 192.168.1.1)
  * connecting RPi to external monitor and type `ip addr show`

Done!

## :small_orange_diamond: files:

### :small_blue_diamond: 01-system-setup.sh 
Run script to update apt and install git and vim
```
sh 01-system-setup.sh
```

### :small_blue_diamond: 02-repos-git-pull.sh
Run script to download repositories:
* [pi-hosted](https://github.com/novaspirit/pi-hosted) - I strongly recommend to get familiar with it. This repository and building home server with RPi and docker was inspired by pi-hosted
* [fanshim](https://learn.pimoroni.com/article/getting-started-with-fan-shim) - it is needed only if you have Pimoroni Fan installed on your RPi

```
sh 02-repos-git-pull.sh
```

### :small_blue_diamond: 03-fan-install.sh
Run script to install Pimoroni Fan service - if you're using the same fan

```
sh 03-fan-install.sh
```

:arrow_right: Now go to: [docker-setup](https://github.com/btk44/raspberrypi-server/tree/main/docker-setup)

## :small_orange_diamond: Issues and troubleshooting:
Here's a list of problems I've encountered (the list will be updated if I find sth new):
* sometimes during the first RPi boot from external drive - it took a little longer to get it running. It looked like RPi was rebooting again for some reason. But after that it worked ok
* I decided to use external ssd drive instead of a ssd card because of bad opinions about it. It looks like they like to break quite often
* the fan I used is always turned on when the server is powered off (but have power supply plugged in) - don't know yet if it can be fixed
* when PRi is connected to my router via cable some of other devices in the wifi network have connection issues. Once RPi is connected via wifi - there are no issues
* RPi has problems with powering more than one 2.5" ssd/hdd disk via USB ports - if you want to have more disks consider using USB hub with power supply or kind of disk docking station
* most of simple fans dedicated for PRi have only 2 pins - this means that they will run forever and cannot be controlled - look for 3-pin fan or consider using transistor and add 3rd pin on your own

