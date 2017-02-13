drbd Administration


Infos 
* Das von **drbdadm** erstelle device muss auf Master und Slave erstellt werden .
* In der Konfiguration muss auf den Parameter **on** das Resultat von ```$(hostname -s)``` () folgen


drbd device erstellen
```drbdadm create-md drbd0 ```


Berechtigungen 

| Datei | Rechte | Benutzer |
| -------- | -------- | -------- |
|/etc/drbd.d/global_common.conf | 644 | root:root |