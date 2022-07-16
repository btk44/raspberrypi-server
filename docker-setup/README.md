# Docker setup
* Note: This is the second step. For initial system setup go to: [server-setup](https://github.com/btk44/raspberrypi-server/tree/main/server-setup).
* Note: This setup was inspired by pi-hosted project - if you're interested in more RPi self-hosted apps - check it out

## files:
### :small_blue_diamond: install_docker.sh
Run the script to install docker on your RPi. Remember to reboot/logout after running it to apply user group assignments.
```
./install_docker.sh
```

### :small_blue_diamond: install_portainer.sh and update_portainer.sh
Run scripts to install or update portainer on your RPi:
```
./install_portainer.sh
```

After this you should be able to access portainer through your web browser (from other computer in your local network). Go to:
```
http://your_hostname_from_settings:9000/ or http://your_RPi_ip_address:9000/
```

In case portainer shows notifications about a new version run:
```
./update_portainer.sh
```

## creating and running containers:

### :small_blue_diamond: docker-compose
To be able to install containers via compose files run command:
```
sudo apt-get install docker-compose -y
```
### :small_blue_diamond: setup custom bridge network
Before running containers creation you need to create custom bridge network. To keep it simple run:
```
docker network create --driver=bridge vpn-network
```
### :small_blue_diamond: current containers configuration
All containers compose files are set up for a test account on my RPi. The RPi user's name is `bk`. After running all compose files a new directory will be created in `/home/bk` named `docker-data`. 

### :small_blue_diamond: wireguard
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
* in volume section replace `/home/bk/docker-data/rpi-wireguard/config` with path you want to use to store configuration (client certs will be there), i.e. `/home/your_user_name/wireguard/config`

Now go to terminal and enter command:
```
docker-compose up -d
```
The container should be up and running and in the config directory you provided you should find client certificates (peer1, peer2, etc.). You can check if container is up through portainer web interface.

### :small_blue_diamond: nextcloud
Go to nextcloud directory and edit docker-compose.yml (use vim or nano):
```
cd nextcloud
nano docker-compose.yml
```
Set values:
* container_name -> put your container name. This will be used to access nextcloud via browser, i.e. `https://rpi-nextcloud/`
* PUID, PGID and TZ should be filled like in wireguard container
* in volumes section replace `/home/bk/docker-data/rpi-ncp/config` and `/home/bk/docker-data/rpi-ncp/data` with paths you want to use. Data path is the directory where all your files will be stored. (-- add troubleshooting with .ocdata file --)
* set values for: `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` - they will be needed when you first run nextcloud in browser and you will connect to the database
* in volumes section replace `/home/bk/docker-data/rpi-ncp/db` with correct path you want to store db

Important note! There are no ports exposed for the nextcloud - it is made on purpose because we want to access the container directly from custom network that will be accessible through VPN connection.

Now go to terminal and enter command:
```
docker-compose up -d
```

### :small_blue_diamond: samba
This container will be installed using portainer to see how we can make setup manually (you can also use docker-compose file if you want to skip portainer).
In your webbrowser go to:
```
http://your_hostname_from_settings:9000/ or http://your_RPi_ip_address:9000/
```
On the left menu click <b>Home</b>. You should see list of environments. Select <b>local</b> environment. Then click on <b>containers</b> - this should take you to the list of all containers that are running in your docker. In left panel menu select <b>Settings</b>. 
![image](https://user-images.githubusercontent.com/97596263/179357868-4593528b-30c3-427c-af52-6629b20a2239.png)


After the page is loaded in <b>App Templates</b> section paste this url:
```
https://raw.githubusercontent.com/pi-hosted/pi-hosted/master/template/portainer-v2-arm64.json
```
![image](https://user-images.githubusercontent.com/97596263/179358002-88369e19-cf32-47ce-91e9-23df45a26630.png)

This is a link from [pi-hosted](https://github.com/novaspirit/pi-hosted) repository that will provide ready container templates ready for deployment. Click <b>Save settings</b> and now go to App Templates (in left panel menu). You can read the list of available containers there, but for now type <b>samba</b> in the search field. 
![image](https://user-images.githubusercontent.com/97596263/179358095-e5933ac6-d865-4f01-a71f-8c4afc54eeb4.png)

Then select the template that will show up - this should take you to setup screen:
![image](https://user-images.githubusercontent.com/97596263/179358268-f78830d9-0da4-465a-961b-21aca98f66d7.png)

Now you need to configure it:
* Name: put your container name here i.e. rpi-samba
* Network: select the network that was created before via terminal (vpn-network)
* PUID, USERID, GROUPID: should be the same as in nextcloud and wireguard containers
* USER: provide credentials to access your shared folder from other computers. Format is user_name;password - remember that the separator must be semicolon (;)
* SHARE: provide the name you want to see in your network and access rules. Final format should look like this: `name_of_folder_in_your_network;/share;yes;no;yes;user_name_from_USER_field`. Access flags are: `browsable(yes);read only(no);guest access(yes)` if you'd like to set them differently.

Once it is done click on <b>Show advanced options</b> and remove all port mappings (if you want to access container only through VPN). Next set the path to the directory that you want to share in <b>Volume mapping</b> host field.

Now you can click <b>Deploy the container</b> button. It will take a while to start it, be patient.

## connecting to the vpn:
In your PC (I'm assuming you are using linux debian-like distro) go to terminal and run the command:
```
sudo apt-get install wireguard resolvconf -y
```
It will install wireguard on your computer and now we only need the configuration file. To get it we need to ssh to our RPi. Open terminal / cmd and run these commands:
```
ssh your_username_from_imager_settings@your_hostname_from_imager_settings
--- enter password ---
cd /path/to/wireguard/config <---- the one you set up in wireguard docker compose file
cat peer1/peer1.conf
```
This should return the content of the configuration file. Now we need to copy that and save to /etc/wireguard/ directory in our PC. Let's name it `vpn-wg.conf`.
Make sure the file `/etc/wireguard/vpn-wg.conf` exists. Now run the command (in new terminal):
```
sudo wg-quick up vpn-wg
```
To see if it worked go back to ssh terminal and run command:
```
docker exec -it wireguard_container_name wg
```
This should list all the peers and the time of the latest handshake. I case you'd like to disconnect just run: 
```
sudo wg-quick down vpn-wg
```

If the connection was successful you should be able to access all other containers.

### :small_blue_diamond: accessing containers
![image](https://user-images.githubusercontent.com/97596263/179358747-4d44960d-04ba-4323-8e01-192f8c326aa0.png)

After connecting to vpn you should be able to access containers by their names:
* portainer :arrow_right: go to `http://portainer:9000/`
* nextcloud :arrow_right: go to `https://rpi-nextcloud/` - you may be asked to accept certificate risk
* samba  :arrow_right: go to file manager (nautilus in my case) and click <b>Other locations</b>. Then in address bar type `smb://rpi-samba/`. Then a pop-up should be shown where you have to provide username and password to access files.

## issues and troubleshooting
