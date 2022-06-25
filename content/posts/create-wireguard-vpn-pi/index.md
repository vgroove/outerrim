---
author: "vgroove"
title: "Wireguard on Raspberry Pi"
tags: ["self-hosted"]
date: 2022-01-02
categories: ["self-hosted"]
weight: 10
resources:
- src: "images/wireguard-pi.png"
  title: "Wireguard and Raspberry Pi Icons"
  name: featured
---

There are lots of tutorials online about setting up Wireguard on a Raspberry Pi, this is just how I chose to do it. However, the two things my previous installs were missing were reliability (my previous install corrupted the SD card after running for about a year) and a nice web UI that could monitor the amount of traffic per client. So this tutorial includes:

* Installing Wireguard
* Installing [Linguard](https://github.com/joseantmazonsb/linguard) - A nice web UI that monitors traffic and allows adding/modifying interfaces and firewall rules nicely.
* Installing [log2ram](https://github.com/azlux/log2ram) - Utility that limits writing system logs to the SD card to extend it's life.

### Install Wireguard

1. Install Raspberry Pi OS:
  1. Using their imager tool:
    1. Download `rpi-imager` from your package manager or from the [RPi website](https://www.raspberrypi.com/software/).
    1. Using `rpi-imager` install Raspberry Pi OS Lite to your SD card with the following options:
      1. Create user (in my case `wg`).
      1. Allow ssh.
      1. Set the hostname (in my case `wireguard`).
  1. Using `dd`:
    1. Download the Raspberry Pi OS Lite image from the [RPi website](https://www.raspberrypi.com/software/).
    1. Flash the image to your SD card using something like `sudo dd if=/path/to/os.img of=/dev/SD_CARD_PATH conv=fsync bs=64K status=progress`. The `conv=fsync` insures the entire contents are written to the card itself by the end of the `dd` operation, there's a good explanation [here](https://abbbi.github.io/dd/).
    1. Use `echo 'mypassword' | openssl passwd -6 -stdin` to created a file `userconf.txt` in the boot partition of new SD card with the format `username:encrypted-password`. I made the user `wg`.
    1. Use `touch ssh` in the root of the boot partition of the SD card to allow ssh on first boot.
    1. Edit `/etc/host` to be the desired hostname (in my case `wireguard`)
1. Boot up the pi and ssh into it.
1. Run a `sudo apt update` and `sudo apt upgrade`.
1. Run `sudo apt install wireguard`.
1. You don't have to do this yet, but once I got interfaces set up I wasn't able to connect from the client to devices on the network besides the interface itself. So I ran `sudo sysctl -w net.ipv4.ip_forward=1` in order to make my wireguard interfaces route properly. You can run it at this point to ensure that doesn't happen later.

### Install Linguard

1. Download the latest release from the [Linguard github](https://github.com/joseantmazonsb/linguard).
1. I had to use `sudo apt install libopenjp2-7` in order to have all the dependencies for Libguard 1.1.
1. Untar the source you downloaded and run the `install.sh` script.
1. Navigate to `wireguard.lan:8080` (of course using whatever hostname you set up) and complete the initial Linguard setup there.
1. The first thing is to go to the *Settings* page of Linguard to set your endpoint address. This is the address that your clients will use to connect to your VPN. In my case I was using a dynamic DNS service to point to my home address, so I put in my DDNS URL.
1. Choose to setup a new interface by clicking the `+` icon in the upper right of the *Interfaces* box.
1. Give the interface an appropriate name and description, I have one I use for personal devices to have direct VPC access (I call it `home-private`) and one I use for a tunnel out to a VPS that I'll describe in another post (I call it `home-public`).
1. Ensure the gateway is set to the network you want the VPN to connect your devices to, on a Pi that will either be the `eth0` or `wlan0` network.
1. The rest can be left mostly default unless you already know you want some different firewall rules within this VPN interface, or if you want to resize the subnet to be more appropriate. I usually make it a `/29` just because it's unlikely I'll ever have more than 7 devices on the interface.
1. Create a new peer (ex. a phone that will connect to the VPN) by clicking the `+` icon in the upper right of the *Peers* box.
1. Choose which interface it should use (ex. `home-private`), as well as the IP it should have. If you have custom DNS set up, this is your chance to tell it to use your internal DNS instead of the default Google DNS.
1. Now from the dashboard you can either hit the *Download* icon on the peer to download the wireguard settings which you can move to your phone/laptop/computer. Or you can hit the *Edit* icon and use the QR code generator if you're moving it to a device with the ability to scan QR codes.

### Install log2ram

1. Installing log2ram is pretty simple, you can follow the instructions on their [github](https://github.com/azlux/log2ram). But just in case here's what they have on their now (v1.6.1).
```
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ bullseye main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
sudo apt update
sudo apt install log2ram
```
2. Reboot the pi.
1. Ensure it's running using `systemctl status log2ram` and you can also inspect the log in RAM using, if the `df` command below doesn't output anything then it's not working.
```
# df -h | grep log2ram
log2ram          40M  532K   40M   2% /var/log
```