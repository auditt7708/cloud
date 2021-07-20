---
title: kubernetes-konzepte-pods
description: 
published: true
date: 2021-06-09T15:33:37.972Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:33:32.576Z
---

Die Pod ist eine Gruppe von einem oder mehreren Containern und die kleinste einsetzbare Einheit in Kubernetes. Pods sind immer zusammengelegt und koordiniert und laufen in einem gemeinsamen Kontext. Jeder Pod wird von folgenden Linux-Namespaces isoliert:

* Prozess-ID (PID) Namespace

* Netzwerk-Namespace

* Interprocess Communication (IPC) Namespace

* Unix Time Sharing (UTS) Namespace

In einer Welt vor Containern wären sie auf der gleichen physischen oder virtuellen Maschine ausgeführt worden sein.

Es ist sinnvoll, einen eigenen Anwendungsstapel-Pod (z. B. Webserver und Datenbank) zu erstellen, der mit verschiedenen Docker-Images gemischt wird.

### Fertig werden

Sie müssen einen Kubernetes-Cluster haben und sicherstellen, dass der Kubernetes-Knoten Zugriff auf den Docker Hub (https://hub.docker.com) hat, um Docker-images herunterzuladen. Sie können das Herunterladen eines Docker-Images mithilfe des Docker-Pull-Befehls wie folgt simulieren:
```
//run as root on node machine

# docker pull centos
latest: Pulling from centos

47d44cb6f252: Pull complete 
168a69b62202: Pull complete 
812e9d9d677f: Pull complete 
4234bfdd88f8: Pull complete 
ce20c473cd8a: Pull complete 
Digest: sha256:c96eeb93f2590858b9e1396e808d817fa0ba4076c68b59395445cb957b524408
Status: Downloaded newer image for centos:latest

```
### Wie es geht…

1. Melden Sie sich bei der Kubernetes-Mastermaschine an und bereiten Sie die folgende YAML-Datei vor. Es definiert den Start-Nginx-Container und den CentOS-Container.

2. Der nginx-Container öffnet den HTTP-Port (TCP / 80). Auf der anderen Seite versucht der CentOS-Container, auf den `localhost:80` zuzugreifen alle drei Sekunden mit dem `curl`-Befehl:
```
# cat my-first-pod.yaml 

apiVersion: v1
kind: Pod
metadata:
  name: my-first-pod
spec:
  containers:
  - name: my-nginx
    image: nginx
  - name: my-centos
    image: centos
    command: ["/bin/sh", "-c", "while : ;do curl http://localhost:80/; sleep 3; done"]
```

3. Dann führen Sie den Befehl `kubectl create` aus, um `my-first-pod` wie folgt zu starten:
```
# kubectl create -f my-first-pod.yaml 
pod "my-first-pod" created
```

Es dauert zwischen ein paar Sekunden und Minuten, abhängig von der Netzwerkbandbreite zum Docker Hub und Kubernetes nodes spec.

4. Sie können kubectl get pods überprüfen, um den Status wie folgt zu sehen:
```
//still downloading Docker images (0/2)
# kubectl get pods
NAME           READY     STATUS    RESTARTS   AGE
my-first-pod   0/2       Running   0          6s

//it also supports shorthand format as "po"
# kubectl get po
NAME           READY     STATUS    RESTARTS   AGE
my-first-pod   0/2       Running   0          7s


//my-first-pod is running (2/2)

# kubectl get pods
NAME           READY     STATUS    RESTARTS   AGE
my-first-pod   2/2       Running   0          8s

```
Nun sind sowohl der nginx-Container (my-nginx) als auch der CentOS-Container (my-centos) fertig.

5. Prüfen Sie, ob der CentOS-Container auf nginx zugreifen kann oder nicht. Sie können die Stdout (Standardausgabe) mit dem Befehl kubectl logs und unter Angabe des CentOS-Containers (my-centos) wie folgt überprüfen:
```
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   612  100   612    0     0   4059      0 --:--:-- --:--:-- --:--:--  4080
```
Wie Sie sehen können, verbindet der Pod zwei verschiedene Container, Nginx und CentOS in denselben Linux-Namespace.

### Wie es funktioniert…

Beim Starten eines Pods schickt der Kubernetes-Scheduler den Kubelet-Prozess ab, um alle Operationen abzuschließen, um sowohl Nginx- als auch CentOS-Container zu starten.

Wenn Sie zwei oder mehr Nodes haben, können Sie die `-o wide` Option überprüfen, um einen Knoten zu finden, der einen Pod ausführt:

```
//it indicates Node ip-10-96-219-25 runs my-first-pod

# kubectl get pods -o wide
NAME           READY     STATUS    RESTARTS   AGE       NODE
my-first-pod   2/2       Running   0          2m        ip-10-96-219-25
```

Melden Sie sich bei diesem Node an, dann können Sie mir den Befehl `docker ps `überprüfen, um die laufenden Container wie folgt zu sehen:
```
# docker ps
CONTAINER ID        IMAGE                                  COMMAND                CREATED             STATUS              PORTS               NAMES
b7eb8d0925b2        centos                                 "/bin/sh -c 'while :   2 minutes ago       Up 2 minutes                            k8s_my-centos.704bf394_my-first-pod_default_a3b78651-a061-11e5-a7fb-06676ae2a427_f8b61e2b   
55d987322f53        nginx                                  "nginx -g 'daemon of   2 minutes ago       Up 2 minutes                            k8s_my-nginx.608bdf36_my-first-pod_default_a3b78651-a061-11e5-a7fb-06676ae2a427_10cc491a    
a90c8d2d40ee        gcr.io/google_containers/pause:0.8.0   "/pause"               2 minutes ago       Up 2 minutes                            k8s_POD.6d00e006_my-first-pod_default_a3b78651-a061-11e5-a7fb-06676ae2a427_dfaf502a        

```
Sie können feststellen, dass drei Container - CentOS, Nginx und Pause - anstelle von zwei laufen. Denn jeder Pod, den wir halten müssen, gehört zu einem bestimmten Linux-Namespace, wenn sowohl die CentOS- als auch die Nginx-Container gelöscht, wird auch der Namespace gelöscht. Daher bleibt der Pause-Container gerade im Pod, um Linux-Namespaces zu pflegen.

Lassen Sie uns einen zweiten Pod starten, benennen Sie ihn mit `my-second-pod` und führen Sie den Befehl `kubectl create` wie folgt aus:

```
//just replace the name from my-first-pod to my-second-pod

# cat my-first-pod.yaml | sed -e 's/my-first-pod/my-second-pod/' > my-second.pod.yaml

# cat my-second.pod.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: my-second-pod
spec:
  containers:
  - name: my-nginx
    image: nginx
  - name: my-centos
    image: centos
    command: ["/bin/sh", "-c", "while : ;do curl http://localhost:80/; sleep 3; done"]

# kubectl create -f my-second.pod.yaml 
pod "my-second-pod" created

# kubectl get pods
NAME            READY     STATUS    RESTARTS   AGE
my-first-pod    2/2       Running   0          49m
my-second-pod   2/2       Running   0          5m

```

Wenn du zwei oder mehr Nodes hast, wurde `my-second-pod` wahrscheinlich von einem anderen Knoten gestartet, weil der Kubernetes Scheduler den am besten geeigneten Node gewählt hat.

### Tip

Beachten Sie, dass, wenn Sie möchten, dass mehr von dem gleichen Pod bereitstellen, sollten Sie stattdessen einen replication controller verwenden.

Nach dem Testen kannst du den Befehl `kubectl delete` ausführen, um deinen Pod aus dem Kubernetes-Cluster zu löschen:
```
//running both my-first-pod and my-second-pod
# kubectl get pods
NAME            READY     STATUS    RESTARTS   AGE
my-first-pod    2/2       Running   0          49m
my-second-pod   2/2       Running   0          5m


//delete my-second-pod
# kubectl delete pod my-second-pod
pod "my-second-pod" deleted
# kubectl get pods
NAME           READY     STATUS    RESTARTS   AGE
my-first-pod   2/2       Running   0          54m


//delete my-first-pod
# kubectl delete pod my-first-pod
pod "my-first-pod" deleted
# kubectl get pods
NAME      READY     STATUS    RESTARTS   AGE

```

