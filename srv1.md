# Netzwerkkonfiguration

| Typ | MAC | Gerätebezeichner | DNS-Name | Domäne | IPv4-Subnetz | IPv6-Subnetz | IPv4-Adresse | IPv6-Adresse |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| enp1s0 | 70:85:c2:20:31:23 | enp1s0 |  |  |  |  |  |  |
| enp3s0 | 70:85:c2:20:31:23 | enp1s0 |  |  |  |  |  |  |
| bond0 |  |  |  |  |  |  |  |  |
| docker0 | 02:42:76:b0:d9:5f | docker0 |  |  |  |  |  |  |

## Virtuelle Maschinen

| Adresse | Service |
| :---: | :---: |
| | |

## FsTab

## Verzeichnisse und Zweck

## LVM

LVS Umgebung

## Planung für DRBD

## PCS Konfiguration

**Service IP**
`pcs resource create VirtualIP ocf:heartbeat:IPaddr2 ip=192.168.4.91 cidr_netmask=24 nic=br0 op monitor interval=30s`
