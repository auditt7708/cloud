Es wird empfohlen, dass Sie je nach Linux-Distribution eine Form von MAC auf dem Docker-Host entweder über SELinux oder AppArmor einrichten. In diesem Rezept sehen wir, wie man SELinux auf einem installierten System von Fedora / RHEL / CentOS einrichtet. Schauen wir mal an, was SELinux ist:

* SELinux ist ein Label system

* Jeder Prozess hat ein Label

* Jedes Datei-, Verzeichnis- und Systemobjekt hat ein Label

* Richtlinienregeln steuern den Zugriff zwischen mit einem Label markierten Prozessen und markierten Objekten

* Der Kernel erzwingt die Regeln

Mit Docker-Containern verwenden wir zwei Arten von SELinux-Durchsetzung:

* **Type enforcement**: Dies wird verwendet, um das Host-System vor Container-Prozesse zu schützen. Jeder Container-Prozess ist mit `svirt_lxc_net_t` gekennzeichnet und jede Container-Datei ist mit `svirt_sandbox_file_t` gekennzeichnet. Der Typ `svirt_lxc_net_t` darf alle mit `svirt_sandbox_file_t` gekennzeichneten Inhalte verwalten. Container-Prozesse können nur auf Container-Dateien zugreifen / schreiben.

* **Multi Category Security enforcement**: Durch die Einstellung der Typ enforcement werden alle Container-Prozesse mit dem Label `svirt_lxc_net_t` ausgeführt und alle Inhalte werden mit `svirt_sandbox_file_t` gekennzeichnet. Doch nur mit diesen Einstellungen schützen wir keinen Container von einem anderen, weil ihre Labels gleich sind.

Wir verwenden die **Multi Category Security (MCS)** Durchsetzung, um einen Container von einem anderen zu schützen, der auf **Multi Level Security (MLS)** basiert. Wenn ein Container gestartet wird, wählt der Docker-Daemon ein zufälliges MCS-Label, z.B `s0:c41,c717` und speichert es mit den Container-Metadaten. Wenn ein Containerprozess beginnt, teilt der Docker-Daemon dem Kernel mit, das richtige MCS-Label anzuwenden. Da das MCS-Label in den Metadaten gespeichert wird, bekommt es, wenn der Container neu gestartet wird, das gleiche MCS-Label.

### Fertig werden

Ein Fedora / RHEL / CentOS Host mit der neuesten Version von Docker installieren, die über einen Docker Client zugegriffen werden kann.

### Wie es geht…

Fedora / RHEL / CentOS wird standardmäßig mit SELinux im `enforcing` installiert und der Docker-Daemon wird mit SELinux gestartet. Um zu überprüfen, ob diese Bedingungen erfüllt sind, führen Sie die folgenden Schritte aus.

1. Führen Sie den folgenden Befehl aus, um sicherzustellen, dass SELinux aktiviert ist:

`$ getenforce`

Wenn der vorhergehende Befehl die `enforcing` zurückgibt, dann ist alles gut, sonst müssen wir ihn ändern, indem wir die SELinux-Konfigurationsdatei (`/etc/selinux/config`) aktualisieren und das System neu starten.

2. Docker sollte mit der Option `--selinux-enabled` ausgeführt werden. Sie können den Abschnitt `OPTIONEN` in der Docker-Daemon-Konfiguration (`/etc/sysconfig/docker`) -Datei überprüfen. Überprüfen Sie auch, ob der Docker-Service mit der SELinux-Option gestartet wurde:
`$ systemctl status docker`

Lassen Sie uns einen Container starten (ohne die privilegierte Option), nachdem Sie ein Hostverzeichnis als Volume installiert haben und versuchen, eine Datei zu erstellen:
```
su - dockertest
mkdir ~/dir1
docker run -it -v ~/dir:/dir fedora bash

touch /dir1/file1
# error
```
Wie erwartet, sehen wir, dass `Permission denied` , da ein Containerprozess mit dem Label `svirt_lxc_net_t` keine Dateien im Dateisystem des Hosts erstellen kann. Wenn wir die SELinux-Logs (`/var/log/audit.log`) auf dem Host betrachten, werden wir Nachrichten sehen, die folgend ähneln:

![seliux-docker-error-log](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_09_03.jpg)

Das `s0:c157,c350` Label ist das MCS Label auf dem Container.

### Wie es funktioniert…

SELinux setzt sowohl die Art als auch die Multi Kategorie Security Durchsetzung, wenn die richtigen Optionen für SELinux und Docker gesetzt sind. Der Linux-Kernel erzwingt diese Durchsetzung.

### Es gibt mehr…
* Wenn SELinux im enforcing modus ist und der Docker-Daemon für die Verwendung von SELinux konfiguriert ist, können wir den Host nicht aus dem Container herunterfahren, wie wir es früher in diesem Kapitel getan haben:

`getenforce`

* Wie wir wissen, werden standardmäßig alle Container mit dem Label `svirt_lxc_net_t` ausgeführt, aber wir können auch SELinux-Labels für benutzerdefinierte Anforderungen anpassen. Besuchen Sie die Anpassung SELinux Etiketten Abschnitt von http://opensource.com/business/15/3/docker-security-tuning.

* Das Einrichten von MLS mit Docker-Containern ist ebenfalls möglich. Besuchen Sie den Multi Level Security Modus Abschnitt von http://opensource.com/business/15/3/docker-security-tuning.

### Siehe auch

Das SELinux-Buch; Besuchen Sie https://people.redhat.com/duffy/selinux/selinux-coloring-book_A4-Stapled.pdf