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

setenforce 0

```

**Quellen**
* [foreman-on-centos-7-or-rhel-7](https://syslint.com/blog/tutorial/how-to-install-and-configure-foreman-on-centos-7-or-rhel-7/)
* [googel paste foreman ](https://groups.google.com/forum/#!topic/foreman-users/6xFo8mzDOF0)


### Firewall für Foreman einrichten 
```

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
