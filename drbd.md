drbd Administration
================

**Infos **
* Das von **drbdadm** erstelle device muss auf Master und Slave erstellt werden .
* In der Konfiguration muss auf den Parameter **on** das Resultat von ```$(hostname -s)``` () folgen

**drbd device erstellen**
```drbdadm create-md drbd0 ```

**Primary Master Festlegen**
`drbdadm -- --overwrite-data-of-peer primary drbd0`

**Prüfen des Zustandes **
 `cat /proc/drbd`

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

**Primary Master Festlegen**
`drbdadm -- --overwrite-data-of-peer primary drbd0`

