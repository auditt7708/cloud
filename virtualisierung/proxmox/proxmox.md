---
title: proxmox
description: 
published: true
date: 2021-06-09T16:12:53.029Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:12:48.057Z
---

# Proxmox

Proxmox VE (Proxmox Virtual Environment; kurz PVE) ist eine auf Debian basierende Open-Source-Virtualisierungsplattform zum Betrieb von virtuellen Maschinen mit einer Web-Oberfläche zur Einrichtung und Steuerung von x86-Virtualisierungen. Die Umgebung basiert auf QEMU mit der Kernel-based Virtual Machine (KVM). PVE bietet neben dem Betrieb von klassischen virtuellen Maschinen (Gastsystemen), die auch den Einsatz von Virtual Appliances erlauben, auch LinuX Containers (LXC) an.

## Proxmox Administration

No Subscription Warnmeldung entfernen

```sh
sed -i.bak 's/NotFound/Active/g' /usr/share/perl5/PVE/API2/Subscription.pm && systemctl restart pveproxy.service
```

Versionen ausgeben

`pveversion -v`

## Quellen

* [Proxmox Installation](/proxmox/proxmox-installation)
* [Proxmox API](/proxmox/proxmox-api)
* [Proxmox Open vSwitsh](/proxmox/proxmox-openvswitch)
* [Proxmox und Wireguard VPN](proxmox/proxmox-wireguard)