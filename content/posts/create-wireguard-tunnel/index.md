---
draft: true
author: "vgroove"
title: "Wireguard Tunnel through VPS"
tags: ["self-hosted"]
date: 2022-07-01
categories: ["self-hosted"]
weight: 10
resources:
- src: "images/INSERT_FILENAME.jpg"
  title: ""
  name: featured
---

Do you want to more-securely expose your self-hosted services to the internet? Do you like the idea of products like Cloudflare Tunnel, but would prefer more control over your infrastructure? Then this setup is for you! 

The basic idea is to host a reverse proxy on a basic Virtual Private Server (VPS) with a public IP, which then proxies traffic through a Wireguard connection to your home network. 

|Pros|Cons|
|----|----|
| - Hides your home IP from the world, since the VPS is the only one that needs to know it | - No built-in DDoS protection like Cloudflare provides |
| - Very easy to customize and implement your own protections | - Takes a bit more work (but you learn more!) |
| - Only dependent on VPS staying up, not on SaaS | |

### Prerequisites

You'll need the following already set up:

  - A public domain
  - A Wireguard server set up on your home network (see my setup [here]({{< ref "/posts/create-wireguard-vpn-pi" >}}))
  - Some self-hosted service you want to expose to the internet (e.g. I self-host [Foundry Virtual Tabletop](https://foundryvtt.com/) for playing DnD online)
  - A Virtual Private Server (VPS) that you can use to host your public endpoint. I set up a simple VPS with 1 CPU, 512 MB RAM, and 10 GB SSD running Ubuntu. So far it's only cost me $2.26 over the past 3 months.

### Setup Wireguard on VPS

First thing's first, once you can ssh to your VPS and have set up a non-root user, install wireguard and some networking tools (your default VPS install may already these).

```sudo apt install wireguard net-tools openresolv```

After that we can set up a separate network interface on the wireguard server that will be used just for traffic coming through the tunnel. If you glanced at my previous Wireguard tutorial, you'll have seen how I set up [Linguard](https://github.com/joseantmazonsb/linguard) to manage my interfaces through a web GUI. Here's a screenshot of my `home-public` interface.

{{< img path="images/linguard-home-public.png" caption="Wireguard interface for VPS tunnel" method="Fit" options="600x600" alt="home-public" >}}

I chose to make this a small `/29` subnet since it should only ever have 2 devices on it. The listening port is random, and in my case is just the port of the Raspberry Pi where Wireguard is running, my router does forwarding from a separate port. The iptables rules insert rules (`-I`) on the interface start, and delete them (`-D`) on interface stop. The `-i` and `-o` stand for in-interface and out-interface, meaning traffic can be received and sent through the specified interface. The rule containing `MASQUERADE` makes the traffic coming from this interface appear like it's coming from the Raspberry Pi to the rest of the network.

Once you have the interface set up you can export the wireguard `.conf` file and move it to your VPS. It should look something like this:

```
[Interface]
PrivateKey = some_random_private_key_here
Address = 10.10.20.2
DNS = 8.8.8.8

[Peer]
PublicKey = some_random_public_key_here
AllowedIPs = 10.10.20.1/29, 192.168.1.8/32
Endpoint = your_home_ip_or_hostname:your_vpn_port
```

### Setup Caddy Reverse Proxy