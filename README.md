# --- under construction ---

## Simple home server with Raspberry Pi and Docker

The goal of this project is to prepare a home server using Raspberry Pi 4B computer. I decided to run everything using docker so all the apps I would use there would be contenerized (self-hosted). The server will have two disks - one for the operating system and keep data and the second just for backup. 

## Architecture
Since I wanted to forward only one port through my router (it is the easiest wayto access your server from outside networks) I decided to use VPN gateway. That is why I connected all app containers into my custom bridge network and acces it (the network) through VPN container. More on that later. 

> image will be here soon 

## Setup

This setup will cover:
* installing operating system and accessing it via ssh
* installing docker
* installing docker containers: portainer, nextcloud, wireguard, samba - using docker-compose and installing with portainer
* setting up a custom bridge network to access containers only through VPN connection
* installing wireguard client on ubuntu/debian and connecting to the server
* setting up automatic backup using crontab and rsync (+ fstab mounting option)
* description of issues that occured during the setup 
