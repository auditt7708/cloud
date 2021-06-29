---
title: wireguard
description: 
published: true
date: 2021-06-09T16:11:34.805Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:11:29.774Z
---

# Wireguard

WireGuard ist VPN welches sich dann ähnlich aufbaut wie ssh

## Server Einrichten

Hier wird von folgender Konfiguration ausgegangen:

Die public IP des Server lautet: _144.123.56.78_
Im vpn wird folgendes Netz verwendet _192.168.5.0/24_
Der Server bekommt im VPN die IP _192.168.5.1_ und lauscht auf dem Port _51820_ .
Interface für die WireGuard ist _wg0_ .
Server Konfiguration in _/etc/wireguard/wg0.conf_

```txt qua fasel bla bla

[Interface]
Address = 192.168.5.1/24
ListenPort = 51820
PrivateKey = SERVER_PRIVATE_KEY

# %i ist hier das Interface. Hier mit Iptabels angelegt

# if the server is behind a router and receive traffic via NAT, this iptables rules are not needed
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Alternative für Centos Systeme

[Peer]
# client-01
PublicKey = PEER_CLIENT1_PUBLIC_KEY
PresharedKey = PRE-SHARED_KEY
AllowedIPs = 10.200.200.2/32

[Peer]

# peer2
PublicKey = PEER_BAR_PUBLIC_KEY
AllowedIPs = 10.200.200.3/32

```

Wiregard starten

```sh
sudo systemctl enable wg-quick@wg0.service
sudo systemctl daemon-reload
sudo systemctl start wg-quick@wg0
```

Wiregard Service stopen und das System Aufreumen

```sh
sudo systemctl stop wg-quick@wg0
sudo systemctl disable wg-quick@wg0.service
sudo rm -i /etc/systemd/system/wg-quick@wg0*
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

## Cleints einrichten (peers)

Konfiguration auf einem Peer.

```sh
```


