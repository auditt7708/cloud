
Local https://spacewalk.example.com

Voraussetzungen
==============

* Ausgehende offene Ports 80, 443
* Eingehende offene Ports 80, 443, 5222 (nur wenn Sie Aktionen auf Clientcomputer ausführen möchten) und 5269 (nur für Push-Aktionen auf einen Spacewalk Proxy), 69 udp, wenn Sie tftp verwenden möchten
* Speicher für Datenbank: 250 KiB pro Klientensystem + 500 KiB pro Kanal + 230 KiB pro Paket im Kanal (d.h. 1.1GiB für Kanal mit 5000 Paketen)
* Speicher für Pakete (default / var / satellite): Abhängig von dem, was Sie speichern; Red Hat empfiehlt 6GB pro Kanal für ihre Kanäle 2GB RAM mindestens, 4GB empfohlen
* Stellen Sie sicher, dass Ihr zugrunde liegendes Betriebssystem vollständig auf dem neuesten Stand ist.

Installation des Servers
===================

**Auf CentOS 7**

`rpm -Uvh http://yum.spacewalkproject.org/2.6/RHEL/7/x86_64/spacewalk-repo-2.6-0.el7.noarch.rpm`

**EPEL 7 (use for Red Hat Enterprise Linux 7, Scientific Linux 7, CentOS 7) für Java**

`rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

auch wichtig aber als optional bezeichnet
```
cat > /etc/yum.repos.d/jpackage-generic.repo << EOF
[jpackage-generic]
name=JPackage generic
#baseurl=http://mirrors.dotsrc.org/pub/jpackage/5.0/generic/free/
mirrorlist=http://www.jpackage.org/mirrorlist.php?dist=generic&type=free&release=5.0
enabled=1
gpgcheck=1
gpgkey=http://www.jpackage.org/jpackage.asc
EOF
```

** Installation **
` yum -y install spacewalk-setup-postgresql`

muss meistens 2 mal versucht werden .

** Konfiguration vom Spacewalk Server**
Mit einer lokalen Datenbank .
`spacewalk-setup`

Mit einer externen Datenbank
`spacewalk-setup --external-postgresql`

Installation durchführen
`spacewalk-setup`

Nach der Installation startet spacewalk nicht automatisch
`/usr/sbin/spacewalk-service start`


Client Installation
==============

**Allgemeine Schritte für alle Distributionen**

1. Erstelle einen  base channel in Spacewalk (Channels > Manage Software Channels > Create New Channel)
2.  Erstelle einen activation key (Systems > Activation Keys > Create Key) with the new base channel. When creating a registration key do not use the generate function, create a human-readable version. eg: fedora-server-channel. This makes your installation more understandable and provides greater logical consistency to the whole system. On the other hand, if you want to prevent people from getting access to your channels, letting Spacewalk to generate random activation key name is the best way to go.


SSL Cert vom Server zum Client Kopieren
`wget --no-check-certificate https://spacewalk.example.com/pub/RHN-ORG-TRUSTED-SSL-CERT -O /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT`


Toools Übersicht

rhnreg_ks = Wird benutzt für die  registration der clients zum Spacewalk Server

**Client Installation bei Debian/Ubuntu**

Installation der client tools 
`apt-get install apt-transport-spacewalk rhnsd`



**Quellen:**
* http://spacewalk.redhat.com/documentation/master-thesis-debian-support.pdf
* https://github.com/spacewalkproject/spacewalk/wiki/RegisteringClients
* https://fedorahosted.org/spacewalk/wiki/RegisteringClients#Debian

**Client installation bei RHEL/CentOS**

Repositories  RHEL 7 / SL 7 / CentOS 7
`rpm -Uvh http://yum.spacewalkproject.org/2.6-client/RHEL/7/x86_64/spacewalk-client-repo-2.6-0.el7.noarch.rpm`
`BASEARCH=$(uname -i)`
`rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

Install Klient packete
`yum -y install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin`

Install Spacewalk's CA zertificate auf dem server um  SSL Kommunication zu ermöglichen (rpm version anpassen)
`rpm -Uvh http://YourSpacewalk.example.com/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm`

Register dein System zum Spacewalk benutze den key den du zuvor erstellst
`rhnreg_ks --serverUrl=https://YourSpacewalk.example.org/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=<key-with-rhel-custom-channel> `

Erweiterte Konfiguration vom Spacewalk Server 
=======================================

**User und Gruppen Management mit OpenLDAP**

**Quellen:**
* https://github.com/spacewalkproject/spacewalk/wiki/SpacewalkWithLDAP

**Spacewalk Hostnamen Ändern**
**Quellen:**
* https://fedorahosted.org/spacewalk/wiki/SpacewalkHostnameRename

**Sources: **
* http://spacewalk.redhat.com/
* http://jensd.be/566/linux/install-and-use-spacewalk-2-3-on-centos-7
* https://fedorahosted.org/spacewalk/wiki/HowToInstall
* https://fedorahosted.org/spacewalk/wiki/UserDocs
* http://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-install-spacewalk-on-centos-7-rhel-7.html # geht ! ref.
* https://www.unixmen.com/install-and-configure-spacewalk-in-centos-7/