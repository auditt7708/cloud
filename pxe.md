# Automatisierte Installation mit PXE-Boot und einer Preseed-Datei

Nun, da wir ein gespiegeltes Repository von Paketen haben, können wir es auch verwenden, um die Dateien zu bedienen, die unsere Hosts über das Netzwerk aufbauen. Das Erstellen von Bare-Metal-Servern über das Netzwerk hat viele Vorteile, so dass Sie einfach einen Bare-Metal-Server booten und über DHCP konfigurieren und ein Betriebssystem installieren können, ohne zusätzliche Interaktionen. Das PXE-Booten ermöglicht den Einsatz von völlig diskless Clients, die booten und über das Netzwerk laufen können.

Dies ist ein sehr langes Rezept, aber es ist erforderlich. Obwohl es relativ einfach ist, eine PXE-Boot-Umgebung einzurichten, benötigt es mehrere Elemente. Im Laufe dieses Rezepts werden Sie drei Hauptkomponenten erstellen: einen Apache-Server, einen DHCP-Server (Dynamic Host Configuration Protocol) und einen TFTP-Server (Trivial File Transfer Protocol). Alle diese werden zusammenarbeiten, um die benötigten Dateien zu bedienen, damit ein Client booten und Ubuntu installieren kann. Obwohl es hier mehrere Komponenten gibt, können sie alle bequem auf einem einzigen Server laufen.

Eine Alternative zu diesem Rezept ist das Schusterprojekt (https://cobbler.github.io). Cobbler bietet die meisten dieser Elemente aus der Box und fügt eine leistungsfähige Management-Schicht auf die Oberseite; Allerdings ist es sehr beeindruckt, wie es funktioniert und muss ausgewertet werden, um zu sehen, wie es in Ihre Umgebung passt, aber es lohnt sich, es zu betrachten.

Es lohnt sich zu bedenken, dass dieses Rezept für Bare-Metal-Server-Installationen konzipiert ist, und im Allgemeinen ist es nicht der beste Weg, um virtualisierte oder Cloud-basierte Server zu verwalten. In solchen Fällen bietet der Hypervisor oder Provider fast sicher eine bessere und optimiertere Installationsmethode für die Plattform an.
Fertig werden

Um diesem Rezept zu folgen, empfiehlt es sich, einen Host mit einer sauberen Installation von Ubuntu 14.04 zu haben. Idealerweise sollte dieser Host mindestens 20 GB oder mehr Festplatte haben, denn zumindest muss er das Ubuntu-Setup-Medium enthalten.
Wie es geht…

### Lassen Sie uns eine PXE-Boot-Umgebung einrichten:

1. Die erste Komponente, die wir konfigurieren werden, ist der TFTP-Server. Dies ist eine abgespeckte Version von FTP. TFTP eignet sich hervorragend für das Booten von Netzwerken, wo Sie einen unidirektionalen Datenfluss haben, der einfach und schnell ausgeliefert werden muss. Wir werden den TFTP Server benutzen, der mit Ubuntu 14.04 versendet wird. Um es zu installieren, geben Sie den folgenden Befehl ein:
`$ sudo apt-get install tftpd-hpa`

Dadurch werden die Pakete und deren Abhängigkeiten installiert.

2. Als nächstes müssen wir unseren TFTP-Server konfigurieren. Verwenden Sie Ihren bevorzugten Editor, bearbeiten Sie die TFTP-Konfigurationsdatei unter `/etc/default/tftpd-hpa`. Standardmäßig sollte es dem ähneln:
```
# /etc/default/tftpd-hpa
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/var/lib/tftpboot"
TFTP_ADDRESS="[::]:69"
TFTP_OPTIONS="--secure"
```
Sie müssen dies ändern, damit es als Daemon laufen kann. Passen Sie die Datei an, um die folgende Zeile hinzuzufügen:
```
# /etc/default/tftpd-hpa
RUN_DAEMON="yes"
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/var/lib/tftpboot"
TFTP_ADDRESS="[::]:69"
TFTP_OPTIONS="--secure"
```

