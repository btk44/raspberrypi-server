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

## :small_orange_diamond: Installing network manager and updating the system (optional)
Start with updating the system:
```
sudo apt update
sudo apt full-upgrade
sudo reboot
```
Then install network manager and go to raspi-config:
```
sudo apt install network-manager
sudo raspi-config
```
Then go to Advanced Options -> Network Config -> pick Network Manager

<img src="https://user-images.githubusercontent.com/97596263/219944455-b42818e5-cf65-419a-bfb6-6aa2aa4e0ee7.png" width="32%"/> <img src="https://user-images.githubusercontent.com/97596263/219944489-ccddc52a-ef78-40af-a7b2-b7b7234b23c1.png" width="32%"/> <img src="https://user-images.githubusercontent.com/97596263/219944493-365f84a8-4288-430d-909b-fa7aad960c35.png" width="32%"/>

After that reboot the system:
```
sudo reboot
```
Once Pi is up find and connect to your wifi:
```
sudo iw wlan0 scan | grep SSID
sudo nmcli --ask dev wifi connect <SSID>
```


## :small_orange_diamond: Issues and troubleshooting:
Here's a list of problems I've encountered (the list will be updated if I find sth new):
* sometimes during the first RPi boot from external drive - it took a little longer to get it running. It looked like RPi was rebooting again for some reason. But after that it worked ok
* I decided to use external ssd drive instead of a ssd card because of bad opinions about it. It looks like they like to break quite often
* the fan I used is always turned on when the server is powered off (but have power supply plugged in) - don't know yet if it can be fixed
* when PRi is connected to my router via cable some of other devices in the wifi network have connection issues. Once RPi is connected via wifi - there are no issues
* RPi has problems with powering more than one 2.5" ssd/hdd disk via USB ports - if you want to have more disks consider using USB hub with power supply or kind of disk docking station
  * even if you use additional power supply sometimes you may be forced to reboot RPi after plugging in the disk. In my case the disk was not found before the reboot (rare but it happend at least twice)
* most of simple fans dedicated for PRi have only 2 pins - this means that they will run forever and cannot be controlled - look for 3-pin fan or consider using transistor and add 3rd pin on your own. Or you can go for passive cooling (radiator) - it makes no noise and give similar effects.
* after some time of usage my Pi had problems with wifi connection - it was lost after 24 haours and there was no way to reconnect. Problem was solved after reboot but only for next 24 hours. I decided to update stystem and install network manager (see section above) - and now it works.
* modern routers sometimes tend to disconnect devices that are not actively using wifi connection so they may disconnect the pi - solution here is using a script that will be pinging the router and creating a crontab job that will execute the script every 10 minutes (example will be provided soon)
* sometimes I get an error like:
  ```
  __ext4_find_entry:xxxx: inode #xxxxx: comm .... lblock 0
  ```
  and there is only hard reset possible. Unfortunately this means that there is something wrong with power supply (not enough power delivered) or external drive have some kind of power management and went to sleep mode - I have no solution for that except trying out other charger or other external disk and see if the problem occurs (try plugging the charger to other outlet in the wall - maybe there is something wrong with the one the pi is using)
