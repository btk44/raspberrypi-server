cd fanshim-python
sudo ./install.sh
cd examples
sudo apt-get install python3-pip -y

sudo ./install-service.sh --on-threshold 65 --off-threshold 55 --delay 2 --brightness 5
