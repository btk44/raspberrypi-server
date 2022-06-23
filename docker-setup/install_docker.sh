#!/bin/bash

curl -sSL https://get.docker.com | sh || error "Failed to install Docker."
sudo usermod -aG docker $USER || error "Failed to add user to the Docker usergroup."
sudo apt-get install docker-compose -y
echo "Remember to logoff/reboot for the changes to take effect."

