Bevor wir auf die Reise des eigenen Clusters gehen, müssen wir die Umgebung vorbereiten, um folgende Komponenten zu bauen:
![schema-kubernetes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_04.jpg)

Es gibt verschiedene Lösungen für die Schaffung eines solchen Kubernetes-Clusters, zum Beispiel:

> * Local-Machine-Lösungen, die Folgendes beinhalten:
>
>> * Docker-basierte
>>
>> * Vagrant
>>
>> * Linux-Maschine
>
 > * Hosted Lösung, die beinhaltet:
>
>>
>> * Google Container Engine
>>
>
> * Kundenspezifische Lösungen
>


Eine lokale Maschinenlösung eignet sich, wenn wir nur eine Entwicklungsumgebung aufbauen oder den Durchführung des Konzepts schnell machen wollen. Durch die Verwendung von **Docker** (https://www.docker.com) oder **Vagrant** (https://www.vagrantup.com) konnten wir ganz einfach die gewünschte Umgebung in einer einzigen Maschine bauen; Allerdings ist es nicht praktisch, wenn wir eine Produktionsumgebung aufbauen wollen. Eine gehostete Lösung ist der einfachste Ausgangspunkt, wenn wir es in der Cloud bauen wollen.

**Google Container Engine**, die seit vielen Jahren von Google verwendet wurde, hat natürlich die umfangreiche  Unterstützung  und wir brauchen nicht viel über die Installation und Einstellung zu sorgen. Kubernetes können auch auf verschiedenen Cloud- und VM-VMs nach kundenspezifischen Lösungen laufen. Wir werden in den folgenden Kapiteln die Kubernetes-Cluster von Grund auf auf Linux-basierten virtuellen Maschinen (CentOS 7.1) aufbauen. Die Lösung eignet sich für alle Linux-Rechner in Cloud- und On-Premise-Umgebungen.

### Fertig werden

Es wird empfohlen, wenn Sie mindestens vier Linux-Server für Master, etcd und zwei Nodes haben. Wenn Sie es als Hochverfügbarkeits-Cluster erstellen möchten, werden mehr Server für jede Komponente bevorzugt. Wir werden in den folgenden Abschnitten drei Arten von Servern erstellen:

* Kubernetes master
* Kubernetes node
* etcd

Flannel befindet sich nicht in einer Maschine, die in allen Nodes benötigt wird. Die Kommunikation zwischen Containern und Diensten erfolgt durch Flanell, das ist ein etcd Backend Overlay Netzwerk für Container.

### Hardware-Ressource

Die Hardware-Spezifikation jeder Komponente wird in der folgenden Tabelle vorgeschlagen. Bitte beachten Sie, dass es zu einer längeren Reaktionszeit bei der Manipulation des Clusters kommen kann, wenn die Anzahl der Anfragen zwischen dem API-Server und dem Betriebssystem groß ist. In einer normalen Situation können zunehmende Ressourcen dieses Problem lösen:

|Compunente | kubernetes master|etcd|
| :---: | :---: | :---: |
|CPU Anzahl|1|1|
|RAM GB|2G|2G|

Für die Node ist die Standard-Maximalanzahl von Pods in einem Node 40. Jedoch ist eine Node kapazität konfigurierbar, wenn eine Node hinzugefügt wird. Sie müssen messen, wie viele Ressourcen Sie für die gehosteten Dienste und Anwendungen benötigen, um zu entscheiden, wie viele Nodes dort mit einer bestimmten Spezifikation und mit einer ordnungsgemäßen Überwachung in der Produktionsarbeit sein sollten.

### Tip 
Überprüfen Sie Ihre Knotenkapazität im Knoten

In deinem Master kannst du `jq` von `yum install jq` und `kubectl get nodes -o json | jq '.items[] | {name: .metadata.name, capacity: .status.capacity}'`, um die Kapazität jedes Knotens einschließlich CPU, Speicher und die maximale Kapazität von Pods zu überprüfen:
```
// check out your node capacity
$ kubectl get nodes -o json | jq '.items[] | {name: .metadata.name, capacity: .status.capacity}'
{
  "name": "kub-node1",
  "capacity": {
    "cpu": "1",
    "memory": "1021536Ki",
    "pods": "40"
  }
}
{
  "name": "kub-node2",
  "capacity": {
    "cpu": "1",
    "memory": "1021536Ki",
    "pods": "40"
  }
}
```

### Betriebssystem

Das OS von den Nodes könnte verschieden sein, aber die Kernelversion muss 3.10 oder später sein. Im Folgenden sind die Betriebssysteme, die Kernel verwenden 3.10+ aufgelistet:

* CentOS 7 or later
* RHEL 7 or later
* Ubuntu Vivid 15.04 / Ubuntu Trusty 14.04 (LTS) / Ubuntu Saucy 13.10

### Hinweis
Hüten Sie sich vor der Linux-Kernel-Version

Docker erfordert, dass Ihr Kernel mindestens 3.13 Kernel Version auf CentOS oder Red Hat Enterprise Linux,  Ubuntu Precise 12.04 (LTS) sein muss. Es wird sonst dazu führen, dass Datenverlust oder Kernel Panik manchmal bei Verwendung von nicht unterstützten Kerneln vorkommet. Es empfiehlt sich, das System vor dem Bau von Kubernetes vollständig zu aktualisieren. Sie können uname -r verwenden, um den Kernel zu überprüfen, den Sie gerade verwenden. Weitere Informationen zur Überprüfung der Kernel-Version finden Sie unter http://www.linfo.org/find_kernel_version.html.

### Wie es geht…

Um sicherzustellen, dass jede Komponente im Kubernetes-Cluster einwandfrei funktioniert, müssen wir die richtigen Pakete auf jeder Maschine von Master, Node und etcd installieren.

### Kubernetes Meister

Der Kubernetes-Master sollte auf einem Linux-basierten Betriebssystem installiert sein. Für die in diesem Buch aufgeführten Beispiele verwenden wir CentOS 7.1 als OS. Im Master sind zwei Pakete erforderlich:

* Kubernetes
* Flannel (optional)
* iptables (at least 1.4.11+ is preferred)

### Hinweis
Hüten Sie sich vor iptables Version

Kubernetes nutzt iptables zur Implementierung von Service Proxy. Iptables mit Version 1.4.11+ wird bei Kubernetes empfohlen. Ansonsten können die iptables-Regeln außer Kontrolle geraten und weiter vergrößern. Sie können yum info iptables verwenden, um die aktuelle Version von iptables zu überprüfen.

### Kubernetes-Knoten

Auf den Kubernetes-Knoten müssen wir Folgendes vorbereiten:

* Kubernetes
* Flannel daemon
* Docker ( 1.6.2+ ist empfohlen)
* iptables (1.4.11+ ist empfohlen)

### Notiz
Vorsicht vor Docker Version und Abhängigkeiten

Manchmal bekommst du einen unbekannten Fehler bei der Verwendung der inkompatiblen Docker-Version, wie z. B. Zielbild nicht gefunden wird. Sie können immer den Befehl `docker version` verwenden, um die aktuelle Version zu überprüfen, die Sie installiert haben. Die empfohlenen Versionen, die wir getestet haben, sind mindestens 1.7.1+. Vor dem Erstellen des Clusters können Sie den Dienst starten, indem Sie den `service docker start` verwenden und sicherstellen, dass er mit dem `docker ps` kontaktiert werden kann.

Docker hat unterschiedliche Paketnamen und Abhängigkeitspakete in Linux-Distributionen. In Ubuntu kannst du `curl -sSL https://get.docker.com/ |  sh` verwenden. Weitere Informationen finden Sie im Docker-Installationsdokument (http://docs.docker.com/v1.8/installation), um Ihr bevorzugtes Linux-Betriebssystem zu finden.

### etcd

Etcd, ist ein verteilter zuverlässiger Key-Value-Store für gemeinsame Konfigurationen und Service Discovery , wird von CoreOS weiterentwickelt. Die Release-Seite ist https://github.com/coreos/etcd/releases. Die Voraussetzung, die wir brauchen, ist nur das etcd Paket.

### Siehe auch

Nach der Vorbereitung der Umgebung ist es Zeit, Ihre Kubernetes Cluster aufzubauen.