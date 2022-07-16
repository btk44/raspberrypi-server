 --- documentation in progress --- to be continued... July 17th 😉

## Simple home server with Raspberry Pi and Docker

The goal of this project is to prepare a home server using Raspberry Pi 4B computer. I decided to run everything using docker so all the apps I would use there would be contenerized (self-hosted). The server will have two disks - one for the operating system and keeping data and the second just for making backup. 

## Architecture
Since I wanted to forward only one port through my router (it is the easiest way to access your server from outside networks) I decided to use VPN gateway. That is why I connected all app containers into my custom bridge network and acces it (the network) through VPN container. 

<img src="https://github.com/btk44/raspberrypi-server/blob/main/diagram.png" alt="architecture" width="700"/>
As you can see in the picture there is only one port forwarded in my <b>router</b>. It will forward all requests to RPi VPN port and they will go through <b>wireguard container</b>. When the PC (local or not) has successful VPN connection then it will access <b>custom bridge network</b> and will be able to call all containers by theirs names, i.e. <b>http://nextcloud_container_name:443</b>. There is no other way to access those containers since they are not exposing any ports (see X symbol).

The only container that is exposing a port is portainer. I left it exposed to be able to connect from local network in case wireguard container is broken. I'll be able to look into containers without using ssh.

## Setup - list of content

This setup will cover:
* :arrow_right: [server setup](https://github.com/btk44/raspberrypi-server/tree/main/server-setup)
  * installing operating system and accessing it via ssh
  * description of issues that occured during the setup
* :arrow_right: [docker setup](https://github.com/btk44/raspberrypi-server/tree/main/docker-setup)
  * installing docker
  * installing docker containers: portainer, nextcloud, wireguard, samba (docker-compose and using portainer)
  * setting up a custom bridge network to access containers only through VPN connection
  * installing wireguard client on ubuntu/debian and connecting to the server
  * description of issues that occured during the setup
* :arrow_right: [backup setup](https://github.com/btk44/raspberrypi-server/tree/main/backup-setup)
  * setting up automatic backup using crontab and rsync (+ fstab mounting option)
  * description of issues that occured during the usage

## Warning! Before you start:
It may seem that home server would be easy to set up and will work like cloud storage. Unfortunately this is not entirely true. I will put a list with issues / comments that occured in my case. It might be short but I will add more if anything new will occur.
* server speed depends on your internet connection (upload and download speeds) - remember that
* RPi transfer is faster via cable than wifi 
* when RPi was connected via cable to my router some other devices in my network (1 PC, 1 phone and a printer) had issues with wifi connection
* my RPi cannot power 2x2.5" (one ssd and one hdd) drives connected via USB (no matter if usb2 or usb3) - it was causing errors and I needed to reboot the system. I have only one ssd disk (with the system) connected and the rest is connected via USB hub with external power supply.
