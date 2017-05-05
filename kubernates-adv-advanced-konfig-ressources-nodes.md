Das Rechenressourcenmanagement ist in jeder Infrastruktur so wichtig. Wir sollten unsere Anwendung gut kennen und genügend CPU und Speicherkapazität bewahren, um das Auslaufen von Ressourcen zu verhindern. In diesem Abschnitt stellen wir vor, wie man die Nodeskapazität in den Kubernetes-Nodes verwaltet. Darüber hinaus werden wir auch beschreiben, wie man pod-Computing-Ressourcen verwaltet.

### Fertig werden

Bevor Sie mit der Verwaltung von Rechenressourcen beginnen, sollten Sie Ihre Anwendungen gut kennen, um die maximalen Ressourcen zu kennen, die sie benötigen. Bevor wir anfangen, schauen Sie sich die aktuelle Nodeskapazität mit dem Befehl `kubectl ` an, der in>[Richte dein eigenes Kubernates ein](../kubernates-einrichten) beschrieben ist:
````
// check current node capacity
# kubectl get nodes -o json | jq '.items[] | {name: .metadata.name, capacity: .status.capacity}'
{
  "name": "kube-node1",
  "capacity": {
    "cpu": "1",
    "memory": "1019428Ki",
    "pods": "40"
  }
}
{
  "name": "kube-node2",
  "capacity": {
    "cpu": "1",
    "memory": "1019428Ki",
    "pods": "40"
  }
}
```

Sie sollten derzeit wissen, wir haben zwei Knoten mit `1` CPU und `1019428` Bytes Speicher. Die Knotenkapazität der Pods beträgt jeweils 40. Dann können wir mit der Planung beginnen. Wie viel Rechenressourcen können auf einem Nodeverwendet werden? Wie viel Rechenressource wird bei der Durchführung unserer Container verwendet?

### Wie es geht…

Wenn der Kubernetes-Scheduler einen Pod plant, der auf einem Node läuft, wird immer sichergestellt, dass die Gesamtgrenzen der Container kleiner sind als die Knotenkapazität. Wenn ein Node keine Ressourcen mehr hat, wird Kubernetes keine neuen Container planen. Wenn kein Node verfügbar ist, wenn Sie einen Pod starten, bleibt der Pod anhängig, da der Kubernetes-Scheduler keinen Node finden kann, der Ihren gewünschten Pod ausführen könnte.

### Verwalten der Knotenkapazität

Manchmal wollen wir explizit einige Ressourcen für andere Prozesse oder zukünftige Nutzung auf dem Node bewahren. Nehmen wir an, wir wollen 200 MB auf allen meinen Nodes bewahren. Zuerst müssen wir einen Pod erstellen und den `pause` Container in Kubernetes laufen lassen. `Pause `ist ein Container für jeden Pod für die Weiterleitung des traffics. In diesem Szenario erstellen wir einen Resource Reserver Pod, der grundsätzlich nichts mit einem Limit von 200 MB macht:
````
// configuration file for resource reserver
# cat /etc/kubernetes/reserve.yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-reserver
spec:
  containers:
  - name: resource-reserver
    image: gcr.io/google_containers/pause:0.8.0
    resources:
      limits:
        memory: 200Mi
```

Da es sich um einen Pod Infra Container handelt, werden wir nicht kubectl verwenden, um es zu starten. Beachten Sie, dass wir es in den Ordner / etc / kubernetes / Sie könnten es unter verschiedene Wege stellen; Notiere den Pfad und wir müssen ihn in die Kubelet-Konfigurationsdatei hinzufügen, um ihn zu starten. Finden Sie die Kubelet-Konfigurationsdatei, die Sie im Konfigurationsknoten Rezept in> Kapitel 1, Erstellen eigener Kubernetes angegeben haben, und fügen Sie beim Start von kubelet das folgende Argument hinzu: --config = / etc / kubernetes / reserve.yaml. Kubelet neu starten Nachdem wir Kubelet neu gestartet haben, sehen wir das Kubelet-Log im Knoten:
```
I0325 20:44:22.937067   21306 kubelet.go:1960] Starting kubelet main sync loop.
I0325 20:44:22.937078   21306 kubelet.go:2012] SyncLoop (ADD): "resource-reserver-kube-node1_default"
I0325 20:44:22.937138   21306 kubelet.go:2012] SyncLoop (ADD): "mynginx-e09bu_default"
I0325 20:44:22.963425   21306 kubelet.go:2012] SyncLoop (ADD): "resource-reserver-kube-node1_default"
I0325 20:44:22.964484   21306 manager.go:1707] Need to restart pod infra container for "resource-reserver-kube-node1_default" because it is not found
```

Kubelet prüft, ob der Infra-Container existiert und entsprechend erstellt wurde:
```
// check pods list
# kubectl get pods
NAME                             READY     STATUS    RESTARTS   AGE
resource-reserver-kube-node1   1/1       Running   0          3m
```

Der Kubernetes-Master ist sich bewusst, dass der Ressourcen-Reserver-Pod erstellt wurde. Lassen Sie uns die Details beschreiben, um tieferen Einblick zu bekommen:

```
# kubectl describe pods resource-reserver-kube-node1
Name:        resource-reserver-kube-node1
Namespace:      default
Image(s):      gcr.io/google_containers/pause:0.8.0
Node:        kube-node1/10.0.0.224
Start Time:      Fri, 25 Mar 2016 20:44:24 +0000
Labels:        <none>
Status:        Running
IP:        192.168.99.3
Replication Controllers:  <none>
Containers:
  resource-reserver:
    ...
    QoS Tier:
      memory:  Guaranteed
    Limits:
      memory:  200Mi
    Requests:
      memory:    200Mi
    State:    Running
      Started:    Fri, 25 Mar 2016 20:44:24 +0000
    Ready:    True
```

Wir finden die Grenzen und Anfragen, die alle als `200Mi` gesetzt sind; Es bedeutet, dass dieser Container mindestens 200 MB und maximal 200 MB reserviert wurde. Wiederholen Sie die gleichen Schritte in Ihren anderen Knoten und überprüfen Sie den Status über den Befehl `kubectl`:
```
# kubectl get pods
NAME                             READY     STATUS    RESTARTS   AGE
resource-reserver-kube-node1   1/1       Running   0          11m
resource-reserver-kube-node2   1/1       Running   0          42m
```

###### Notiz
Grenzen oder Wünsche?

Der Kubernetes-Scheduler plant einen Pod, der auf einem Knoten läuft, indem er die verbleibenden Rechenressourcen überprüft. Wir könnten die Grenzen oder Anfragen für jeden Pod, den wir starten, angeben. Limit bedeutet die maximale Ressourcen, die dieser Pod einnehmen kann. Anforderung bedeutet die minimalen Ressourcen, die dieser Pod benötigt. Wir könnten die folgende Ungleichung verwenden, um ihre Beziehung darzustellen: 0 <= request <= die Ressource dieser Pod belegt <= limit <= Knotenkapazität.

### Verwalten von Rechenressourcen in einem Pod

Das Konzept für die Verwaltung der Kapazität in einem Pod oder Nodeist ähnlich. Sie spezifizieren die Anfragen oder Grenzen unter der Containerressourcenspezifikation.

Lassen Sie uns einen Nginx-Pod mit bestimmten Anfragen und Grenzen mit kubectl erstellen -f nginx-resources.yaml, um es zu starten:

```
# cat nginx-resources.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
    resources:
      requests:
        cpu: 250m
        memory: 32Mi
      limits:
        cpu: 500m
        memory: 64Mi

// create the pod
# kubectl create -f nginx-resources.yaml 
pod "nginx" created
```

Im Folgenden sind die verfügbaren Ressourcen für diese Pod Beschrieben:

* CPU:  250 milli core ~ 500 milli core
* Arbeitsspeicher:  32MB ~ 64 MB

Bitte beachten Sie, dass die minimale CPU-Grenze auf 10 Millicore eingestellt ist. Sie können keinen Wert mehr als die Mindestgrenze angeben. Lassen Sie uns weitere Details über kubectl erhalten:

```
# kubectl describe pod nginx
Name:        nginx
Namespace:      default
Image(s):      nginx
Node:        kube-node1/10.0.0.224
Start Time:      Fri, 25 Mar 2016 21:12:43 +0000
Labels:        name=nginx
Status:        Running
Reason:
Message:
IP:        192.168.99.4
Replication Controllers:  <none>
Containers:
  nginx:
    ...
    QoS Tier:
      cpu:  Burstable
      memory:  Burstable
    Limits:
      memory:  64Mi
      cpu:  500m
    Requests:
      cpu:    250m
      memory:    32Mi
    State:    Running
      Started:    Fri, 25 Mar 2016 21:12:44 +0000
    Ready:    True
    Restart Count:  0
```

Alles wird erwartet QoS Tier ist `Burstable`. Im Vergleich zu `Guaranteed` hat `Burstable` einen Puffer, um an die Grenzen zu gelangen; Allerdings wird `Guaranteed` für die Pod immer bestimmte Ressourcen reservieren. Bitte beachten Sie, dass, wenn Sie zu viele Pods mit `Guaranteed` angeben, die Clusterauslastung schlecht wäre, da sie die Ressourcen verschwendet, wenn die Container die Grenzen nicht immer erreichen.
