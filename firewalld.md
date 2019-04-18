# Administration 

default Zone ausgeben

`firewall-cmd --get-active-zones`

Services einer Zone ausgeben:

`firewall-cmd --zone=public --list-all`

TCP Port freigeben

`firewall-cmd --permanent --zone=public --add-port=80/tcp`

UDP Port freigeben

`firewall-cmd --permanent --zone=public --add-port=123/udp`

Aktuelle Konfiguration schreiben

`firewall-cmd --runtime-to-permanent`