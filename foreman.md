Installation
=======

**Allgemeine Informationen**

Für Ubuntu/Debian werden nicht alle fitures unterstützt.

### Installation unter Centos 7

Install epel release
```
yum install epel-release
```

Install Software collection
```
yum install centos-release-scl
```

Base Install script 
```
#/bin/bash

echo "Install epel Repo"
su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm'

echo "Install Software collection"

yum install centos-release-scl
```


**Quellen:**


Plugins Einrichten
===========


Erweiterte einstellungen
===============

### libvirt Einrichten
Um sich mit dem Node Sicher zu verbinden müssen folgende schritte vorgenommen werden.

1. Rechte Überprüfen 
```
root# mkdir /usr/share/foreman/.ssh
root# chmod 700 /usr/share/foreman/.ssh
root# chown foreman:foreman /usr/share/foreman/.ssh
```
2. Auf dem foreman Server den foreman user eine ssh verbindung einrichten.
```
root# su foreman -s /bin/bash
foreman$ ssh-keygen
foreman$ ssh-copy-id root@hostname.com
foreman$ ssh root@hostname.com
exit
```
3.  In der Weboberfläche die Resoource einrichten 

### Docker einrichten

**Quellen:**
