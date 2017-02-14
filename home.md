 Services im homenet4

Dropbox Link : https://www.dropbox.com/sh/f7dhmkn8wh3ycrh/AAAUxW-Blx7sUDQ10DoRBJQta?dl=0 


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


Cluster Beispiele
* [Peacemaker-drbd-MySql](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Peacemaker-drbd-MySql)
* [Pacemaker-iSCSI-drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Pacemaker-iSCSI-drbd)
* [Pacemaker-NFS-drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Pacemaker-NFS-drbd)
* [Pacemaker-drbd-dual-primary](https://gitlab.com/tobkern1980/home-net4-environment/wikis/drbd-dual-primary)
* [Pacemaker-root-drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Pacemaker-root-drbd)
* [Pacemaker-kvm-iSCSI-drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Pacemaker-kvm-iSCSI-drbd)
* [Pacemaker-geo-drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Pacemaker-NFS-drbd)
* [Pacemaker-disaster-proxy-drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Pacemaker-disaster-proxy-drbd)
* [Pacemaker-gfs-nfs-drbd](https://gitlab.com/tobkern1980/home-net4-environment/wikis/Pacemaker-gfs-nfs-drbd)


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
rsshadm


### Standart Gruppen
adm-kvm
webvirtmgr
gitlab-runner
ssh-opt
libvirtd

User für ssh verbindungen ohne password rsshadm
```
sudo mkdir -p  /home/rsshadm/.ssh
sudo chmod 700 /home/rsshadm/.ssh
sudo chmod 0600 /home/rsshadm/.ssh/authorized_keys
sudo chown -R rsshadm:rsshadm /home/rsshadm/.ssh
```

sudo
====

```
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
Host_Alias   HOMENET4     = 192.168.4.0/24
Host_Alias   DESKTOP = tobkern-desktop, tobkern-desktop-win10

# User alias specification
Runas_Alias     OP = root, operator
Runas_Alias  DBA = oracle,pgsql
User_Alias    WEBMASTERS = tobkern, www-data
User_Alias   ADMINS  = tobkern
User_Alias   DEVEL   = tobkern

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
Cmnd_Alias   SYSTEM  = /sbin/reboot,/usr/bin/kill,/sbin/halt,/sbin/shutdown,/etc/init.d/
Cmnd_Alias   PW      = /usr/bin/passwd [A-z]*, !/usr/bin/passwd root # Not root pwd!
Cmnd_Alias   DEBUG   = /usr/sbin/tcpdump,/usr/bin/wireshark,/usr/bin/nmap

# User privilege specification
root    ALL=(ALL:ALL) ALL
tobkern ALL=(ALL:ALL) NOPASSWD: ALL
tkern   ALL=(ALL:ALL) ALL
%administrator  ALL = (ALL) AL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
%operator ALL = /var/log/messages*
sysadmin     DMZ     = (ALL) NOPASSWD: SYSTEM,PW,DEBUG
sysadmin     ALL,!DMZ = (ALL) NOPASSWD: ALL   # Can do anything outside the DMZ.
%dba         ALL     = (DBA) ALL              # Group dba can run as database user.

# anyone can mount/unmount a cd-rom on the desktop machines
ALL          DESKTOP = NOPASSWD: /sbin/mount /cdrom,/sbin/umount /cdrom

# See sudoers(5) for more information on "#include" directives:
#includedir /etc/sudoers.d
```

Host Gruppen
===========

srvs = srv1 srv2
rps = rp1 rp2 rp3 rp4 
desk = tobkern-desktop tobkern-desktop-win10


Debian/ Ubuntu Preseed

xenial.seed Ubuntu 16.04
```
################################################################################
### Localization                                                             ###
################################################################################
# Preseeding only locale sets language, country and locale.
#d-i debian-installer/locale string en_US
#d-i debian-installer/locale string en_GB.UTF-8
d-i debian-installer/locale string de_DE

# Sets language.
#d-i debian-installer/language string en
#d-i debian-installer/language string de

# Sets country.
#d-i debian-installer/country string US
#d-i debian-installer/country string DE

# Optionally specify additional locales to be generated.
#d-i localechooser/supported-locales en_US.UTF-8

# Continue the installation in the selected language?
#d-i localechooser/translation/warn-light boolean false
d-i localechooser/translation/warn-light boolean true
#d-i localechooser/translation/warn-severe boolean false
d-i localechooser/translation/warn-severe boolean true

################################################################################
### Keyboard                                                                 ###
################################################################################
# Disable automatic (interactive) keymap detection.
d-i console-setup/ask_detect boolean false

# Keyboard model code (for 2.6 kernels normally a "pc105" model should be
# selected).
#d-i keyboard-configuration/modelcode string pc105

# X layout name, as would be used in the XkbLayout option in /etc/X11/xorg.conf.
#d-i keyboard-configuration/layoutcode string us
#d-i keyboard-configuration/layoutcode string gb
d-i keyboard-configuration/layoutcode string de

# To select a variant of the selected layout (if you leave this out, the
# basic form of the layout will be used):
#d-i keyboard-configuration/variantcode string dvorak

################################################################################
### Network configuration                                                    ###
################################################################################
# Disable network configuration entirely.
#d-i netcfg/enable boolean false

# Netcfg will choose an interface that has link if possible.
d-i netcfg/choose_interface select auto

# Pick a particular interface instead.
#d-i netcfg/choose_interface select eth0

# If you have a slow dhcp server and the installer times out waiting for
# it, this might be useful.
#d-i netcfg/dhcp_timeout string 60

# If you prefer to configure the network manually, uncomment this line and
# the static network configuration below.
#d-i netcfg/disable_autoconfig boolean true

# If you want the preconfiguration file to work on systems both with and
# without a dhcp server, uncomment these lines and the static network
# configuration below.
#d-i netcfg/dhcp_failed note
#d-i netcfg/dhcp_options select Configure network manually

# Static network configuration.
#d-i netcfg/get_ipaddress string 192.168.10.100
#d-i netcfg/get_netmask string 255.255.255.0
#d-i netcfg/get_gateway string 192.168.10.2
#d-i netcfg/get_nameservers string 192.168.10.1
#d-i netcfg/confirm_static boolean true

# Any hostname and domain names assigned from dhcp take precedence over
# values set here. However, setting the values still prevents the questions
# from being shown, even if values come from dhcp.
d-i netcfg/get_hostname string ubuntu
d-i netcfg/get_domain string home.lan

# Disable that annoying WEP key dialog.
d-i netcfg/wireless_wep string

# The wacky dhcp hostname that some ISPs use as a password of sorts.
#d-i netcfg/dhcp_hostname string radish

# If non-free firmware is needed for the network or other hardware, you can
# configure the installer to always try to load it, without prompting. Or
# change to false to disable asking.
#d-i hw-detect/load_firmware boolean true

################################################################################
### Network console                                                          ###
################################################################################
# Use the following settings if you wish to make use of the network-console
# component for remote installation over SSH. This only makes sense if you
# intend to perform the remainder of the installation manually.
#d-i anna/choose_modules string network-console
#d-i network-console/password password NetworkConsolePassword
#d-i network-console/password-again password NetworkConsolePassword

################################################################################
### Mirror settings                                                          ###
################################################################################
# If you select ftp, the mirror/country string does not need to be set
d-i mirror/country string manual

# HTTP mirror configuration.
#d-i mirror/protocol string http
#d-i mirror/http/hostname string archive.ubuntu.com
#d-i mirror/http/hostname string mirror.home.lan
#d-i mirror/http/directory string /ubuntu
#d-i mirror/http/proxy string

# FTP mirror configuration.
d-i mirror/protocol string ftp
d-i mirror/ftp/hostname string mirror.home.lan
d-i mirror/ftp/directory string /pub/linux/ubuntu
d-i mirror/ftp/proxy string

# Alternatively: by default, the installer uses CC.archive.ubuntu.com where
# CC is the ISO-3166-2 code for the selected country. You can preseed this
# so that it does so without asking.
#d-i mirror/http/mirror select CC.archive.ubuntu.com
#d-i mirror/http/mirror select DE.archive.ubuntu.com

# Suite to install.
#d-i mirror/suite string squeeze

# Suite to use for loading installer components (optional).
#d-i mirror/udeb/suite string squeeze

# Components to use for loading installer components (optional).
#d-i mirror/udeb/components multiselect main, restricted

################################################################################
### Clock and time zone setup                                                ###
################################################################################
# Controls whether or not the hardware clock is set to UTC.
#d-i clock-setup/utc boolean false
d-i clock-setup/utc boolean true

# You may set this to any valid time zone (check /usr/share/zoneinfo/)
#d-i time/zone string US/Eastern
d-i time/zone string Europe/Berlin

# Controls whether to use NTP to set the clock during the install
#d-i clock-setup/ntp boolean false
d-i clock-setup/ntp boolean true

# NTP server to use. The default is almost always fine here.
d-i clock-setup/ntp-server ntp.home.lan

################################################################################
### Partitioning                                                             ###
################################################################################
# If the system has free space you can choose to only partition that space.
# This is only honoured if partman-auto/method (below) is not set.
# Alternatives: custom, some_device, some_device_crypto, some_device_lvm.
#d-i partman-auto/init_automatically_partition select biggest_free

# Alternatively, you may specify a disk to partition. If the system has only
# one disk the installer will default to using that, but otherwise the device
# name must be given in traditional, non-devfs format (so e.g. /dev/hda or
# /dev/sda, and not e.g. /dev/discs/disc0/disc).
d-i partman-auto/disk string /dev/sda

# In addition, you'll need to specify the method to use.
# The presently available methods are:
# - regular: use the usual partition types for your architecture
# - lvm:     use LVM to partition the disk
# - crypto:  use LVM within an encrypted partition
d-i partman-auto/method string regular

# If one of the disks that are going to be automatically partitioned
# contains an old LVM configuration, the user will normally receive a
# warning. This can be preseeded away...
d-i partman-lvm/device_remove_lvm boolean true

# The same applies to pre-existing software RAID array:
d-i partman-md/device_remove_md boolean true

# And the same goes for the confirmation to write the lvm partitions.
d-i partman-lvm/confirm boolean true

## Partitioning using LVM

# For LVM partitioning, you can select how much of the volume group to use
# for logical volumes.
#d-i partman-auto-lvm/guided_size string max
#d-i partman-auto-lvm/guided_size string 10GB
#d-i partman-auto-lvm/guided_size string 50%

# You can choose one of the three predefined partitioning recipes:
# - atomic: all files in one partition
# - home:   separate /home partition
# - multi:  separate /home, /usr, /var, and /tmp partitions
#d-i partman-auto/choose_recipe select atomic

# Or provide a recipe of your own...
# If you have a way to get a recipe file into the d-i environment, you can
# just point at it.
#d-i partman-auto/expert_recipe_file string /hd-media/recipe

# If not, you can put an entire recipe into the preconfiguration file in one
# (logical) line. This example creates a small /boot partition, suitable
# swap, and uses the rest of the space for the root partition:
#d-i partman-auto/expert_recipe string            \
#    boot-root ::                                 \
#        40 50 100 ext3                           \
#            $primary{ } $bootable{ }             \
#            method{ format } format{ }           \
#            use_filesystem{ } filesystem{ ext3 } \
#            mountpoint{ /boot }                  \
#        .                                        \
#        500 10000 1000000000 ext3                \
#            method{ format } format{ }           \
#            use_filesystem{ } filesystem{ ext3 } \
#            mountpoint{ / }                      \
#        .                                        \
#        64 512 300% linux-swap                   \
#            method{ swap } format{ }             \
#        .
d-i partman-auto/expert_recipe string            \
    boot-root ::                                 \
# swap with at least 2GB, maximum size of memory
        2048 500 100% linux-swap                 \
            $primary{ }                          \
            method{ swap } format{ }             \
        .                                        \
# / with at least 20GB, maximum 40GB, and ext4
        20480 1000 40960 ext4                    \
            $primary{ } $bootable{ }             \
            method{ format } format{ }           \
            use_filesystem{ } filesystem{ ext4 } \
            mountpoint{ / }                      \
        .                                        \
# /home with at least 20GB, maximum rest of space, and ext4
        20480 1000 1000000000 ext4               \
            method{ format } format{ }           \
            use_filesystem{ } filesystem{ ext4 } \
            mountpoint{ /home }                  \
        .

# If you just want to change the default filesystem from ext3 to something
# else, you can do that without providing a full recipe.
d-i partman/default_filesystem string ext4

# The full recipe format is documented in the file partman-auto-recipe.txt
# included in the 'debian-installer' package or available from D-I source
# repository. This also documents how to specify settings such as file
# system labels, volume group names and which physical devices to include
# in a volume group.

# This makes partman automatically partition without confirmation, provided
# that you told it what to do using one of the methods above.
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

## Partitioning using RAID

# The method should be set to "raid".
#d-i partman-auto/method string raid

# Specify the disks to be partitioned. They will all get the same layout,
# so this will only work if the disks are the same size.
#d-i partman-auto/disk string /dev/sda /dev/sdb

# Next you need to specify the physical partitions that will be used.
#d-i partman-auto/expert_recipe string  \
#    multiraid ::                       \
#        1000 5000 4000 raid            \
#            $primary{ } method{ raid } \
#        .                              \
#        64 512 300% raid               \
#            method{ raid }             \
#        .                              \
#        500 10000 1000000000 raid      \
#            method{ raid }             \
#        .

# Last you need to specify how the previously defined partitions will be
# used in the RAID setup. Remember to use the correct partition numbers
# for logical partitions. RAID levels 0, 1, 5, 6 and 10 are supported;
# devices are separated using "#".
# Parameters are:
# <raidtype> <devcount> <sparecount> <fstype> <mountpoint> \
#     <devices> <sparedevices>

#d-i partman-auto-raid/recipe string \
#    1 2 0 ext3 /                    \
#        /dev/sda1#/dev/sdb1         \
#    .                               \
#    1 2 0 swap -                    \
#        /dev/sda5#/dev/sdb5         \
#    .                               \
#    0 2 0 ext3 /home                \
#        /dev/sda6#/dev/sdb6         \
#    .

# For additional information see the file partman-auto-raid-recipe.txt
# included in the 'debian-installer' package or available from D-I source
# repository.

# This makes partman automatically partition without confirmation.
#d-i partman-md/confirm boolean true
#d-i partman-partitioning/confirm_write_new_label boolean true
#d-i partman/choose_partition select finish
#d-i partman/confirm boolean true
#d-i partman/confirm_nooverwrite boolean true

## Controlling how partitions are mounted

# The default is to mount by UUID, but you can also choose "traditional" to
# use traditional device names, or "label" to try filesystem labels before
# falling back to UUIDs.
#d-i partman/mount_style select uuid

################################################################################
### Base system installation                                                 ###
################################################################################
# Configure APT to not install recommended packages by default. Use of this
# option can result in an incomplete system and should only be used by very
# experienced users.
#d-i base-installer/install-recommends boolean false

# The kernel image (meta) package to be installed; "none" can be used if no
# kernel is to be installed.
#d-i base-installer/kernel/image string linux-generic

################################################################################
### Account setup                                                            ###
################################################################################
# Skip creation of a root account (normal user account will be able to
# use sudo). The default is false; preseed this to true if you want to set
# a root password.
d-i passwd/root-login boolean false

# Alternatively, to skip creation of a normal user account.
#d-i passwd/make-user boolean false

# Root password, either in clear text
#d-i passwd/root-password password RootPassword
#d-i passwd/root-password-again password RootPassword

# or encrypted using an MD5 hash.
#d-i passwd/root-password-crypted password [MD5 hash]
# Generate MD5-hash: printf "RootPassword" | mkpasswd -s -m md5
#d-i passwd/root-password-crypted password $1$ZGW8Hqa4$L0ENJjVIrAxTXIBmGtv5C/

# To create a normal user account.
d-i passwd/user-fullname string Georg Kainzbauer
d-i passwd/username string georg

# Normal user's password, either in clear text
d-i passwd/user-password password UserPassword
d-i passwd/user-password-again password UserPassword

# or encrypted using an MD5 hash.
#d-i passwd/user-password-crypted password [MD5 hash]
# Generate MD5-hash: printf "UserPassword" | mkpasswd -s -m md5
#d-i passwd/user-password-crypted password $1$Vzqk4pNx$CDhUQ6e1h3TL3rrDIkqw//

# Permit the created user to have an empty password. The default is false.
# Preseed this to true if the created user may have an empty password.
#d-i passwd/allow-password-empty boolean false

# Create the first user with the specified UID instead of the default.
#d-i passwd/user-uid string 1010

# The installer will warn about weak passwords. If you are sure you know
# what you're doing and want to override it, uncomment this.
d-i user-setup/allow-password-weak boolean true

# The user account will be added to some standard initial groups. To
# override that, use this.
#d-i passwd/user-default-groups string audio cdrom video

# Set to true if you want to encrypt the first user's home directory.
#d-i user-setup/encrypt-home boolean false
d-i user-setup/encrypt-home boolean true

################################################################################
### Apt setup                                                                ###
################################################################################
# You can choose to install restricted and universe software, or to install
# software from the backports repository.
#d-i apt-setup/restricted boolean true
#d-i apt-setup/universe boolean true
#d-i apt-setup/backports boolean true

# Uncomment this if you don't want to use a network mirror.
#d-i apt-setup/use_mirror boolean false

# Select which update services to use; define the mirrors to be used.
# Values shown below are the normal defaults.
#d-i apt-setup/services-select multiselect security
#d-i apt-setup/security_host string security.ubuntu.com
d-i apt-setup/security_host string mirror.home.lan
d-i apt-setup/security_path string /ubuntu

# Additional repositories, local[0-9] available
#d-i apt-setup/local0/repository string http://local.server/ubuntu squeeze main
#d-i apt-setup/local0/comment string local server

# Enable deb-src lines
#d-i apt-setup/local0/source boolean true

# URL to the public key of the local repository; you must provide a key or
# apt will complain about the unauthenticated repository and so the
# sources.list line will be left commented out
#d-i apt-setup/local0/key string http://local.server/key

# By default the installer requires that repositories be authenticated
# using a known gpg key. This setting can be used to disable that
# authentication. Warning: Insecure, not recommended.
#d-i debian-installer/allow_unauthenticated boolean true

################################################################################
### Package selection                                                        ###
################################################################################
# Selected packages.
tasksel tasksel/first multiselect ubuntu-desktop
#tasksel tasksel/first multiselect lamp-server, print-server
#tasksel tasksel/first multiselect kubuntu-desktop

# Individual additional packages to install
#d-i pkgsel/include string openssh-server build-essential
d-i pkgsel/include string      \
    openssh-server             \
    gnome-panel                \
    gnome-session-fallback     \
    firefox-locale-de          \
    thunderbird-locale-de      \
    libreoffice-l10n-de        \
    libreoffice-help-de        \
    flashplugin-installer      \
    gstreamer0.10-fluendo-mp3  \
    gstreamer0.10-plugins-bad  \
    gstreamer0.10-plugins-ugly \
    openjdk-6-jre              \
    nmap                       \
    wireshark                  \
    tshark                     \
    iptraf

# Whether to upgrade packages after debootstrap.
# Allowed values: none, safe-upgrade, full-upgrade
d-i pkgsel/upgrade select none

# Language pack selection
#d-i pkgsel/language-packs multiselect de, en

# Policy for applying updates. May be "none" (no automatic updates),
# "unattended-upgrades" (install security updates automatically), or
# "landscape" (manage system with Landscape).
d-i pkgsel/update-policy select none

# Some versions of the installer can report back on what software you have
# installed, and what software you use. The default is not to report back,
# but sending reports helps the project determine what software is most
# popular and include it on CDs.
#popularity-contest popularity-contest/participate boolean false

# By default, the system's locate database will be updated after the
# installer has finished installing most packages. This may take a while, so
# if you don't want it, you can set this to "false" to turn it off.
#d-i pkgsel/updatedb boolean true

################################################################################
### Boot loader installation                                                 ###
################################################################################
# Grub is the default boot loader (for x86). If you want lilo installed
# instead, uncomment this:
#d-i grub-installer/skip boolean true

# To also skip installing lilo, and install no bootloader, uncomment this too:
#d-i lilo-installer/skip boolean true

# With a few exceptions for unusual partitioning setups, GRUB 2 is now the
# default. If you need GRUB Legacy for some particular reason, then
# uncomment this:
#d-i grub-installer/grub2_instead_of_grub_legacy boolean false

# This is fairly safe to set, it makes grub install automatically to the MBR
# if no other operating system is detected on the machine.
d-i grub-installer/only_debian boolean true

# This one makes grub-installer install to the MBR if it also finds some other
# OS, which is less safe as it might not be able to boot that other OS.
d-i grub-installer/with_other_os boolean true

# Alternatively, if you want to install to a location other than the mbr,
# uncomment and edit these lines:
#d-i grub-installer/only_debian boolean false
#d-i grub-installer/with_other_os boolean false
#d-i grub-installer/bootdev  string (hd0,0)

# To install grub to multiple disks:
#d-i grub-installer/bootdev  string (hd0,0) (hd1,0) (hd2,0)

# Optional password for grub, either in clear text
#d-i grub-installer/password password GrubPassword
#d-i grub-installer/password-again password GrubPassword

# or encrypted using an MD5 hash, see grub-md5-crypt(8).
#d-i grub-installer/password-crypted password [MD5 hash]
# Generate MD5-hash: printf "GrubPassword" | mkpasswd -s -m md5
#d-i grub-installer/password-crypted password $1$/tfwIz0W$u/ftIcInWit60Y2b.5Ifw/

# Use the following option to add additional boot parameters for the
# installed system (if supported by the bootloader installer).
# Note: options passed to the installer will be added automatically.
#d-i debian-installer/add-kernel-opts string nousb

################################################################################
### Finishing up the installation                                            ###
################################################################################
# During installations from serial console, the regular virtual consoles
# (VT1-VT6) are normally disabled in /etc/inittab. Uncomment the next
# line to prevent this.
#d-i finish-install/keep-consoles boolean true

# Avoid that last message about the install being complete.
d-i finish-install/reboot_in_progress note

# This will prevent the installer from ejecting the CD during the reboot,
# which is useful in some situations.
#d-i cdrom-detect/eject boolean false

# This is how to make the installer shutdown when finished, but not
# reboot into the installed system.
#d-i debian-installer/exit/halt boolean true

# This will power off the machine instead of just halting it.
#d-i debian-installer/exit/poweroff boolean true

################################################################################
### X configuration                                                          ###
################################################################################
# X can detect the right driver for some cards, but if you're preseeding,
# you override whatever it chooses. Still, vesa will work most places.
#xserver-xorg xserver-xorg/config/device/driver select vesa

# A caveat with mouse autodetection is that if it fails, X will retry it
# over and over. So if it's preseeded to be done, there is a possibility of
# an infinite loop if the mouse is not autodetected.
#xserver-xorg xserver-xorg/autodetect_mouse boolean true

# Monitor autodetection is recommended.
xserver-xorg xserver-xorg/autodetect_monitor boolean true

# Uncomment if you have an LCD display.
#xserver-xorg xserver-xorg/config/monitor/lcd boolean true

# X has three configuration paths for the monitor. Here's how to preseed
# the "medium" path, which is always available. The "simple" path may not
# be available, and the "advanced" path asks too many questions.
xserver-xorg xserver-xorg/config/monitor/selection-method select medium
xserver-xorg xserver-xorg/config/monitor/mode-list select 1024x768 @ 60 Hz

################################################################################
### Preseeding other packages                                                ###
################################################################################
# Depending on what software you choose to install, or if things go wrong
# during the installation process, it's possible that other questions may
# be asked. You can preseed those too, of course. To get a list of every
# possible question that could be asked during an install, do an
# installation, and then run these commands:
#debconf-get-selections --installer > file
#debconf-get-selections >> file

################################################################################
### Advanced options                                                         ###
################################################################################

################################################################################
### Running custom commands during the installation                          ###
################################################################################
# d-i preseeding is inherently not secure. Nothing in the installer checks
# for attempts at buffer overflows or other exploits of the values of a
# preconfiguration file like this one. Only use preconfiguration files from
# trusted locations! To drive that home, and because it's generally useful,
# here's a way to run any shell command you'd like inside the installer,
# automatically.

# This first command is run as early as possible, just after
# preseeding is read.
#d-i preseed/early_command string anna-install some-udeb

# This command is run immediately before the partitioner starts. It may be
# useful to apply dynamic partitioner preseeding that depends on the state
# of the disks (which may not be visible when preseed/early_command runs).
#d-i partman/early_command \
#    string debconf-set partman-auto/disk "$(list-devices disk | head -n1)"

# This command is run just before the install finishes, but when there is
# still a usable /target directory. You can chroot to /target and use it
# directly, or use the apt-install and in-target commands to easily install
# packages and run commands in the target system.
#d-i preseed/late_command string apt-install zsh; in-target chsh -s /bin/zsh
d-i preseed/late_command string \
    in-target sed -i 's/http:\/\/mirror/ftp:\/\/mirror/g' /etc/apt/sources.list
```

SSH Key

```
d-i preseed/late_command string mkdir -p /target/root/.ssh
d-i preseed/late_command string cp /cdrom/id_rsa.pub /target/root/.ssh/authorized_keys
d-i preseed/late_command string chmod -R go-rwx /target/root/.ssh
```

Sources :

 *  http://www.gtkdb.de/index_34_2792.html
