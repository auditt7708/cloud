 Services im homenet4

* [icinga2](https://gitlab.com/tobkern1980/home-net4-environment/wikis/icinga2)
* [Drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/drbd )
* [Pacemaker](https://gitlab.com/tobkern1980/home-net4-environment/wikis/pacemaker)
* [Jenkins](https://gitlab.com/tobkern1980/home-net4-environment/wikis/jenkins)
* [elk-stack](https://gitlab.com/tobkern1980/home-net4-environment/wikis/elk-stack)

Hosts
* [srv1](https://gitlab.com/tobkern1980/home-net4-environment/wikis/srv1)
* [srv2](https://gitlab.com/tobkern1980/home-net4-environment/wikis/srv2)
* [rp1](https://gitlab.com/tobkern1980/home-net4-environment/wikis/rp1)
* [rp2](https://gitlab.com/tobkern1980/home-net4-environment/wikis/rp2)
* [rp3](https://gitlab.com/tobkern1980/home-net4-environment/wikis/rp3)
* [rp4](https://gitlab.com/tobkern1980/home-net4-environment/wikis/rp4)
* [tobkern-desktop](tobkern-desktop)
* [tobkern-desktop-win10](tobkern-desktop-win10)

Hilfen und tools
* [SSH](https://gitlab.com/tobkern1980/home-net4-environment/wikis/arbeiten-mit-ssh)
* [gitlab](https://gitlab.com/tobkern1980/home-net4-environment/wikis/arbeiten-mit-gitlab)


Packete auf allen Systemen

| OS | Packet |
| :--------: | :--------: |
| beide   | vim     |
| beide   | mc      |
| beide   | tree   |
| beide   | tmux   |
| beide   | wget   |
| cell 3   | cell 4   |
| cell 1   | cell 2   |
| cell 3   | cell 4   |
| cell 1   | cell 2   |
| cell 3   | cell 4   |



Packete für Centos 7, drbd  und nfs

Wichtig für drbd http://elrepo.org/tiki/tiki-index.php 

| Service | Packet |
| :--------: | :--------: |
| beide   | vim     |
| beide   | mc      |
| beide   | tree   |
| beide   | tmux   |
| beide   | cell 2   |

Packete für Centos 7, drbd , nfs und glusterfs server


| Service | Packet |
| :--------: | :--------: |
| beide   | vim     |
| beide   | mc      |
| beide   | tree   |
| beide   | tmux   |
| beide   | cell 2   |

Repositories
==========

Centos7 
ceph.repo

```
[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-jewel/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
```

CentOS-Gluster-3.8.repo
```
[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-jewel/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[root@store1 yum.repos.d]# cat CentOS-Gluster-3.8.repo
# CentOS-Gluster-3.8.repo
#
# Please see http://wiki.centos.org/SpecialInterestGroup/Storage for more
# information

[centos-gluster38]
name=CentOS-$releasever - Gluster 3.8
baseurl=http://mirror.centos.org/centos/$releasever/storage/$basearch/gluster-3.8/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage

[centos-gluster38-test]
name=CentOS-$releasever - Gluster 3.8 Testing
baseurl=http://buildlogs.centos.org/centos/$releasever/storage/$basearch/gluster-3.8/
gpgcheck=0
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Storage

```

crmsh.repo
```
[network_ha-clustering_Stable]
name=Stable High Availability/Clustering packages (CentOS_CentOS-7)
type=rpm-md
baseurl=http://download.opensuse.org/repositories/network:/ha-clustering:/Stable/CentOS_CentOS-7/
gpgcheck=1
gpgkey=http://download.opensuse.org/repositories/network:/ha-clustering:/Stable/CentOS_CentOS-7//repodata/repomd.xml.key
enabled=1

```

epel.repo
```
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch/debug
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
#baseurl=http://download.fedoraproject.org/pub/epel/7/SRPMS
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

```

User und Gruppen
===============

### Standart User
adm-kvm
docker
adm-libvirt
sshmgr
ansible


### Standart Gruppen
adm-kvm
webvirtmgr
gitlab-runner
ssh-opt
libvirtd


sudo
====

'''
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#Defaults       timestamp_timeout = 0   # Immer PW eingeben
Defaults        timestamp_timeout = 540 # PW nach 9 Studen wieder eingeben
Defaults        pwfeedback              # fuer jedes eingegebene Zeichen ein Stern (*) ausgegeben
#Defaults askpass = /PFAD/ZUM/EXTERNEN/PROGRAMM
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Host alias specification


# User alias specification
Runas_Alias     OP = root, operator
User_Alias     WEBMASTERS = tobkern, www-data

# Cmnd alias specification
Cmnd_Alias      KILL = /bin/kill
Cmnd_Alias      PRINTING = /usr/sbin/lpc, /usr/bin/lprm
Cmnd_Alias      SHUTDOWN = /usr/sbin/shutdown
Cmnd_Alias      HALT = /usr/sbin/halt
Cmnd_Alias      REBOOT = /usr/sbin/reboot
Cmnd_Alias      SHELLS = /sbin/sh, /usr/bin/sh, /usr/bin/csh, /usr/bin/ksh, \
                         /usr/local/bin/tcsh, /usr/bin/rsh, \
                         /usr/local/bin/zsh
Cmnd_Alias      VIPW = /usr/sbin/vipw, /usr/bin/passwd, /usr/bin/chsh, \
                       /usr/bin/chfn
Cmnd_Alias      PAGERS = /usr/bin/more, /usr/bin/pg, /usr/bin/less

# User privilege specification
root    ALL=(ALL:ALL) ALL
tobkern ALL=(ALL:ALL) NOPASSWD: ALL
tkern   ALL=(ALL:ALL) ALL
%administrator  ALL = (ALL) AL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
%operator ALL = /var/log/messages*

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d

'''

Host Gruppen
===========

srvs = srv1 srv2
rps = rp1 rp2 rp3 rp4 
desk = tobkern-desktop tobkern-desktop-win10
