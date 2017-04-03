# Virtuelle Maschinen

| Adresse | Service |
| :--------: | :--------: |
| store.example.com   | [cluster ](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store)         |
| store1.example.com   | [cluster ](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store1)    |
| store2.example.com   | [cluster ](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store2)    |
| store3.example.com   | [cluster ](https://gitlab.com/tobkern1980/home-net4-environment/wikis/store3)    |
| foreman.example.com   | [foreman](https://gitlab.com/tobkern1980/home-net4-environment/wikis/foreman)    |
| icinga2.example.com   | [icinga2](https://gitlab.com/tobkern1980/home-net4-environment/wikis/icinga2)    |
| openldap.example.com   | [openldap](https://gitlab.com/tobkern1980/home-net4-environment/wikis/openldap)    |
| jenkins.example.com   | [jenkins](https://gitlab.com/tobkern1980/home-net4-environment/wikis/jenkins)    |

# FsTab

| Quelle | Mount | Type | options | dump | pass| 
| :--------: | :--------: | :--------: | :--------: | :--------: | :--------: |
|UUID=c1baae53-b55a-4b31-b191-ab80cef17471 | /mnt/data| xfs  |defaults| 1|         2|
|/dev/mapper/drbdpool-data| /data/brick1| xfs| defaults| 1| 2|
|UUID=78e39f47-67ee-4114-b908-649a93f67776|    /mnt/backup |ext4| defaults|  0|         0|
|UUID=df0e85d2-e5e6-4877-8bba-63349d5dcf99|    /mnt/data2| xfs| defaults |   0|         0|
|UUID=7de030c6-c807-4866-9490-d7d4bc2f954a|    /mnt/media|  ext4| defaults |  0 |       0|

# Verzeichnisse und Zweck

**/mnt/backup/**
BAckup der localen systeme. 

**/mnt/data/**
./glusterfsdata/  mit den Verzeichnissen
images  mongodb  repos  tftpboot  Treiber  unattended
zum Testen von [GlusterFS](../glusterfs)

**/mnt/data2/**
Hat die Unterverzeichnisse : 
Anwendungen  dokumente  games  user

**/mnt/dokumente/**
ist derzeit leer.

**/mnt/drbd0/**
Mount für drbd 

**/mnt/media/**
Erstes unterverzeichnis ist 
Bilder  musik  Projekte  Software  truetypes  videos

# LVM 

** LVS**

| LV | VG | Größe|
| :--------: | :--------: | :--------: |
|backup|drbdpool|1T|
|data|drbdpool|500Gb|
|dokumente|drbdpool|50Gb|
|media|drbdpool|1T|
|image-brick1|ubuntu-vg|49,12Gb|
|root|ubuntu-vg|170Gb|
|swap_1|ubuntu-vg|3,96Gb|