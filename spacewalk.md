
Local https://spacewalk.example.com

Installation
=========

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

** Konfiguration **
Mit einer lokalen Datenbank .
`spacewalk-setup`

Mit einer externen Datenbank
`spacewalk-setup --external-postgresql`

Installation durchführen
`spacewalk-setup`

Nach der Installation startet spacewalk nicht automatisch
`/usr/sbin/spacewalk-service start`

**Sources: **
* http://spacewalk.redhat.com/
* http://jensd.be/566/linux/install-and-use-spacewalk-2-3-on-centos-7
* https://fedorahosted.org/spacewalk/wiki/HowToInstall
* https://fedorahosted.org/spacewalk/wiki/UserDocs
* http://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-install-spacewalk-on-centos-7-rhel-7.html # geht ! ref.
* https://www.unixmen.com/install-and-configure-spacewalk-in-centos-7/