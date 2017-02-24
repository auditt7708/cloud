Installation
=======

**Allgemeine Informationen**

Für Ubuntu/Debian werden nicht alle fitures unterstützt.

**Installation unter Centos 7**


**Quellen:**


Plugins  und Tools 
===========

* [foreman_ansible_inventory](https://github.com/theforeman/foreman_ansible_inventory)
* [ISO and USB boot disk support for Foreman ](https://github.com/theforeman/foreman_bootdisk)
* [Forklift provides tools to create Foreman/Katello environments for development, testing and production configurations](https://github.com/theforeman/forklift)
* [provisioning_templates](https://github.com/theforeman/community-templates/tree/develop/provisioning_templates)
* [SmartProxyDnsPowerdns](https://github.com/theforeman/smart_proxy_dns_powerdns)

Erweiterte Einstellungen
===============

**libvirt**
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

**Quellen:**

* https://www.theforeman.org/manuals/1.13/index.html#5.2.5LibvirtNotes


**docker**


**Quellen:**

* https://www.theforeman.org/manuals/1.14/index.html
