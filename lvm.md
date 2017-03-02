**Neue Festplatte hinzufügen **
`pvcreate /dev/sda`

**Volume Group vergrößern**
`vgextend $VG /dev/sda3`

**Vergrößern des LV**
`lvextend -L 1G /dev/mapper/deviceN`

ACHTUNG 1G ist die Größe das Gerät insgesamt hat!

**Vergrößern des LV auf die maximale Größe**
`lvextend -l +100%FREE /dev/mapper/deviceN `

**Quellen**
* [LVM_vergrößern](https://www.thomas-krenn.com/de/wiki/LVM_vergrößern)


Zusammenfassung der Schritte

    Vergrößern des Festplattenspeichers (auf physikalischer oder VMware Ebene)
    Neustarten der Maschine, damit der zusätzliche Festplattenspeicher erkannt wird
    Erstellen einer weiteren Partition z. B. mittels cfdisk
    Partitionstabelle neu Einlesen, z. B. per Reboot oder per Kommando partprobe
    Initialisieren einer neuen PV mittels pvcreate
    Vergrößern der VG mittels vgextend
    Vergrößern des LV mittels lvextend
    Vergrößern des Dateisystems z. B. mittels resize2fs
