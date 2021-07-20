---
title: drbd
description: 
published: true
date: 2021-06-09T15:18:15.494Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:18:09.555Z
---

#### Daten

Clustername = testcluster

# Installation von drbd

* [Wichtig immer LVM cache deactivation ](http://localhost:4567/lvm#drbd-und-lvm)

## Installation auf Centos 7
Bei Centos gigt es leider kein Repo mit den Packeten es muss folgendes hinzugefügt werden :

```
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum repolist enabled
sudo yum update 
sudo yum install drbd84-utils drbd84-utils-sysvinit kmod-drbd84
```

## Installation Aus den Qulldatein und RPM Packet erstellung
Installieren Sie DRBD (Distributed Replicated Block Device), um das Distributed Storage System zu konfigurieren.
Dieses Beispiel basiert auf der folgenden Umgebung.

```
+----------------------+          |          +----------------------+
| [   DRBD Server#1  ] |10.0.0.51 | 10.0.0.52| [   DRBD Server#2  ] |
|   node01.srv.world   +----------+----------+   node02.srv.world   |
|                      |                     |                      |
+----------------------+                     +----------------------+
```

Es ist notwendig,auf dem Server, auf dem Sie DRBD installieren möchten DRBD ein freies Block-Gerät hat.

Bei diesem Beispeil werde ich folgendes gerät verwenden `/dev/vg_r0/lv_r0` ersetzen Sie es entsprechend.


1. Updaten des systems und die benötigten packete Installiren auf beiden Hosts

```
yum update
yum -y install gcc make automake autoconf libxslt libxslt-devel flex rpm-build kernel-devel 
```

2.  Installation von drbd auf beiden hosts

```
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} 
wget http://oss.linbit.com/drbd/drbd-utils-latest.tar.gz \
http://oss.linbit.com/drbd/8.4/drbd-8.4.8-1.tar.gz

tar -xzvf drbd-8.4.8-1.tar.gz
cd drbd-*
make km-rpm
cd - 
tar zxvf drbd-utils-latest.tar.gz
cd drbd-utils-*
# on line 34 
echo "%bcond_without sbinsymlinks
%undefine with_sbinsymlinks" >> drbd.spec.in
./configure
make rpm
cd /root/rpmbuild/RPMS/x86_64
rpm -Uvh drbd-utils-*.rpm drbd-km-*.rpm
```

# Konfiguration von drbd version 8

1. drbdadm create-md drbd0
2. drbdadm up drbd0
3. drbd-overview oder cat /proc/drbd zum Status Prüfen
4. drbdadm -- --overwrote-dtat-of-peer primary drbd0   um dem master festzulegen
5. mkfs.xfs /dev/drbd0 um abschließend zu formatieren.

## drbd Administration

**Infos**

* Das von **drbdadm** erstelle device muss auf Master und Slave erstellt werden .
* In der Konfiguration muss auf den Parameter **on** das Resultat von `$(hostname -f)` folgen.

**Name des Clusters**
`cat /etc/corosync/corosync.conf`

**drbd device erstellen**

`drbdadm create-md drbd0 `

**Primary Master Festlegen**

`drbdadm -- --overwrite-data-of-peer primary drbd0`

**Prüfen des Zustandes**

 `cat /proc/drbd`

**Node Cluster erstellen**

`pcs cluster setup --start --name testcluster store1 store2 --transport udpu`

**Resource bearbeiten** 
z.B. wird hier einfach der mount von /var/drbd nach /mnt/drbd geändert .
*Es muss natürlich schon das Verzeichnis existieren*

`pcs resource update fs_drbd0  filesystem device=/dev/drbd0 directory=/mnt/drbd fstype=ext4`

** String für die Verschlüsselung Erstellen**
* [gen-32-alphanum-string](https://github.com/kernt/inshelp/blob/master/drbd/gen-32-alphanum-string.sh)

## Berechtigungen Matrix

Da es zu Fehlern kommt wenn die Berechtigungen nicht korrekt gesetzt werden kommt, hier alle Dateien mit ihren soll Berechtigungen. Leider kann man erst im log erkenne das man die rechte nicht gesetzt hat drbd ignoirt einfach eine Konfigutrationds datei die nicht die forgeschriebenen Rechte hat.


| Datei | Rechte | Benutzer |
| :---: | :---: | :---: |
|/etc/drbd.d/global_common.conf | 644 | root:root |


## [Split-Brain Fehler Behebung](../drbd-split-Brain)

Splitbrain Fehler sowie ein Fehler auftritt der irgendetwas in der Richtung nennt, kann man folgendes versuchen : 

**Auf dem secondary ihn nochmal als secondary festlegen:**

`drbdadm secondary drbd0`

**Primary Master Festlegen**

`drbdadm -- --overwrite-data-of-peer primary drbd0`

**Fehler zurücksetzen**
`pcs resource cleanup $resource-id`

**Fehler verschwindet nicht**
`journalctl -xn`

**Quellen:**

* https://www.hastexo.com/resources/hints-and-kinks/solve-drbd-split-brain-4-steps/