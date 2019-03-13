Kubernetes ist ein Open-Source-Container-Orchestrierungswerkzeug über mehrere Nodes im Cluster. Derzeit unterstützt es nur Docker. Es wurde von Google gestartet, und jetzt sind Entwickler von anderen Firmen dazu gekommen. Es bietet Mechanismen für application deployment, Terminierung, Aktualisierung, Wartung und Skalierung. Kubernetes 'Auto-Placement, Auto-Neustart, Auto-Replikation Features stellen sicher, dass der gewünschte Zustand der Anwendung beibehalten wird, die durch den Benutzer definiert sind. Benutzer definieren Anwendungen über YAML- oder JSON-Dateien, die wir später im Rezept sehen werden. Diese YAML- und JSON-Dateien enthalten auch die API-Version (das Feld `apiVersion`), um das Schema zu identifizieren. Das folgende Bild ist das architektonische Diagramm von Kubernetes:

![diagram-kubernetes](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_08_15.jpg)

https://raw.githubusercontent.com/GoogleCloudPlatform/kubernetes/master/docs/architecture.png

Schauen wir uns einige der wichtigsten Komponenten und Konzepte von Kubernetes an.

> * **Pods**: Eine Pod, die aus einem oder mehreren Containern besteht, ist die Deployment Unit von Kubernetes. Jeder Container in einem Pod teilt verschiedene Namespaces mit anderen Containern in der gleichen Pod. Zum Beispiel hat jeder Container in einem Pod den gleichen Netzwerk-Namespace, was bedeutet, dass sie alle über localhost kommunizieren können.

> * **Node/Minion**: Ein Knoten, der früher als Minion bekannt war, ist ein Worker knoten im Kubernetes-Cluster und wird über Master verwaltet. Pods werden auf einem Knoten bereitgestellt, der die notwendigen Dienste hat, um sie auszuführen:
>
>> * Docker, um Container auszuführen
>>
>> * Kubelet, um mit meister zu interagieren
>>
>> * Proxy (kube-Proxy), der den Service mit dem entsprechenden Pod verbindet
>>
>
> * **Master**: Master beherbergt Cluster-Level-Control-Services wie die folgenden:
>
>> 
>> * API-Server: Dies hat RESTful APIs, um mit Master und Knoten zu interagieren. Dies ist die einzige Komponente, die mit der etcd-Instanz spricht.
>>
>> * Scheduler: Dies plant Aufträge in Clustern, wie z. B. das Erstellen von Pods auf Knoten.
>> 
>> * Replikations-Controller: Damit wird sichergestellt, dass die benutzerdefinierte Anzahl von Pod-Repliken zu einem beliebigen Zeitpunkt ausgeführt wird. Um Replikate mit dem Replikationscontroller zu verwalten, müssen wir eine Konfigurationsdatei mit der Replikatzahl für einen Pod definieren.
>>
>
> Master kommuniziert auch mit etcd, was ein verteiltes Schlüsselwertpaar ist. Etcd wird verwendet, um die Konfigurationsinformationen zu speichern, die sowohl von Master als auch von Knoten verwendet werden. Die Watch-Funktionalität von etcd wird verwendet, um die Änderungen im Cluster zu benachrichtigen. Etcd kann auf Master oder auf einem anderen Satz von Systemen gehostet werden.
>
> * **Services**: In Kubernetes bekommt jeder Pod seine eigene IP-Adresse, und Pods werden jedes Mal erstellt und zerstört, basierend auf der Replikationscontroller-Konfiguration. Also, können wir uns nicht auf die IP-Adresse eines Pods verlassen, um eine App zu versorgen. Um dieses Problem zu überwinden, definiert Kubernetes eine Abstraktion, die einen logischen Satz von Pods und Richtlinien definiert, um darauf zuzugreifen. Diese Abstraktion heißt Service. Labels werden verwendet, um den logischen Satz zu definieren, der ein Dienst verwaltet.
>
> * **Labels**: Labels sind Schlüsselwertpaare, die an Objekten angebracht werden können, mit denen wir eine Teilmenge von Objekten auswählen. Zum Beispiel kann ein Service alle Pods mit dem Label `mysql` auswählen.
> 
> * **Volumes**: Ein Volume ist ein Verzeichnis, das für die Container in einem Pod zugänglich ist. Es ist ähnlich wie Docker-Bände, aber nicht das gleiche. In Kubernetes werden verschiedene Arten von Volumes unterstützt, von denen einige EmptyDir (kurzlebig), HostDir, GCEPersistentDisk und NFS sind. Aktive Entwicklung ist, um mehr Arten von Bänden zu unterstützen. Weitere Details finden Sie unter https://kubernetes.io/docs/user-guide/volumes/.
> 

Kubernetes kann auf VMs, physischen Maschinen und der Cloud installiert werden. Für die komplette Matrix, werfen Sie einen Blick auf https://github.com/GoogleCloudPlatform/kubernetes/tree/master/docs/getting-started-guides. In diesem Rezept werden wir sehen, wie man es auf VMs installiert, mit Vagrant mit VirtualBox-Provider. Dieses Rezept und die folgenden Rezepte von Kubernetes, wurden auf v0.17.0 von Kubernetes versucht.

### Fertig werden
* Installiere die neuesten Vagrant> = 1.6.2 von http://www.vagrantup.com/downloads.html.

* Installiere die neueste VirtualBox von https://www.virtualbox.org/wiki/Downloads. Detaillierte Anleitungen zum Einrichten dieses Gerätes liegen außerhalb des Umfangs dieses Buches.

### Wie es geht…

Führen Sie den folgenden Befehl aus, um Kubernetes auf Vagrant VMs einzurichten:
```
$ export KUBERNETES_PROVIDER=vagrant
$ export VAGRANT_DEFAULT_PROVIDER=virtualbox
$ curl -sS https://get.k8s.io | bash

```

### Wie es funktioniert…

Das bash-Skript, das aus dem `curl`-Befehl heruntergeladen wurde, lädt zuerst die neueste Kubernetes-Version herunter und führt dann das Skript ./kubernetes/cluster/kube-up.sh bash aus, um die `KUBERNETES_PROVIDER` einzurichten. Wie wir Vagrant als KUBERNETES_PROVIDER spezifiziert haben, lädt das Skript zuerst die Vagrant Bilder herunter und konfiguriert dann mit Salt (http://saltstack.com/) einen Master und einen Knoten (Minion) VM. Die Initialisierung dauert ein paar Minuten.

Vagrant erstellt eine Berechtigungsdatei in `~/.kubernetes_vagrant_auth` zur Authentifizierung.

### Es gibt mehr…

Ähnlich wie bei ./cluster/kube-up.sh gibt es weitere Hilfskripts, um verschiedene Operationen von der Host-Maschine selbst auszuführen. Stellen Sie sicher, dass Sie sich im Kubernetes-Verzeichnis befinden, das mit der vorherigen Installation erstellt wurde, während Sie die folgenden Befehle ausführen:

* Holen Sie sich die Liste der Nodes:
`$ ./cluster/kubectl.sh get nodes`

* Holen Sie sich die Liste der Pods:
`$ ./cluster/kubectl.sh get pods`

* Holen Sie sich die Liste der services:
`$ ./cluster/kubectl.sh get services`

* Erhalten Sie die Liste der Replikationscontroller:
`$ ./cluster/kubectl.sh get replicationControllers`

* Zerstöre den vagabunden cluster:
`$ ./cluster/kube-down.sh`

* Dann bringen Sie den vagabunden Cluster zurück:
`$ ./cluster/kube-up.sh`

Sie sehen einige `pods`, `services` und `replicationControllers` aufgeführt, wie Kubernetes sie für den internen Gebrauch erstellt.

### Siehe auch

* Einrichten der vagabunden Umgebung unter https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/vagrant.md

* Die Kubernetes Bedienungsanleitung unter https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/user-guide.md

* Kubernetes API Konventionen unter https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/api-conventions.md