Kubernetes abstrahiert die Vernetzung, um die Kommunikation zwischen Containern über Knoten zu ermöglichen. Die Grundeinheit, die es möglich macht, heißt pod, das ist die kleinste Einsatzeinheit in Kubernetes mit einem gemeinsamen Kontext in einer Containerumgebung. Container innerhalb einer Pod können mit anderen über den Hafen mit dem localhost kommunizieren. Kubernetes wird die Pods über die Knoten einsetzen.

Dann, wie gehen Pods miteinander?

Kubernetes verteilt jedem Pod eine IP-Adresse in einem freigegebenen Netzwerk-Namespace, so dass Pods mit anderen Pods über das Netzwerk kommunizieren können. Es gibt ein paar Möglichkeiten, um die Umsetzung zu erreichen. Die einfachste und quer über die Plattform Weg wird mit Flanell.

Flanell gibt jedem Host ein IP-Subnetz, das von Docker akzeptiert werden kann und die IPs den einzelnen Containern zuordnen kann. Flanell verwendet etcd, um die IP-Mapping-Informationen zu speichern, und hat ein paar Backend-Entscheidungen für die Weiterleitung der Pakete. Die einfachste Backend-Wahl würde TUN-Gerät verwenden, um IP-Fragment in einem UDP-Paket zu verkapseln. Der Port ist standardmäßig 8285.

Flanell unterstützt auch In-Kernel VXLAN als Backend, um die Pakete zu verkapseln. Es könnte eine bessere Leistung als UDP-Backend bieten, während es nicht im Benutzerbereich läuft. Eine weitere beliebte Wahl ist die Verwendung der erweiterten Routing-Regel auf Google Cloud Engine (https://cloud.google.com/compute/docs/networking#routing). Wir verwenden sowohl UDP als auch VXLAN als Beispiele in diesem Abschnitt.

Flanneld ist der Agent von Flanell, der verwendet wird, um die Informationen von etcd zu beobachten, das Subnetz-Leasing auf jedem Host zuzuordnen und die Pakete zu leiten. Was wir in diesem Abschnitt tun werden, ist, dass flanneld auf und läuft und ein Subnetz für jeden Host zuordnen wird.

#### Notiz

Wenn Sie kämpfen, um herauszufinden, welches Backend verwendet werden soll, hier ist ein einfacher Performance-Test zwischen UDP und VXLAN. Wir verwenden qperf (http://linux.die.net/man/1/qperf), um die Paketübertragungsleistung zwischen den Containern zu messen. TCP Streaming One Way Bandbreite durch UDP ist 0,3x langsamer als VXLAN, wenn es einige Lasten auf den Hosts. Wenn Sie es vorziehen, Kubernetes auf der Wolke zu bauen, ist GCP die einfachste Wahl.

### Fertig werden

Bevor Sie flannel installieren, stellen Sie sicher, dass Sie den etcd Endpunkt haben. Flanell braucht etcd als seinen Datenspeicher. Wenn Docker läuft, stoppen Sie zuerst den Docker-Dienst und löschen Sie `docker0`, was eine virtuelle Brücke ist, die von Docker erstellt wurde:
```
# Stop docker service
$ service docker stop

# delete docker0
$ ip link delete docker0
```

### Installation

Mit dem Befehl `etcdctl` haben wir im vorherigen Abschnitt auf der etcd-Instanz gelernt, die gewünschte Konfiguration in etcd mit dem Schlüssel `/coreos.com/network/config` einfügen:

|Konfigurations Key|Beschreibung|
| :---: | :---: |
|`Network`| IPv4-Netzwerk für flannel, um das gesamte virtuelle Netzwerk zuzuordnen|
|`SubnetLen`|Die Subnetz-Präfixlänge für jeden Host ist standardmäßig `24`.|
| `SubnetMin` |Der Anfang des IP-Bereichs für die flannel-Subnetz-Zuweisung|
| `SubnetMax` |Das Ende des IP-Bereichs für die flannel-Subnetz-Zuordnung|
|`Backend`|Backend-Auswahlmöglichkeiten für die Weiterleitung der Pakete. Standard ist udp.|
