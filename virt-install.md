Debian 7
```
virt-install \
--name debian7 \
--ram 1024 \
--disk path=./debian7.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant debian7 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://ftp.nl.debian.org/debian/dists/jessie/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

Debian 8
```
virt-install \
--name debian8 \
--ram 1024 \
--disk path=./debian8.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://ftp.nl.debian.org/debian/dists/jessie/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

CentOS 7

```
virt-install \
--name centos7 \
--ram 1024 \
--disk path=./centos7.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant centos7 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://mirror.i3d.net/pub/centos/7/os/x86_64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

Ubuntu 14.04
```
virt-install \
--name ubuntu1404 \
--ram 1024 \
--disk path=./ubuntu1404.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

OpenSUSE 13
```
virt-install \
--name opensuse13 \
--ram 1024 \
--disk path=./opensuse13.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant generic \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://download.opensuse.org/distribution/13.2/repo/oss/' \
--extra-args 'console=ttyS0,115200n8 serial'
```


Generic ISO

Download an ISO file and give the filename to the --cdrom= parameter. This is used instead of --location. A VNC console is available on localhost, port 5999 for you to use.

An example for FreeBSD 10. First download the ISO:

```
wget http://ftp.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/10.1/FreeBSD-10.1-RELEASE-amd64-dvd1.iso
```

Then start virt-install:

```
 virt-install \
--name freebsd10 \
--ram 1024 \
--disk path=./freebsd10.qcow2,size=8 \
--vcpus 1 \
--os-type generic \
--os-variant generic \
--network bridge=virbr0 \
--graphics vnc,port=5999 \
--console pty,target_type=serial \
--cdrom ./FreeBSD-10.1-RELEASE-amd64-dvd1.iso \
```

os-variant

For install use the folloing
```
sudo apt install libosinfo-bin
```

You can get a list of supported operating system variants with the osinfo-query os command. Below you'll find an example output:

```
osinfo-query os
 Short ID             | Name                                               | Version  | ID                                      
----------------------+----------------------------------------------------+----------+-----------------------------------------
 debian7              | Debian Wheezy                                      | 7        | http://debian.org/debian/7              
 freebsd10.0          | FreeBSD 10.0                                       | 10.0     | http://freebsd.org/freebsd/10.0         
 openbsd5.5           | OpenBSD 5.5                                        | 5.5      | http://openbsd.org/openbsd/5.5          
 rhel6.5              | Red Hat Enterprise Linux 6.5                       | 6.5      | http://redhat.com/rhel/6.5              
 rhel7.0              | Red Hat Enterprise Linux 7.0                       | 7.0      | http://redhat.com/rhel/7.0              
 ubuntu12.04          | Ubuntu Precise Pangolin LTS                        | 12.04    | http://ubuntu.com/ubuntu/12.04          
 win3.1               | Microsoft Windows 3.1                              | 3.1      | http://microsoft.com/win/3.1            
 win7                 | Microsoft Windows 7                                | 6.1      | http://microsoft.com/win/7              
 winxp                | Microsoft Windows XP                               | 5.1      | http://microsoft.com/win/xp  
```


Sources:
 * virt-install