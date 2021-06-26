---
title: bind9
description: 
published: true
date: 2021-06-09T14:58:37.433Z
tags: 
editor: markdown
dateCreated: 2021-06-09T14:58:32.158Z
---

# Bind9

/etc/bind/db.example.com

```sh
;; DB.domainname
;; Forwardlookupzone für domainname
;;
$TTL 604800
@ mIN    SOA    rp4.example.com. root.example.com. (
            94
            8H
            2H
            4W
            3H )

@                              IN      NS      rp4.example.com.
                               IN      MX      10 rp4.example.com.
                               IN      A       192.168.4.14

r1                IN    A       192.168.4.1
lp.example.com.            IN    A    192.168.4.10

rp1                           IN    A       192.168.4.11
rp2                           IN     A       192.168.4.12
rp3                           IN     A       192.168.4.13
rp4                IN    A    192.168.4.14

tobkern-desktop.example.com.         IN      A      192.168.4.21
tobkern-desktop-win10.example.com       IN      A       192.168.4.20

ns                 IN     CNAME      rp4
imap                 IN     CNAME      rp4
pop3                            IN      CNAME   rp4
ldapmaster                      IN      CNAME   rp4
dhcp                            IN      CNAME   rp4
dns                             IN      CNAME   rp4
ILOCZ1539004J                   IN      CNAME   ilo4
smb                             IN      CNAME   share1
nfs                             IN      CNAME   share1
www                             IN      CNAME   srv1
apache2                         IN      CNAME   rp4
home                            IN      CNAME   rp4
dokuwiki                        IN      CNAME   srv1
kvm                             IN      CNAME   srv1
administration                  IN      CNAME   rp4
nas                             IN      CNAME   share1
san                             IN      CNAME   share1
ntp                             IN      CNAME   r1
krb5                            IN      CNAME   rp4
bind                            IN      CNAME   rp4
wiki                            IN      CNAME   srv1
dev                             IN      CNAME   srv1
ldap                            IN      CNAME   rp4
puppet                IN    CNAME    srv2
printer                         IN      CNAME   lp
printer1                        IN      CNAME   lp
lp1                             IN      CNAME   lp
kodi                            IN      CNAME   rp3
mysql                           IN      CNAME   srv1
pgsql                           IN      CNAME   srv1
elk                             IN      CNAME   srv2
git                             IN      CNAME   srv2
dashboard                       IN      CNAME   srv2
logstash                        IN      CNAME   srv1
ci                              IN      CNAME   srv1
test                            IN      CNAME   srv1
node1                           IN      CNAME   srv1
node2                           IN      CNAME   srv1
node3                           IN      CNAME   srv1
node4                           IN      CNAME   srv1
node5                           IN      CNAME   srv1
backup                          IN      CNAME   srv1
bacula                IN    CNAME    srv1
es1                             IN      CNAME   srv1
es2                             IN      CNAME   srv1
ftp                             IN      CNAME   srv2
sftp                            IN      CNAME   srv1
http                            IN      CNAME   srv1
node                            IN      CNAME   srv1
homenet                         IN      CNAME   srv1
kibana                          IN      CNAME   srv1
mailserver            IN    CNAME    rp4
mail                IN    CNAME    rp4


_kerberos._tcp                     IN    SRV    0    0        88       ipa
_kerberos._udp                         IN    SRV     10   0     88     ipa
_kerberos-master._tcp                  IN    SRV     0    0     88     ipa
_kerberos-master._udp                  IN    SRV     0    0     88     ipa
_kerberos-adm._tcp                    IN    SRV    0    0    749      ipa
_kpasswd._udp                   IN    SRV    0    0    464      ipa

_kerberos._tcp                          IN      SRV     40    0     88     rp4
_kerberos._udp                          IN      SRV     40    0     88     rp4
_kerberos-master._tcp                   IN      SRV     40    0     88     rp4
_kerberos-master._udp                   IN      SRV     40    0     88     rp4
_kerberos-adm._tcp                      IN      SRV     40    0    749     rp4
_kpasswd._udp                           IN      SRV     40    0    464     rp4

_domain._tcp.example.com.        IN    SRV    0    0     53      rp4.example.com.
_domain._udp.example.com.        IN    SRV    0    0     53      rp4.example.com.

_domain._tcp.example.com.               IN      SRV     10    0     53     r1.example.com.
_domain._udp.example.com.               IN      SRV     10    0     53     r1.example.com.

_tftp._tcp.example.com.            IN    SRV    10   0     69      share1.example.com.
_tftp._udp.example.com.            IN    SRV    10   0       69      share1.example.com.
_tftp._tcp.example.com.                 IN      SRV     20   0     69     srv1.example.com.
_tftp._udp.example.com.                 IN      SRV     20   0     69     srv1.example.com.
_tftp._tcp.example.com.                 IN      SRV     30   0     69     rp2.example.com.
_tftp._udp.example.com.                 IN      SRV     30   0     69     rp2.example.com.

_ldap._tcp.example.com.                 IN      SRV     10   0    389     rp4.example.com.
_ldaps._tcp.example.com.                IN      SRV     10   0    636     rp4.example.com.
_ldap._udp.example.com.                 IN      SRV     20   0    389     rp4.example.com.
_ldaps._udp.example.com.                IN      SRV     20   0    636     rp4.example.com.

_ipp._tcp.example.com.                  IN      SRV      0   0    631     lp.example.com.
_ipp._udp.example.com.                  IN      SRV      0   0    631     lp.example.com.

_iscsi._tcp.example.com.                IN      SRV      0   0    860     share1.example.com.
_iscsi._udp.example.com.                IN      SRV      0   0    860     share1.example.com.

_rsync._tcp.example.com.                IN      SRV      0   0    873     share1.example.com.
_rsync._udp.example.com.                IN      SRV      0   0    873     share1.example.com.
_tacacs._udp.example.com                IN      SRV      0   0    49      rp4.example.com.

_www._tcp.example.com                IN      SRV      1    0    49      rp4.example.com.
_www._udp.example.com                IN      SRV      1    0    49      rp4.example.com.
_www._tcp.example.com                IN      SRV      10   0    49      srv2.example.com.
_www._udp.example.com                IN      SRV      10   0    49      srv2.example.com.
_www._tcp.example.com                IN      SRV      30   0    49      tobkern-desktop.example.com.
_www._udp.example.com                IN      SRV      30   0    49      tobkern-desktop.example.com.


_nfs._tcp.example.com.                  IN      SRV      0   0    2049     share1.example.com.
_nfs._udp.example.com.                  IN      SRV      0   0    2049     share1.example.com.

_docker._tcp.example.com.        IN      SRV        10    0   2375     tobkern-desktop.example.com.
_nfs._tcp.example.com.                  IN      SRV         10    0   2375     tobkern-desktop.example.com.

_dockers._tcp.example.com.              IN      SRV      0    0   2376     srv2.example.com.
_dockers._tcp.example.com.              IN      SRV      0    0   2376     tobkern-desktop.example.com.

_swarm._tcp.example.com.                  IN      SRV      0    0   2377     srv2.example.com.
_swarm._udp.example.com.                  IN      SRV      0    0   2377     srv2.example.com.

_swarm._tcp.example.com.                  IN      SRV      10    0   2377     tobkern-desktop.example.com.
_swarm._udp.example.com.                  IN      SRV      10    0   2377     tobkern-desktop.example.com.

_mysql._tcp.example.com.                  IN      SRV      0    0   3306     srv2.example.com.
_mysql._udp.example.com.                  IN      SRV      0    0   3306     srv2.example.com.

_mysql._tcp.example.com.                  IN      SRV      10    0   3306     tobkern-desktop.example.com.
_mysql._udp.example.com.                  IN      SRV      10    0   3306     tobkern-desktop.example.com.

_mysql._tcp.example.com.                  IN      SRV      20    0   3306     rp4.example.com.
_mysql._udp.example.com.                  IN      SRV      20    0   3306     rp4.example.com.

_mysql._tcp.example.com.                  IN      SRV      30    0   3306     srv1.example.com.
_mysql._udp.example.com.                  IN      SRV      30    0   3306     srv1.example.com.

srv1.example.com.                        IN      A    192.168.4.92
srv2.example.com.                        IN      A    192.168.4.93
share.example.com.                       IN      A    192.168.4.94
share1.example.com.                      IN      A    192.168.4.95
share2.example.com.                      IN      A    192.168.4.96
share3.example.com.                      IN      A    192.168.4.97
spacewalk.example.com.                   IN      A    192.168.4.98
redmine.example.com.                     IN      A    192.168.4.99
elk-stack.example.com.                   IN      A    192.168.4.101
icinga2.example.com.                     IN      A    192.168.4.130
icinga2-node1.example.com.               IN      A    192.168.4.131
icinga2-node2.example.com.               IN      A    192.168.4.132
fileserver.example.com.                  IN      A    192.168.4.133
store1.example.com.                      IN      A    192.168.4.137
store2.example.com.                      IN      A    192.168.4.138
store3.example.com.                      IN      A    192.168.4.139
store.example.com.                       IN      A    192.168.4.140
foreman.example.com.                     IN      A    192.168.4.141
ox-app.example.com.                      IN      A    192.168.4.186
ipa.example.com.                         IN      A    192.168.4.187
ilo4.example.com.                        IN      A    192.168.4.197
jenkins.example.com.                     IN      A    192.168.4.201
pdc.example.com.                         IN      A    192.168.4.210
openldap.example.com.                    IN      A    192.168.4.211
openldap2.example.com.                   IN      A    192.168.4.212
openattic.example.com.                   IN      A    192.168.4.213
openattic-2.example.com.                 IN      A    192.168.4.214
packetfence.example.com.                 IN      A    192.168.4.215
sw1.example.com.                         IN      A    192.168.4.253
```
