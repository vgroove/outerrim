---
author: "vgroove"
title: "Self Hosted Stock Checking"
tags: ["huginn", "self-hosted"]
date: 2021-01-22
categories: ["self-hosted"]
weight: 10
resources:
- src: "images/huginn_icon.png"
  title: "Huginn Icon"
  name: featured
---

In the times of COVID-19, many things sold online are currently out of stock. Some people enjoy constantly hitting F5 on webpages, but for the rest of us there has to be a better way.

There are a couple of browser extension options and cloud-based options such as [Distill.io](https://distill.io/) which work great, but cost money or require a browser to be left open and running. Anyone who runs a home server has a couple more efficient options:

* Write a script to periodically `wget` a web page, parse the html and look at the appropriate tags. This is great and quick, but if you have dozens of things to check can get cumbersome.
* Run [Huginn](https://github.com/huginn/huginn) and create an "agent" to monitor specific pages.

We'll take a quick look at [Huginn](https://github.com/huginn/huginn) here.

I run a NAS in my home setup where most of my home services run as docker containers. Luckily the Huginn team has two deployable containers already up on the docker hub. The multi-process container (the standard install) and the single-process (used for scalability of individual agents). See [here](https://github.com/huginn/huginn/tree/master/docker) for more details. So, all we have to do is pull huginn/huggin from the docker hub, set up a volume to `/var/lib/mysql` so we can back up the database easily, then choose which port to map to the container's web UI (by default 3000).

Once that is up and running we can create new "Website Agent" that will monitor a web page for changes.  I won't go into detail on the configuration, but I'll post my example configuration for monitoring for a [REP weight tree](https://www.repfitness.com/bars-plates/storage/plates/bar-and-bumper-plate-tree).

```
{
  "expected_update_period_in_days": "2",
  "url": "https://www.repfitness.com/bars-plates/storage/plates/bar-and-bumper-plate-tree",
  "type": "html",
  "mode": "on_change",
  "extract": {
    "stock": {
      "xpath": "//*[@id=\"maincontent\"]/div[2]/div/div[2]/div[1]/div[1]/div[3]/div[1]",
      "value": "."
    }
  }
}
```

I got the `xpath` by simply opening up the developer tools in Chrome, using the pointer tool to highlight the "Out of Stock" element, then right clicking the element and going to Copy -> XPath.
