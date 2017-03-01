Neue Festplatte hinzufügen 
`pvcreate /dev/sda`

Volume Group vergrößern
`vgextend $VG /dev/sda3`

**Quellen**

Zusammenfassung der Schritte

    Vergrößern des Festplattenspeichers (auf physikalischer oder VMware Ebene)
    Neustarten der Maschine, damit der zusätzliche Festplattenspeicher erkannt wird
    Erstellen einer weiteren Partition z. B. mittels cfdisk
    Partitionstabelle neu Einlesen, z. B. per Reboot oder per Kommando partprobe
    Initialisieren einer neuen PV mittels pvcreate
    Vergrößern der VG mittels vgextend
    Vergrößern des LV mittels lvextend
    Vergrößern des Dateisystems z. B. mittels resize2fs
