Kubernetes ist ein Open-Source-Container-Management-Tool. Es ist ein Go-Lang-basierte (https://golang.org), leichte und tragbare Anwendung. Sie können einen Kubernetes-Cluster auf einem Linux-basierten Betriebssystem einrichten, um die Docker-Container-Anwendungen auf mehreren Hosts zu implementieren, zu verwalten und zu skalieren.

### Fertig werden

Kubernetes wird mit mehreren Komponenten wie folgt konstruiert:

* Kubernetes Meister

* Kubernetes-Nodes

* etcd

* Overlay-Netzwerk (flannel)

Diese Komponenten sind über das Netzwerk verbunden, wie im folgenden Screenshot gezeigt:

![diagram-kubernetes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_01.jpg)

Das vorangehende Bild lässt sich wie folgt zusammenfassen:

* **Kubernetes Master** verbindet sich mit **etcd** über HTTP oder HTTPS, um die Daten zu speichern. Es verbindet auch **flanell**, um auf die Containeranwendung zuzugreifen.

* Kubernetes-Nodes verbinden sich mit dem **Kubernetes-Master** über HTTP oder HTTPS, um einen Befehl zu erhalten und den Status zu melden.

* Kubernetes-Nodes verwenden ein Overlay-Netzwerk (z. B. **flanell**), um eine Verbindung zu ihren Containeranwendungen herzustellen.

### Wie es geht…

In diesem Abschnitt werden wir die Eigenschaften von Kubernetes Meister und Nodes erklären; Beide erkennen die Hauptfunktionen des Kubernetes-Systems.

### Kubernetes Meister

Kubernetes-Master ist die Hauptkomponente des Kubernetes-Clusters. Es dient mehreren Funktionalitäten, wie die folgenden Elemente:

* Autorisierung und Authentifizierung

* RESTful API Einstiegspunkt

* Container-Deployment-Scheduler zu den Kubernetes-Nodes

* Skalierung und Replikation des Controllers

* Lesen und speichern Sie die Konfiguration

* Befehlszeilenschnittstelle

Das nächste Bild zeigt, wie Master-Dämonen zusammengearbeitet haben, um die genannten Funktionalitäten zu erfüllen:
![master-controller](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_02.jpg)

Es gibt mehrere Daemon-Prozesse, die die Funktionalität des Kubernetes-Masters wie **kube-apiserver**, **kube-scheduler** und **kube-controller-manager**. Hypercube Wrapper startet alle von ihnen.

Darüber hinaus kann die Kubernetes Command Line Interface `kubectl` die Kubernetes Master Funktionalität steuern.

### API-Server (kube-apiserver)

Der API-Server stellt eine HTTP- oder HTTPS-basierte RESTful API bereit, die der Hub zwischen Kubernetes-Komponenten wie kubectl, Scheduler, replication controller, etcd datastore und kubelet und kube-proxy ist, der auf Kubernetes-Nodes läuft und so weiter.

### Scheduler (kube-scheduler)

Scheduler hilft, zu wählen, welcher Container von welchen Knoten ausgeführt wird. Es ist ein einfacher Algorithmus, der die Priorität zum Versand und Binden von Containern an Nodes definiert, zum Beispiel:

* CPU

* Memory

* Wieviele container sind am Laufen


### Controller Manager (kube-controller-manager)

Controller Manager führt Cluster-Operationen durch. Beispielsweise:

* Verwaltet Kuvernetes-Knoten

* Erstellt und aktualisiert die internen Informationen von Kubernetes

* Versucht, den aktuellen Status in den gewünschten Status zu ändern


### Befehlszeilenschnittstelle (kubectl)

Nach der Installation von Kubernetes Master können Sie mit dem Kubernetes Command Line Interface kubectl den Kubernetes Cluster steuern. Zum Beispiel gibt `kubectl get cs `den Status jeder Komponente zurück. Auch `kubectl get nodes` gibt eine Liste der Kubernetes-Knoten zurück:
```
//see the ComponentStatuses
# kubectl get cs
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok                   nil
scheduler            Healthy   ok                   nil
etcd-0               Healthy   {"health": "true"}   nil

//see the nodes
# kubectl get nodes
NAME          LABELS                               STATUS    AGE
kub-node1   kubernetes.io/hostname=kub-node1   Ready     26d
kub-node2   kubernetes.io/hostname=kub-node2   Ready     26d
```

### Kubernetes nodes

Der Kubernetes-Knoten ist ein Slave-Knoten im Kubernetes-Cluster. Es wird von Kubernetes-Master gesteuert, um die Container-Anwendung mit Docker (http://docker.com) oder rkt (http://coreos.com/rkt/docs/latest/) in diesem Buch zu steuern. Wir verwenden die Docker-Container-Laufzeit als Standard-Engine.

### Tip
Node oder slave?
Die Terminologie des Slaves wird in der Computerindustrie verwendet, um den Cluster-Worker-Nodes darzustellen; Allerdings ist es auch mit Diskriminierung verbunden. Das Kubernetes-Projekt verwendet stattdessen Nodes.

Das folgende Bild zeigt die Rolle und Aufgaben von Daemon-Prozessen im Nodes:
![kubernetes-nodes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_03.jpg)

Der Node hat auch mehrere Daemon-Prozesse namens kubelet und kube-proxy, um seine Funktionalitäten zu unterstützen.

### Kubelet

Kubelet ist der Hauptprozess auf dem Kubernetes-Knoten, der mit dem Kubernetes-Master kommuniziert, um die folgenden Operationen zu bearbeiten:

* Periodisch Zugriff auf den API-Controller um zu überprüfen und zu berichten

* Führen Sie Container-Operationen durch

* Führt den HTTP-Server aus, um einfache APIs bereitzustellen


### Proxy (kube-proxy)

Proxy verarbeitet den Netzwerk-Proxy und den Load-Balancer für jeden Container. Es ändert sich, um die Linux-iptables-Regeln (nat-Tabelle) zu ändern, um TCP- und UDP-Pakete über die Container zu steuern.

Nach dem Start des `kube-proxy` Daemons wird er iptables-Regeln konfigurieren. Sie können sehen, `iptables -t nat -L` oder `iptables -t nat -S`, um die nat Tabelle Regeln wie folgt zu überprüfen:
```
 //the result will be vary and dynamically changed by kube-proxy
# sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-N DOCKER
-N FLANNEL
-N KUBE-NODEPORT-CONTAINER
-N KUBE-NODEPORT-HOST
-N KUBE-PORTALS-CONTAINER
-N KUBE-PORTALS-HOST
-A PREROUTING -m comment --comment "handle ClusterIPs; NOTE: this must be before the NodePort rules" -j KUBE-PORTALS-CONTAINER
-A PREROUTING -m addrtype --dst-type LOCAL -m comment --comment "handle service NodePorts; NOTE: this must be the last rule in the chain" -j KUBE-NODEPORT-CONTAINER
-A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
-A OUTPUT -m comment --comment "handle ClusterIPs; NOTE: this must be before the NodePort rules" -j KUBE-PORTALS-HOST
-A OUTPUT -m addrtype --dst-type LOCAL -m comment --comment "handle service NodePorts; NOTE: this must be the last rule in the chain" -j KUBE-NODEPORT-HOST
-A OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
-A POSTROUTING -s 192.168.90.0/24 ! -o docker0 -j MASQUERADE
-A POSTROUTING -s 192.168.0.0/16 -j FLANNEL
-A FLANNEL -d 192.168.0.0/16 -j ACCEPT
-A FLANNEL ! -d 224.0.0.0/4 -j MASQUERADE
```

### Wie es funktioniert…

Es gibt zwei weitere Komponenten, um die Funktionalitäten der Kubernetes-Nodes, den Datenspeicher usw. und den Overlay-Netzwerk-Flanell zu ergänzen. Sie können lernen, wie sie das Kubernetes-System in den folgenden Abschnitten umsetzen.

### etcd

Der etcd (https://coreos.com/etcd/) ist der verteilte key-value Datenspeicher. Es kann über die RESTful API zugegriffen werden, um den CRUD-Betrieb über das Netzwerk auszuführen. Kubernetes verwendet etcd als Hauptdatenspeicher.

Sie können die Kubernetes-Konfiguration und den Status in etcd (`/registry`) mit dem Befehl curl wie folgt ermitteln:
```
//example: etcd server is 10.0.0.1 and default port is 2379
# curl -L "http://10.0.0.1:2379/v2/keys/registry"

{"action":"get","node":{"key":"/registry","dir":true,"nodes":[{"key":"/registry/namespaces","dir":true,"modifiedIndex":15,"createdIndex":15},{"key":"/registry/serviceaccounts","dir":true,"modifiedIndex":16,"createdIndex":16},{"key":"/registry/services","dir":true,"modifiedIndex":17,"createdIndex":17},{"key":"/registry/ranges","dir":true,"modifiedIndex":76,"createdIndex":76},{"key":"/registry/nodes","dir":true,"modifiedIndex":740,"createdIndex":740},{"key":"/registry/pods","dir":true,"modifiedIndex":794,"createdIndex":794},{"key":"/registry/controllers","dir":true,"modifiedIndex":810,"createdIndex":810},{"key":"/registry/events","dir":true,"modifiedIndex":6,"createdIndex":6}],"modifiedIndex":6,"createdIndex":6}}

```

### Overlay-Netzwerk

Die Netzwerkkommunikation zwischen den Containern ist der schwierigste Teil. Denn wenn Sie den Docker starten, wird eine IP-Adresse dynamisch zugewiesen. Die Containeranwendung muss die IP-Adresse und die Portnummer des Peers kennen.

Wenn die Netzwerkkommunikation des Containers nur innerhalb des einzelnen Hosts liegt, können Sie den Docker-Link verwenden, um die Umgebungsvariable zu erzeugen, um den Peer zu entdecken. Allerdings arbeitet Kubernetes in der Regel als Cluster und Botschafter Muster oder Overlay-Netzwerk könnte dazu beitragen, jeden Knoten zu verbinden. Kubernetes nutzt das Overlay-Netzwerk, um die Kommunikation der verschiedenen Container zu verwalten.

Für Overlay-Netzwerk hat Kubernetes mehrere Möglichkeiten, aber mit Flanell ist die einfachere Lösung.

### Flanell

Flanell verwendet auch etcd, um die Einstellungen zu konfigurieren und den Status zu speichern. Sie können auch den Befehl `curl` ausführen, um die Konfiguration (`/coreos.com/network`) und den Status wie folgt zu erfahren:
```
//overlay network CIDR is 192.168.0.0/16
# curl -L "http://10.0.0.1:2379/v2/keys/coreos.com/network/config"

{"action":"get","node":{"key":"/coreos.com/network/config","value":"{ \"Network\": \"192.168.0.0/16\" }","modifiedIndex":144913,"createdIndex":144913}}

//Kubernetes assigns some subnets to containers
# curl -L "http://10.0.0.1:2379/v2/keys/coreos.com/network/subnets"

{"action":"get","node":{"key":"/coreos.com/network/subnets","dir":true,"nodes":[{"key":"/coreos.com/network/subnets/192.168.90.0-24","value":"{\"PublicIP\":\"10.97.217.158\"}","expiration":"2015-11-05T08:16:21.995749971Z","ttl":38993,"modifiedIndex":388599,"createdIndex":388599},{"key":"/coreos.com/network/subnets/192.168.76.0-24","value":"{\"PublicIP\":\"10.97.217.148\"}","expiration":"2015-11-05T04:32:45.528111606Z","ttl":25576,"modifiedIndex":385909,"createdIndex":385909},{"key":"/coreos.com/network/subnets/192.168.40.0-24","value":"{\"PublicIP\":\"10.97.217.51\"}","expiration":"2015-11-05T15:18:27.335916533Z","ttl":64318,"modifiedIndex":393675,"createdIndex":393675}],"modifiedIndex":79,"createdIndex":79}}
```

### Siehe auch

Dieser Abschnitt beschreibt die grundlegende Architektur und Methodik von Kubernetes und verwandten Komponenten. Das Verständnis von Kubernetes ist nicht einfach, aber eine Schritt-für-Schritt-Lektion zum Einrichten, Konfigurieren und Verwalten von Kubernetes macht Spaß.

Die folgenden Rezepte beschreiben die Installation und Konfiguration von verwandten Komponenten:

* Erstellen des Datastors

* Erstellen eines Overlay-Netzwerks

* Master konfigurieren

* Konfigurieren von Nodes

