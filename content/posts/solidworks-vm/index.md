---
author: "vgroove"
title: "Run SolidWorks in a Virtual Machine"
tags: ["3d-printing"]
date: 2021-08-19
categories: ["3d-printing"]
weight: 10
resources:
- src: "images/solidworks.png"
  title: "SolidWorks Icon"
  name: featured
---

The announcement of Valve's Steamdeck and the continued improvement of their Proton tool has brought me one step closer to abandoning Windows for good. 

However, one of the last things that keeps me going back to Mr. Gates is the lack of industry-standard CAD tools on linux. Don't get me wrong, tools like [FreeCAD](https://www.freecadweb.org/) and [OpenSCAD](https://openscad.org/) are great, but if I'm going to take the time to learn some CAD software I'd like to use software that will likely be used by future employers. So that means SolidWorks or Autodesk are my primary options. Both Fusion 360 and SolidWorks have some workarounds to sort of get them running in Wine, but that will require some upkeep, and I'm lazy. So that means...Windows.

I typically use VirtualBox to run any VM's, just because it's widespread and well-documented...and free. Once I have my Windows 10 Home virtual machine setup I go to install SolidWorks and am met with the following error:

`Using a standalone license for SOLIDWORKS is not supported in this virtual environment. You must use a SolidNetwork License (SNL).`

I initially think "Hey! I have a legal license for SolidWorks I should be able to install it where I want!"

As it turns out they do support using standalone licensing in virtual machines, but they only officially support VMware, Microsoft Hyper-V, Citrix, and Parallels virtualization. I don't want to pay for any of those, so can I make SolidWorks think it's actually running in a regular machine? Turns out you can! See the below script:

```
MNAME="solidworks-vm"
rand9="abcdefghi" #any 9 character string
rand20="abdcefghijklmnopqrst" #any 20 character string
rand8="abcdefgh" #any 8 character string

VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVendor" "American Megatrends Inc"
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVersion" "2.1.0"
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVendor" "ASUSTek Computer"

VBoxManage setextradata $VMNAME "VBoxInternal/Devices/pcbios/0/Config/DmiSystemSerial" $rand9

VBoxManage setextradata $VMNAME "VBoxInternal/Devices/ahci/0/Config/Port0/SerialNumber" $rand20

VBoxManage setextradata $VMNAME "VBoxInternal/Devices/ahci/0/Config/Port0/FirmwareRevision" $rand8
VBoxManage setextradata $VMNAME "VBoxInternal/Devices/ahci/0/Config/Port0/ModelNumber" "SEAGATE ST3750525AS"
```

This script was posted to serverfault by the user *Thomas Pfeifer* [here](https://serverfault.com/questions/727347/solidworks-activation-license-mode-is-not-supported-in-this-virtual-environment). It essentially just sets the virutalized bios to report that it has real hardware components to the guest OS, as opposed to virtual ones. Now when SolidWorks checks if it's in an unsupported VM it'll think it's in a real machine!

One thing to note: if your VM was set up using a virtualized EFI just replace `pcbios` with `efi`.
