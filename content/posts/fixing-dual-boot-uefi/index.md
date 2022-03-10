---
author: "vgroove"
title: "Fixing UEFI Dual Boot After Windows Update"
draft: true
tags: ["IT"]
date: 2022-01-10
categories: ["IT"]
weight: 10
resources:
- src: "images/uefi_logo.png"
  title: "UEFI"
  name: featured
---

The dreaded Windows update comes for us all. When it came for me recently Windows decided to completely bork my newly set-up dual-booted laptop. I was running Windows 10 and Pop!_OS with a UEFI based mobo. Instead of grub I went for the newer systemd-boot to give it a shot

efibootmgr --create --disk /dev/sda --part 1 --label "My new label" --loader \\EFI\\ubuntu\\shimx64.efi