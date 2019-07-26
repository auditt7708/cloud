# Docker Orchestration atomic Speicher

Der Atomic-Host ist eine minimale distribution und wird als solche auf einem 6-GB-Image verteilt, um den footprint klein zu halten. Dies ist nicht sehr viel Speicherplatz zum bauen und zum speichern vieler Docker Images, es ist aber empfehlenswert, externe Speicher für diese Operationen zu benutzen.

Standardmäßig verwendet Docker `/var/lib/docker` als Standardverzeichnis, in dem alle Docker-bezogenen Dateien, einschließlich Iamges, gespeichert sind. In Project Atomic verwenden wir direkte LVM-Volumes über das Devicemapper-Backend, Docker-Images und Metadaten in werden in `/dev/atomicos/docker-data` und `/dev/atomicos/docker-meta` gespeichert.

Um mehr Speicher hinzuzufügen, bietet Project Atomic ein Helfer-Skript namens `docker-storage-helper`an , um eine externe Festplatte in die vorhandenen LVM thin Pool hinzuzufügen. Schauen wir uns den aktuellen verfügbaren Speicher an Docker mit dem `docker info` Befehl an:
`sudo docker info`

![Docker device Mapper](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_08_22.jpg)

Wie wir sehen können, beträgt die gesamte Datenkapazität 2,96 GB und der gesamte Metadatenspeicher 8,38 MB.

## Fertig werden

1. Stoppen Sie die VM, wenn sie läuft.

2. Fügen Sie eine zusätzliche Festplatte der Größe hinzu, die Sie dem Projekt Atomic VM wünschen. Ich habe 8 GB hinzugefügt.

3. Starten Sie die VM.

4. Prüfen Sie, ob die neu angeschlossene Festplatte für die VM sichtbar ist oder nicht.

## Wie es geht…

Überprüfen Sie, ob die zusätzliche Festplatte für den Atomic Host VM verfügbar ist:
`sudo fdisk -l`

Wie wir sehen können, ist die neu erstellte 8 GB Festplatte für die VM verfügbar.

2.Da die neu angeschlossene Festplatte `/dev/sdb` ist, erstellen Sie eine Datei namens `/etc/sysconfig/docker-storage-setup` mit folgendem Inhalt:

```s
DEVS="/dev/sdb"
[fedora@atomichost ~]$ cat /etc/sysconfig/docker-storage-setup 
DEVS="/dev/sdb"
```

3.Führen Sie den Befehl `docker-storage-setup` aus, um `/dev/sdb` zum vorhandenen Volume hinzuzufügen:

`$ sudo docker-storage-setup`

4. Nun schauen wir uns den momentan verfügbaren Speicher an Docker noch einmal mit dem Docker-Info-Befehl an:

`docker info`

Wie wir sehen können, haben sich sowohl der gesamte Datenbereich als auch der Metadatenbereich erhöht.

## Wie es funktioniert…

Das Verfahren ist das gleiche wie das Vergrößerung eines anderen LVM-Volumens. Wir erstellen ein physisches Volume auf der hinzugefügten Festplatte, fügen das physikalische Volume zur Volume-Gruppe hinzu und erweitern dann die LVM-Volumes. Da wir direkt auf den thin Pool im Docker zugreifen, brauchen wir kein Dateisystem zu erstellen oder zu erweitern oder die LVM-Volumes zu installieren.

## Es gibt mehr…

* Zusätzlich zur `DEVS`-Option können Sie die `VG`-Option auch der `/etc/sysconfig/docker-storage-setup` Datei hinzufügen, um eine andere Volume-Gruppe zu verwenden.

* Sie können mehr als eine Festplatte mit der Option DEVS hinzufügen.

* Wenn eine Festplatte, die bereits Teil der Volume-Gruppe ist, mit der DEVS-Option bekannt gemacht wurde, wird das `docker-storage-setup beendet`, da das vorhandene Gerät eine Partition und ein physisches Volume bereits erstellt hat.

Das `docker-storage-setup beendet` behält 0,1 Prozent der Größe für Metadaten bei. Aus diesem Grund haben wir auch eine Erhöhung des Metadatenraums gesehen.

## Siehe auch

* Die Dokumentation auf der Project Atomic Website unter http://www.projectatomic.io/docs/docker-storage-recommendation/

* Unterstützte Dateisysteme mit Project Atomic unter http://www.projectatomic.io/docs/filesystems/
