# Docker setup
* Note: This is the second step. For initial system setup go to: [server-setup](https://github.com/btk44/raspberrypi-server/tree/main/server-setup).
* Note: This setup was inspired by pi-hosted project - if you're interested in more RPi self-hosted apps - check it out

## files:
### install_docker.sh
Run the script to install docker on your RPi. Remember to reboot/logout after running it to apply user group assignments.
```
./install_docker.sh
```

### install_portainer.sh and update_portainer.sh
Run scripts to install or update portainer on your RPi:
```
./install_portainer.sh
./update_portainer.sh
```

After this you should be able to access portainer through your web browser (from other computer in your local network). Go to:
```
http://your_hostname_from_settings:9000/ or http://your_RPi_ip_address:9000/
```
## creating and running containers:

### docker-compose
To be able to install containers via compose files run command:
```
sudo apt-get install docker-compose -y
```
### setup custom bridge network
--- coming soon ---

### wireguard
Go to wireguard directory and edit docker-compose.yml (use vim or nano):
```
cd wireguard
nano docker-compose.yml
```
Set values:
* container_name -> put the name you want 
* PUID and PGID -> put your user id and group id here. If you don't know the numbers use these commands:
```
whoami -> this will give you your_user_name
id your_user_name -> this will list you UID and GID
```
* TZ -> your timezone
* SERVERURL -> if you want the server acessible via local network only then use your RPi local ip address (192.168.?.?), if from outside use your external ip or ddns url (this requires router port forwarding and setting up ddns if your external ip is changing - more on that later?)
* PEERS -> the number of certificates for clients you want to generate
* in volume section replace `/host/path/to/wireguard/config` with path you want to use to store configuration (client certs will be there), i.e. `/home/your_user_name/wireguard/config`

Now go to terminal and enter command:
```
docker-compose up -d
```
The container should be up and running and in the config directory you provided you should find client certificates (peer1, peer2, etc.). You can check if container is up through portainer web interface.

### nextcloud
Go to nextcloud directory and edit docker-compose.yml (use vim or nano):
```
cd nextcloud
nano docker-compose.yml
```
Set values:
* container_name -> put your container name. This will be used to access nextcloud via browser, i.e. `https://my_nextcloud_container_name/`
* PUID, PGID and TZ should be filled like in wireguard container
* in volumes section replace `/host/path/to/config` and `/host/path/to/data` with paths you want to use. Data path is the directory where all your files will be stored. (-- add troubleshooting with .ocdata file --)
* set values for: `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` - they will be needed when you first run nextcloud in browser and you will connect to the database
* in volumes section replace `/host/path/to/db` with correct path you want to store db

Important note! There are no ports exposed for the nextcloud - it is made on purpose because we want to access the container directly from custom network that will be accessible through VPN connection.

Now go to terminal and enter command:
```
docker-compose up -d
```

### samba
