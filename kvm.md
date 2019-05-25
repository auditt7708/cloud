# KVM

## [ibvirt](../libvirt)

### [Qemu](../qemu)

## [Image Formate](../images)

Über die Jahre wurden immer wieder neuer Standards für die Speicherung der Virtuellen Festplatten umgesetzt Heute kann man Sie wie Folgt Klassifizieren

1.Read only Images z.B ISO .
2.Raw Daten werden 1 zu 1 Block orientiert auf einen Datenträger geschrieben. Lesen und Schreiben ist möglich.
3.High Level Images sind mit einigen Futures erweitert und haben eine Struktur zur besseren Administration.

### Verschlüsselung

Es kommt immer wieder vor , dass der Auftraggeber die Anforderung hat das die gespeicherten Daten in Verschlüsselter Form vorhanden sein müssen hier gibt es mit libvirt ein System zum Management der Verschlüsselten Images, da andernfalls immer jemand das secret manuell eingeben müsste

### Gold Image

Ein Gold Image oder auch im Englischen als Base Image bekannt, ist spezielles Image welches als Basis für andre Images dient.
In der Praxis endsthet als erstes ein 1:1-Klone das sogenannte Clone Image, da es nach dem Klonen genau wie das Gold Image ist können Änderungen am Gold Image in das Delta Image gespeichert werden

### Secret mit virsh anlegen

Das einrichten des sectres ist recht einfach mit:

`virsh secret-define secret.xml`

haben wir schon das Secret hinterlegt nun muss [virsh](../virsh) noch wissen welche Images es mit dem Erstellten secret öffnen/Starten kann.
Wenn man sich in der Konsole befunden hat wird sich [virsh](../virsh) schon automatisch ein Image aussuchen das meist auch Richtig ist, kann aber mit
``virsh secret-list``
kontrolliert werden.
Insebondere wenn ein image nachträglich verschlüsselt wurde wird es nicht immer automatisch auch vom [virsh](../virsh) festgestellt, wenn einen nachbearbeitung notwendig wird muss die XML Datei manuel angepasst werden

### Images Builder

* [Packer](../packer)

**Vm Image vergrößern:**
`qemu-img resize ubuntu-server.qcow2 +5GB`

wenn die Platte nicht gefunden werden kann muss noch `partprobe` ausgeführt werden auf dem Gast .

danach ist das Image größer muss aber noch auf dem Gast  angepasst werden .

**Größe des Images Überprüfen**
Es kommt manchmal vor, dass die Kapazität noch nicht genutzt werden kann also am besten immer prüfen !
`sudo qemu-img check -r all /var/lib/libvirt/images/web.qcow2`

**Gast Partition vergrößern**
Die erweiterung des Images wird als device interpritiert und kann zum Beispiel bei LVM als PV hinzugefügt werden .

Device  /dev/hdc1 zur my_volume_group Volume Gruppe hinzufügen
`vgextend my_volume_group /dev/hdc1`

Logisches Volume maximal erweitern
`lvextend -l +100%FREE /dev/mapper/cl-root`

Dateisystem Prüfen

`mount`

Ausgabe:

`# /dev/vda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,noquota)`

Dateisystem erweitern bei xfs Dateisystemen

`xfs_growfs /dev/mapper/cl-root`

## Text Konsolen

**Textkonsole bei Centos ermöglichen**
`grubby --update-kernel=ALL --args="console=ttyS0"`

Quelle:

* [rhel7-access-virtual-machines-console/](https://www.certdepot.net/rhel7-access-virtual-machines-console/)