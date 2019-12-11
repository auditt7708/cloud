# Netwerk Konfiguration

| Typ | MAC | Gerätebezeichner | DNS-Name | Domäne | IPv4 | IPv6 |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| NIC | 70:85:c2:03:2a:53 | enp1s0 | srv2.oshsl.de | oshsl.de |  | keins |
| NIC | 70:85:c2:03:2a:53 | enp3s0 | srv2.oshsl.de | oshsl.de | 192.168.4.93/24 | keins|
| VPN| 96:6d:78:85:4a:ef| ztbpanrtig| srv2.local | oshsl.de| 10.147.17.175/24|

## Virtuelle Maschinen

| Adresse | Service |
| :---: | :---: |
| store.example.com      | [cluster](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store)     |
| store1.example.com     | [cluster](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store1)    |
| store2.example.com     | [cluster](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store2)    |
| store3.example.com     | [cluster](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store3)    |
| foreman.example.com    | [foreman](https://gitlab.com/tobkern1980/home-net4-environment/wikis/foreman)    |
| icinga2.example.com    | [icinga2](https://gitlab.com/tobkern1980/home-net4-environment/wikis/icinga2)    |
| openldap.example.com   | [openldap](https://gitlab.com/tobkern1980/home-net4-environment/wikis/openldap)  |
| jenkins.example.com    | [jenkins](https://gitlab.com/tobkern1980/home-net4-environment/wikis/jenkins)    |

## FsTab

| Quelle | Mount | Type | options | dump | pass|
| :--------: | :--------: | :--------: | :--------: | :--------: | :--------: |
|UUID=c1baae53-b55a-4b31-b191-ab80cef17471 | /mnt/data   | xfs  | defaults | 1| 2|
|/dev/mapper/drbdpool-data                 | /data/brick1| xfs  | defaults | 1| 2|
|UUID=78e39f47-67ee-4114-b908-649a93f67776 | /mnt/backup | ext4 | defaults | 0| 0|
|UUID=df0e85d2-e5e6-4877-8bba-63349d5dcf99 | /mnt/data2  | xfs  | defaults | 0| 0|
|UUID=7de030c6-c807-4866-9490-d7d4bc2f954a | /mnt/media  | ext4 | defaults | 0| 0|

## Verzeichnisse und Zweck

/mnt/backup/

Backup der localen systeme. Hier ist auch die Dokumentation pdf Datein sowie Daten aufgehoben und werden mit.

/mnt/drbd/

Mount für drbd

/mnt/media/

Erstes unterverzeichnis ist
Bilder  musik  Projekte  Software  truetypes  videos

df ausgabe

| Dateisystem | Größe | Benutzt | Verf. | Verw% | Eingehängt auf|
| :---: | :---: | :---: | :---: | :---: | :---: |
|/dev/sdc3|1008G|445G|513G|47%|/mnt/media|
|/dev/sdc4|654G|160G|495G|25%|/mnt/data2|
|/dev/mapper/drbdpool-backup|1008G|9,1G|948G|1%|/mnt/backup|
|/dev/mapper/drbdpool-data|500G|133G|368G|27%|/mnt/data|

## LVM

LVS Umgebung

| LV | VG | Größe| Dateisystem |
| :--------: | :--------: | :--------: | :--------: |
|backup|vg-data-4tb-wd|1T| ext4 |
|docker|vg-data-4tb-wd|500Gb| xfs/ext4? |
|drbd|vg-data-4tb-wd|250Gb| xfs |
|databases|vg-data-4tb-wd|1T| xfs |
|brick1|vg-data-4tb-wd|50Gb| xfs |
|root|centos|50Gb| xfs |
|swap|centos|7,81g| swap |

## Planung für DRBD

| DRBD Device | Dateisystem | Zweck|
| :--------: | :--------: | :--------: |
|/dev/drbd0|xfs|nfs,smb mount|
|/dev/drbd1|ext4|dokumente|
|/dev/drbd2|xfs|Datenbanken,etc|
