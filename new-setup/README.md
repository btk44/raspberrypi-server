## New container architecture 
The new setup will contain following containers:
* wireguard - vpn that will protect internal network 
* pi-hole + unbound - filtering ads and dns setup with pretty domain names
* nginx-proxy-manager - to provide certificates for containers that requires them
* nextcloud - store files
* bitwarden - store passwords
* samba - for file share in the windows style
* flame - just a pretty interface to keep all the links to other containers 
* portainer - visual container management

## Architecture diagram
