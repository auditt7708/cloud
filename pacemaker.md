Installation und Konfiguration
========================

Pacemaker wird mit und seinen Abhängigkeiten installiert 

```
yum install -y corosync pacemaker pcs resource-agents pacemaker cman pcs
```

Alle Services Aktivieren 

```
systemctl enable corosync.service
systemctl enable pacemaker.service
systemctl enable pcsd.service
```

Cluster Resource anlegen
====================

Stopping Cluster Services
====================

`pcs cluster stop [--all] [node] [...]`
Mit `--all` wird auf allen nodes 

``
``
``


pcs Tool
=======

Version mit der getestet wurde .

*  0.9.152 ``` echo $()```

Namen der deamons
* corosync
* pacemaker
* pcsd

Zugang und Zugangsdaten auf die Nodes 
===============================
Username : hacluster

hacluster ist ein normaler localer user password kann also mit 
`passwd hacluster`
geändert werden 

Zugang  für einen neuen node anlegen :
` pcs cluster auth testnode1 ` 
User ist dann der hacluster 

peacemaker
==========
Version mit der getestet wurde .

*   1.1.15-11.el7_3.2 ``` $()```

Allemeine Informationen zum Management
==================================

Unter `https://$NODE.example.com:2224`  kann die man die  jeweilige node via web Interface erreichen. 

Firewall Einrichtung
================

Die Ports müssen auf allen nodes freigegeben sein : 

```
firewall-cmd --zone=trusted --add-source=10.0.0.0/24 --permanent
firewall-cmd --reload
```

Hier muss das Netzwerk `10.0.0.0/24`  entsprechend angepasst werden

Szenarios 
========

Einen Neuen Node Hinzufügen

1.  Installation und Konfiguration
2.  hacluster Password einrichten 
3. Firewall Einrichtung 
4. Alle Services Aktivieren 
5. `pcs cluster setup --start --name testcluster $NEWNODE --transport udpu` auf dem Aktiven Node durchführen
6. 

Neuen Cluster einrichten

1. Installation und Konfiguration
2. hacluster Password einrichten 
3. Firewall Einrichtung
4. Alle Services Aktivieren


pacemaker Programmierung



Quellen
=======
* https://www.21x9.org/centos7-two-node-cluster-corosyncpacemakerdrbd/
* http://www.learnitguide.net/2016/07/how-to-install-and-configure-drbd-on-linux.html
* http://clusterlabs.org/doc/en-US/Pacemaker/1.1/html/Clusters_from_Scratch/ch07.html
* http://crmsh.github.io/man-3/
* http://www.unixarena.com/2016/01/rhel7-configuring-gfs2-on-pacemakercorosync-cluster.html
* http://www.unixarena.com/2016/08/configuring-nfs-ha-using-redhat-cluster-pacemaker-rhel-7.html
* http://www.unixarena.com/2016/01/rhel-7-configure-fencing-pacemaker.html