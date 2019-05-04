# Services und Deamons

* [services](https://gitlab.com/tobkern1980/home-net4-environment/wikis/services)

## Cloud Container Netzwerk

* [minishift](../minishift)
* [weave](../docker-networking-weave-net-install-konfiguration)

## Packet Management

* [repositories](../repositories)

## Virtuelle Umgebung

* [virt-install](../virt-install)

## vpn Netzwerk

* [vpn-ssh](../vpn-ssh)
* [vpn-strongswan](../vpn-strongswan)

## Hosts

* [Hosts](../wikis/hosts)

```s
Netzwerk 192.168.4.0

Net Class = C

SubnetzMAske = /26 255.255.255.192

router = r1 192.168.4.1

first dns Server = 192.168.4.14
second dns Server = 192.168.4.1

IP Bereiche
0 - 63
64 - 127
128 - 195
196 - 255

HEX IP = C0 A8 04 00

Broadcast addresse = 192.168.4.63

IP Subnetz = 64
```

## vlan

| vlan ID |  netzkerk | Info |
| :--------: | :--------: | :--------: |
| 1            | 192.168.4.1       | fallback net|
| 2            | 192.168.4.2       | development |
| 3            | 192.168.4.3       | productiv |
| 4            | 192.168.4.4       | reserved |
|      5       | 192.168.4.5       | vlan transfer |
|      6       | 192.168.4.6       | reserved |
|      7       | 192.168.4.7       | reserved |
|      8       | 192.168.4.8       | reserved |