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

### Setup Wireguard on VPS

### Setup Caddy Reverse Proxy