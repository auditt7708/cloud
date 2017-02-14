Daten
=====

Clustername = testcluster


drbd Administration
================

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


Berechtigungen Matrix
===================

Da es zu Fehlern kommt wenn die Berechtigungen nicht korrekt gesetzt werden kommt, hier alle Dateien mit ihren soll Berechtigungen.

| Datei | Rechte | Benutzer |
| -------- | -------- | -------- |
|/etc/drbd.d/global_common.conf | 644 | root:root |


Fehler Behebung
==============

Splitbrain Fehler  sowie ein Fehler auftritt der irgendetwas in der Richtung nennt, kann man folgendes versuchen : 

**Auf dem secondary ihn nochmal als secondary festlegen:**
`drbdadm secondary drbd0`
drbdadm secondary all

**Primary Master Festlegen**

`drbdadm -- --overwrite-data-of-peer primary drbd0`


**Quellen: **
* https://www.hastexo.com/resources/hints-and-kinks/solve-drbd-split-brain-4-steps/

