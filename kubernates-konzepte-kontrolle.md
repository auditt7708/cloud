Die Arbeit mit Kubernetes ist ganz einfach, entweder mit Command Line Interface (CLI) oder API (RESTful). In diesem Abschnitt wird die Kubernetes-Steuerung von CLI beschrieben. Die CLI, die wir in diesem Kapitel verwendet haben, ist Version 1.1.3.
Fertig werden

Nachdem Sie den Kubernetes-Master installiert haben, können Sie einen Befehl kubectl wie folgt ausführen. Es zeigt die kubectl und Kubernetes Master Versionen (beide 1.1.3).

```
% kubectl version
Client Version: version.Info{Major:"1", Minor:"1", GitVersion:"v1.1.3", GitCommit:"6a81b50c7e97bbe0ade075de55ab4fa34f049dc2", GitTreeState:"clean"}
Server Version: version.Info{Major:"1", Minor:"1", GitVersion:"v1.1.3", GitCommit:"6a81b50c7e97bbe0ade075de55ab4fa34f049dc2", GitTreeState:"clean"}

```

### Wie es geht…

Kubectl verbindet den Kubernetes API Server mit RESTful API. Standardmäßig versucht es, auf den localhost zuzugreifen, sonst müssen Sie die API-Serveradresse mit dem Parameter --server angeben. Daher empfiehlt es sich, kubectl auf der API-Server-Maschine für die Praxis zu verwenden.

### Tip

Wenn Sie kubectl über das Netzwerk verwenden, müssen Sie die Authentifizierung und Autorisierung für den API-Server berücksichtigen. Siehe Kapitel 7, Erweiterte Clusterverwaltung.

### Wie es funktioniert…

Kubectl ist der einzige Befehl für Kubernetes-Cluster und steuert den Kubernetes-Cluster-Manager. Weitere Informationen finden Sie unter http://kubernetes.io/docs/user-guide/kubectl-overview/. Jeder Container- oder Kubernetes-Clusterbetrieb kann durch einen Befehl kubectl ausgeführt werden.

Darüber hinaus erlaubt kubectl die Eingabe von Informationen entweder über die optionalen Argumente der Befehlszeile oder über die Datei (use -f option), aber es wird dringend empfohlen, die Datei zu verwenden, da Sie den Kubernetes-Cluster als Code pflegen können:
`kubectl [command] [TYPE] [NAME] [flags]`

Die Attribute des vorhergehenden Befehls werden wie folgt erklärt:

* `command`: Gibt die Operation an, die Sie auf einer oder mehreren Ressourcen ausführen möchten.

* `TYPE`: Gibt den Ressourcentyp an. Bei Ressourcentypen wird zwischen Groß- und Kleinschreibung unterschieden, und Sie können die singulären, plural- oder abgekürzten Formulare angeben.

* `NAME`: Gibt den Namen der Ressource an. Bei Namen wird die Groß- / Kleinschreibung beachtet. Wenn der Name weggelassen wird, werden Details für alle Ressourcen angezeigt.

* `flags`: Gibt optionale Flags an.

Wenn Sie beispielsweise nginx starten möchten, können Sie den Befehl `kubectl run` wie folgt verwenden:
```
# /usr/local/bin/kubectl run my-first-nginx --image=nginx
replicationcontroller "my-first-nginx" 
```

Allerdings können Sie entweder eine YAML-Datei oder eine JSON-Datei schreiben, um ähnliche Operationen auszuführen. Zum Beispiel ist das YAML-Format wie folgt:
```
# cat nginx.yaml 
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-first-nginx
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: my-first-nginx
        image: nginx

```
Geben Sie dann die Option create `-f` an, um den Befehl `kubectl` wie folgt auszuführen:
```
# kubectl create -f nginx.yaml 
replicationcontroller "my-first-nginx" created
```

Wenn Sie den Status des replication controller sehen möchten, geben Sie den Befehl `kubectl get` wie folgt ein:
```
# kubectl get replicationcontrollers 
CONTROLLER       CONTAINER(S)     IMAGE(S)   SELECTOR    REPLICAS   AGE
my-first-nginx   my-first-nginx   nginx      app=nginx   1          12s
```
Wenn Sie auch die Abkürzung für die Unterstützung wünschen, geben Sie Folgendes ein:

```
# kubectl get rc
CONTROLLER       CONTAINER(S)     IMAGE(S)   SELECTOR    REPLICAS   AGE
my-first-nginx   my-first-nginx   nginx      app=nginx   1          1m
```
Wenn Sie diese Ressourcen löschen möchten, geben Sie den Befehl `kubectl delete` wie folgt ein:
```
# kubectl delete rc my-first-nginx
replicationcontroller "my-first-nginx" deleted
```

Der Befehl `kubectl` unterstützt viele Arten von Unterbefehlen, verwenden Sie die Option `-h`, um die Details zu sehen, zum Beispiel:
```
//display whole sub command options
# kubectl -h

//display sub command "get" options
# kubectl get -h

//display sub command "run" options
# kubectl run -h

```
