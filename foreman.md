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

### Base Install script 
```
#/bin/bash

echo "Install epel Repo"
su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm'

echo "Install foreman Repo"
http://yum.theforeman.org/releases/1.14/el7/x86_64/foreman-release.rpm

echo "Install Software collection"
yum install centos-release-scl

echo "$(hostname -I) $(hostname -f)" > /etc/hosts

echo "Install foreman"
yum -y install foreman-installer

echo "Puppet NTP Module"
puppet module install -i /etc/puppet/environments/production/modules saz/ntp

echo "Configore foreman"
foreman-rake db:migrate
foreman-rake db:seed

echo "deactivate selinux !!!!"
# sollte noch eine Seite für selinux ins wiki kommen mit einem Eintrag für die selinux policy
# Qulle: https://github.com/theforeman/foreman-selinux
setenforce 0

```
Quellen zur Installation
* [how-to-install-foreman-with-puppet-in-centos-and-ubuntu](https://www.unixmen.com/how-to-install-foreman-with-puppet-in-centos-and-ubuntu/)

### Provision KVM VM ohne  DHCP

Hier mit Centos in version 7 
```
```

### Netzwerk Konfiguration

Der foreman-installer wird sich (weil da Python die Konformität Prüft) ohne eine RFC konforme [FQDN](https://de.wikipedia.org/wiki/Fully-Qualified_Host_Name) sich weigern eine Installation durchzuführen, daher muss noch ein passender Eintrag local in der /etc/hosts eingerichtet werden.

**Quellen**
* [foreman-on-centos-7-or-rhel-7](https://syslint.com/blog/tutorial/how-to-install-and-configure-foreman-on-centos-7-or-rhel-7/)
* [googel paste foreman ](https://groups.google.com/forum/#!topic/foreman-users/6xFo8mzDOF0)

### Firewall für Foreman einrichten 
```
# source : https://www.unixmen.com/how-to-install-foreman-with-puppet-in-centos-and-ubuntu/
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --permanent --add-port=67-69/udp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=3000/tcp
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --permanent --add-port=5910-5930/tcp
firewall-cmd --permanent --add-port=5432/tcp
firewall-cmd --permanent --add-port=8140/tcp
firewall-cmd --permanent --add-port=8443/tcp

#Restart Firewall to take effect the changes.

firewall-cmd --reload

```

### Fehler 

`The environment must be purely alphanumeric, not ''`
Lösung:
[6091-the-environment-must-be-purely-alphanumeric](https://ask.puppet.com/question/6091/the-environment-must-be-purely-alphanumeric/)


### Puppet Module für Foreman
* [theforeman/foreman](https://forge.puppet.com/theforeman/foreman)
* []()

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

### Foreman Konfigurationen

* [homent4](../foreman-examples)


### Foreman CI Quellen

* [Jenkins ci.theforeman.org](http://ci.theforeman.org/)
* []()


**Quellen:**
[foreman-host-builder](https://github.com/xnaveira/foreman-host-builder)
[]()