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

### - installing docker and portainer
This is the point where I must recommend [pi-histed project](https://github.com/novaspirit/pi-hosted). There is a lot of information about running self-hosted applications. 

To install docker and portainer just run scripts from docker-setup directory (they are just copies from pi-hosted):
```
cd docker-setup
./install_docker.sh
```
 
Now log off or reboot to apply user group changes. Then:
```
cd docker-setup
./install_portainer.sh
./update_portainer.sh
```

After this you should be able to access portainer through your web browser. Go to:
```
http://your_hostname_from_settings:9000/ or http://your_RPi_ip_address:9000/
```
### - installing docker containers
#### wireguard
We will start with wireguard container. To be able to create docker container we need to install docker-compose:
```
sudo apt-get install docker-compose -y
```

Now go to docker-setup/wireguard and edit docker-compose.yml file:
* container_name -> put the name you want 
* PUID and PGID -> put your user id and group id here. If you don't know the numbers use these commands:
```
whoami -> this will give you your_user_name
id your_user_name -> this will list you UID and GID
```
* TZ -> your timezone
* SERVERURL -> if you want the server acessible via local network only then use your RPi local ip address (192.168.?.?), if from outside use your external ip or ddns url (this requires router port forwarding and setting up ddns if your external ip is changing - more on that later?)
* PEERS -> the number of certificates for clients you want to generate
* in volume section replace `/host/path/to/wireguard/config' with path you want to use to store configuration (client certs will be there)

Now go to terminal and enter docker-setup/wireguard directory. Run command:
```
docker-compose up -d
```

The container should be up and running and in the config directory you provided you should find client certificates (peer1, peer2, etc.). You can check if container is up through portainer web interface.

#### nextcloud
There is a container called nextcloudpi, but in my case it was breaking all the time. That is why I recommend running classic nextcloud container. 
Go to docker-setup/nextcloud and edit docker-compose.yml file:
* container_name -> put your container name. This will be used to access nextcloud via browser, i.e. `https://my_nextcloud_container_name/`
* PUID, PGID and TZ should be filled like in wireguard container
* in volumes section replace `/host/path/to/config` and `/host/path/to/data` with paths you want to use. Data path is the directory where all your files will be stored. (-- add troubleshooting winh .ocdata file --)
* set values for: `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` - they will be needed when you first run nextcloud in browser and you will connect to the database
* in volumes section replace `/host/path/to/db` with correct path you want to store db

Important note! There are no ports exposed for the nextcloud - it is made on purpose because we want to access the container directly from custom network that will be accessible through VPN connection.

June 29 2022 - to be continued... tomorrow 😉
