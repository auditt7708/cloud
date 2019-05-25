Project Atomic erleichtert die anwendungsorientierte IT-Architektur durch die Bereitstellung einer End-to-End-Lösung für die Bereitstellung von Container-Anwendungen schnell und zuverlässig mit atomic Update und Rollback für Applikation und Host.

Dies geschieht durch den Einsatz von Applikationen in Containern auf einem Project Atomic Host, bei dem es sich um ein mini Betriebssystem handelt, das speziell für den Betrieb von Containern entwickelt wurde. Die Hosts können auf Fedora, CentOS oder Red Hat Enterprise Linux basieren.

Als nächstes werden wir die Bausteine des Project Atomic Hosts erarbeiten.

* **OSTree und rpm-OSTree**: OSTree (https://wiki.gnome.org/action/show/Projects/OSTree) ist ein Werkzeug, um bootfähige, unveränderliche und versionierte Dateisystembäume zu verwalten. Mit diesem können wir Client-Server-Architektur aufbauen, in der der Server ein OSTree-Repository hostet und der Client, der ihn subscribet hat, den Inhalt inkrementell replizieren kann.

Rpm-OSTree ist ein System, um RPMs auf der Serverseite in das OSTree Repository zu zerlegen, auf das der Client subscribet und Updates durchführen kann. Bei jedem Update wird eine neue Wurzel erstellt, die für den nächsten Neustart verwendet wird. Während Updates, `/etc` ist wiederverwendet und `/var` bleibt unberührt.

* **Container runtime**: Ab sofort unterstützt Project Atomic Docker als Container Umgebung.

* **systemd**: Wie wir in früheren Rezepten gesehen haben, ist systemd ein neues init-System. Es hilft auch, SELinux-Richtlinien in Containern für vollständige Multitenant-Sicherheit einzurichten und Cgroups-Richtlinien zu kontrollieren.

Project Atomic nutzt Kubernetes (http://kubernetes.io/) für die Anwendungsbereitstellung über Cluster von Container-Hosts. Project Atomic kann auf Bare Metal, Cloud Provider, VMs und so weiter installiert werden. In diesem Rezept, werden wir es auf einer VM mit virt-Manager auf Fedora installieren können.

### Fertig werden

1. Download das image:
```
$ wget http://download.fedoraproject.org/pub/fedora/linux/releases/test/22_Beta/Cloud/x86_64/Images/Fedora-Cloud-Atomic-22_Beta-20150415.x86_64.raw.xz
```

Ich habe das Beta-Image für Fedora 22 Cloud Image für Container heruntergeladen. Sie sollten nach dem neuesten Cloud-Image für Container unter `https://getfedora.org/en/cloud/download/` suchen.

2. Entpacken Sie dieses Image mit dem folgenden Befehl:
`$ xz -d Fedora-Cloud-Atomic-22_Beta-20150415.x86_64.raw.xz `

## Wie es geht…

1. Wir haben das Cloud-Image heruntergeladen, das kein Passwort für den Standardbenutzer `fedora` hat. Beim Booten der VM müssen wir eine Cloud-Konfigurationsdatei angeben, über die wir die VM anpassen können. Dazu müssen wir zwei Dateien, `meta-data` und `user-data` wie folgt erstellen:
```
$ cat  meta-data
instance-id: iid-local01 
local-hostname: atomichost

$ cat user-data 
#cloud-config 
password: atomic 
ssh_pwauth: True 
chpasswd: { expire: False } 

ssh_authorized_keys: 
- ssh-rsa AAAAB3NzaC1yc.........
```
Im vorherigen Code müssen wir den vollständigen öffentlichen SSH Schlüssel zur Verfügung stellen. Wir müssen dann ein ISO-Image erstellen, das aus diesen Dateien besteht, die wir zum Starten auf die VM verwenden. 
Da wir ein Cloud-Bild verwenden, wird unsere Einstellung während des Bootvorgangs auf die VM angewendet. Dies bedeutet, dass der Hostname auf `atomichost` gesetzt wird, das Passwort wird auf `atomar` gesetzt und so weiter. 
Um die ISO zu erstellen, führen Sie den folgenden Befehl aus:
`$ genisoimage -output init.iso -volid cidata -joliet -rock user-data meta-data`

2. start virt-manager.

3. Wählen Sie Neue virtuelle Maschine aus und importieren Sie das vorhandene Datenträger-Image. Geben Sie den Bildpfad des Projektes Atombild ein, das wir früher heruntergeladen haben. Wählen Sie den OS-Typ als Linux und Version als Fedora 20 / Fedora 21 (oder höher) und klicken Sie auf Weiter. Als nächstes weisen Sie CPU und Speicher zu und klicken auf Weiter. Dann geben Sie der VM einen Namen und wählen Sie vor der Installation die Option Anpassen. Schließlich klicken Sie auf Finish und überprüfen Sie die Details.

4. Als nächstes klicken Sie auf Hardware hinzufügen und nach der Auswahl von Speicher die ISO (`init.iso`) Datei, die wir an die VM erstellt haben, und wählen Sie Fertig stellen:
![libvirt-manager-1](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_08_08.jpg)

Nach dem Booten können Sie sehen, dass der Hostname korrekt eingestellt ist und Sie sich über das in der Cloud-init-Datei angegebene Passwort anmelden können. Der Standardbenutzer ist `fedora` und das Passwort ist `atomar` wie in der Benutzer-Datei eingestellt.

### Wie es funktioniert…

In diesem Rezept haben wir ein Projekt Atomic Fedora Cloud-Image erstellt und es mit virt-Manager gebootet nach der Bereitstellung der Cloud-init-Datei.

### Es gibt mehr…

* Nach der Anmeldung, wenn Sie bei `/`alle Datein auslisten lassen, werden Sie sehen, dass die meisten der traditionellen Verzeichnisse mit `/var` verknüpft sind, weil es über Upgrades bewahrt wird.

Nach dem Einloggen können Sie den Docker-Befehl wie gewohnt ausführen:
`$sudo docker run -it fedora bash`

### Siehe auch

* Die virtuelle Manager-Dokumentation unter https://virt-manager.org/documentation/

* Weitere Informationen zu Paketsystemen, Bildsystemen und RPM-OSTree finden Sie unter https://github.com/projectatomic/rpm-ostree/blob/master/doc/background.md

* Die Schnellstartanleitung auf der Project Atomic Website unter http://www.projectatomic.io/docs/quickstart/

* Die Ressourcen auf Cloud-Images unter https://www.technovelty.org//linux/running-cloud-images-locally.html und http://cloudinit.readthedocs.org/de/latest/

Wie man Kubernetes mit einem Atomic-Host wird auf http://www.projectatomic.io/blog/2014/11/testing-kubernetes-with-an-atomic-host/ und https://github.com/cgwalters/vagrant genau erklärt.