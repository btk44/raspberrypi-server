# System preparation
### installing operating system:
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

Now go to: [docker-setup](https://github.com/btk44/raspberrypi-server/tree/main/docker-setup)
