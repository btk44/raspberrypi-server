### connect bluetooth speaker
Install missing packages:
```
sudo apt install pulseaudio-module-bluetooth 
pulseaudio -k
pulseaudio --start
```

Scan for devices:
```
bluetoothctl scan on
```

Connect to selected device:
```
bluetoothctl pair AB:52:0D:45:1B:34 (this is device address example)
bluetoothctl connect AB:52:0D:45:1B:34
```

Run audio (you need to install audio player - in my case it is vlc):
```
vlc -I dummy  https://stream.someaddress.com/
```
