KVM
====

#### [ibvirt](../libvirt)

#### [Qemu](../qemu)

Images
======

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
`mount `
Ausgabe: 
`# /dev/vda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,noquota) `

Dateisystem erweitern bei xfs Dateisystemen
`xfs_growfs /dev/mapper/cl-root`



