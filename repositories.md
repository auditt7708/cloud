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
