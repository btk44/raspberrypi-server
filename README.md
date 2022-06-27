# --- under construction ---

## Simple home server with Raspberry Pi and Docker

The goal of this project is to prepare a home server using Raspberry Pi 4B computer. I decided to run everything using docker so all the apps I would use there would be contenerized (self-hosted). The server will have two disks - one for the operating system and keeping data and the second just for making backup. 

## Architecture
Since I wanted to forward only one port through my router (it is the easiest way to access your server from outside networks) I decided to use VPN gateway. That is why I connected all app containers into my custom bridge network and acces it (the network) through VPN container. More on that later. 

> image will be here soon 

## Setup - list of content

This setup will cover:
* installing operating system and accessing it via ssh
* installing docker
* installing docker containers: portainer, nextcloud, wireguard, samba - using docker-compose and installing with portainer
* setting up a custom bridge network to access containers only through VPN connection
* installing wireguard client on ubuntu/debian and connecting to the server
* setting up automatic backup using crontab and rsync (+ fstab mounting option)
* description of issues that occured during the setup 

### - installing operating system
For the installation I used Raspberry Pi Imager available here: [link](https://www.raspberrypi.com/software/)
It lets choose OS you want and setup some general options like hostname, user, wifi connection, SSH, etc. (see cog wheel for settings). For my Raspberry:
* select Raspbery Pi OS (other) -> Raspberry Pi OS Lite (64-bit)
* in settings:
  * set hostname - to be able to connect to RPi using its name instead of IP address
  * enable SSH using password authentication
  * set username and password 
  * enable wifi (optional - you can always disable it later) 
* instead of using sd card that was added to RPi I installed system on external SSD 2.5" drive and connected it to USB3 port (yes, that works!)

Now to connect via SSH you need to know your RPi's IP address or in case setting hostname worked you can use the name.
* open terminal / cmd window in your (other) computer
* type `ssh your_username_from_settings@your_hostname_from_settings` and hit enter
* in case hostname is not working you have to check RPi's IP by:
  * checking it in your router (usually this is available in web browser going to address 192.168.1.1)
  * connecting RPi to external monitor and type `ip addr show`

Done!

June 27 2022 - to be continued... tomorrow 😉
