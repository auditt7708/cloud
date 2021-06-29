---
title: kubernetes-adv-advanced-kubeconfig
description: 
published: true
date: 2021-06-09T15:29:16.502Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:29:11.071Z
---

Kubeconfig ist eine Konfigurationsdatei zur Verwaltung von Cluster-, Kontext- und Authentifizierungseinstellungen in Kubernetes. Mit der Datei kubeconfig können wir verschiedene Cluster-Anmeldeinformationen, Benutzer und Namespaces festlegen, um zwischen Clustern oder Kontexten innerhalb eines Clusters umzuschalten. Es kann über die Befehlszeile mit dem Unterbefehl `kubectl config` oder einer Konfigurationsdatei direkt konfiguriert werden. In diesem Abschnitt werden wir beschreiben, wie man `kubectl config` verwendet, um kubeconfig zu manipulieren und wie man eine kubeconfig Datei direkt eingibt.

### Fertig werden

Bevor Sie beginnen, die kubeconfig zu ändern, sollten Sie genau wissen, was die Sicherheitsrichtlinien sind. Mit `kubectl config view` können Sie Ihre aktuellen Einstellungen überprüfen:
```
// check current kubeconfig file
# kubectl config view
apiVersion: v1
clusters: []
contexts: []
current-context: ""
kind: Config
preferences: {}
users: []
```

Wir können derzeit sehen, dass wir keine spezifischen Einstellungen in kubeconfig haben.

### Wie es geht…

Angenommen, wir haben zwei Cluster, eine ist unter localhost `http://localhost:8080` und eine andere ist Remote der `http://remotehost:8080` namens `remotehost`. Im Beispiel verwenden wir localhost als Hauptkonsole, um den Cluster über Kontextänderungen zu wechseln. Wir führen dann eine andere Anzahl von Nginx in beide Cluster und stellen Sie sicher, dass die Pods alle laufen:
```
// in localhost cluster
# kubectl run localnginx --image=nginx --replicas=2 --port=80
replicationcontroller "localnginx" created
// check pods are running
# kubectl get pods
NAME               READY     STATUS        RESTARTS   AGE
localnginx-1blru   1/1       Running       0          1m
localnginx-p6cyo   1/1       Running       0          1m

// in remotehost cluster
# kubectl run remotenginx --image=nginx --replicas=4 --port=80
replicationcontroller "remotenginx" created
// check pods are running
# kubectl get pods
NAME                READY     STATUS    RESTARTS   AGE
remotenginx-6wz5c   1/1       Running   0          1m
remotenginx-7v5in   1/1       Running   0          1m
remotenginx-c7go6   1/1       Running   0          1m
remotenginx-r1mf6   1/1       Running   0          1m
```
### Ein neues Anmeldeinformationen anlegen

Zuerst werden wir für jeden Cluster zwei Anmeldeinformationen einrichten. Verwenden Sie `kubectl config set-credentials <nickname>` zum Hinzufügen von Anmeldeinformationen in kubeconfig. Es gibt verschiedene Authentifizierungsmethoden, die in Kubernetes unterstützt werden. Wir könnten ein Passwort, ein Client-Zertifikat oder ein Token verwenden. Im Beispiel verwenden wir die HTTP-Basisauthentifizierung zur Vereinfachung des Szenarios. Kubernetes unterstützt auch Client-Zertifikat und Token-Authentifizierung. Weitere Informationen finden Sie auf der kubeconfig-Set-Credential-Seite: http://kubernetes.io/docs/user-guide/kubectl/kubectl_config_set-credentials:
```
// in localhost cluster, add a user `userlocal` with nickname localhost/myself
#  kubectl config set-credentials localhost/myself --username=userlocal --password=passwordlocal
user "localhost/myself" set.	

// in localhost cluster, add a user `userremote` with nickname remotehost/myself
#  kubectl config set-credentials remotehost/myself --username=userremote --password=passwordremote
user "remotehost/myself" set.
```
Schauen wir uns die aktuelle Ansicht an:
```
# kubectl config view
apiVersion: v1
clusters: []
contexts: []
current-context: ""
kind: Config
preferences: {}
users:
- name: localhost/myself
  user:
    password: passwordlocal
    username: userlocal
- name: remotehost/myself
  user:
    password: passwordremote
    username: userremote
```

Wir können derzeit folgendes vorfinden, dass wir zwei Sätze von Anmeldeinformationen mit Spitznamen `localhost/myself` und `remotehost/myself` haben. Als nächstes setzen wir die Cluster in das Management.

### Einstellen eines neuen Clusters

Um einen neuen Cluster zu setzen, benötigen wir den Befehl `kubectl config set-cluster <nickname>`. Wir benötigen den Parameter `--server` für den Zugriff auf den Cluster. Wenn Sie `-insecure-skip-tls-verify` hinzufügen, wird das Zertifikat des Servers nicht überprüft. Wenn Sie einen vertrauenswürdigen Server mit HTTPS einrichten, müssen Sie `-insecure-skip-tls-verify` auf `--certificate-authority=$PATH_OF_CERT` `--embed-certs=true` ersetzen. Weitere Informationen finden Sie auf der Seite kubeconfig set-cluster: http://kubernetes.io/docs/user-guide/kubectl/kubectl_config_set-cluster:

```
// in localhost cluster: add http://localhost:8080 as localhost
# kubectl config set-cluster localhost --insecure-skip-tls-verify=true --server=http://localhost:8080
cluster "localhost" set.

// in localhost cluster: add http://remote:8080 as localhost
# kubectl config set-cluster remotehost --insecure-skip-tls-verify=true --server=http://remotehost:8080
cluster "remotehost" set.
```

Schauen wir uns jetzt die aktuelle Konfiguration an. Die Einstellung entspricht genau dem, was wir eingestellt haben:
```
// check current view
# kubectl config view
apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: http://localhost:8080
  name: localhost
- cluster:
    insecure-skip-tls-verify: true
    server: http://remotehost:8080
  name: remotehost
contexts: []
current-context: ""
kind: Config
preferences: {}
users:
- name: localhost/myself
  user:
    password: passwordlocal
    username: userlocal
- name: remotehost/myself
  user:
    password: passwordremote
    username: userremote
```
Beachten Sie, dass wir noch nichts zwischen Benutzern und Clustern verknüpft haben. Wir werden sie über den Kontext verknüpfen.

### Einstellen und Ändern des aktuellen Kontextes

Ein Kontext enthält einen Cluster, einen Namensraum und einen Benutzer. `Kubectl` verwendet die angegebene Benutzerinformation und den Namensraum, um Anfragen an den Cluster zu senden. Um einen Kontext einzurichten, verwenden wir `kubectl config set-context <context nickname> --user = <user nickname> --namespace = <namespace> --cluster = <cluster nickname>`, um es zu erstellen:
```
// in localhost cluster: set a context named default/localhost/myself for localhost cluster
# kubectl config set-context default/localhost/myself --user=localhost/myself --namespace=default --cluster=localhost
context "default/localhost/myself" set.

// in localhost cluster: set a context named default/remotehost/myself for remotehost cluster
# kubectl config set-context default/remotehost/myself --user=remotehost/myself --namespace=default --cluster=remotehost
context "default/remotehost/myself" set.
```
Schauen wir uns die aktuelle Ausgabe an. Wir können jetzt, eine Liste von Kontexten in dem Kontext Abschnitt sehen :
```
# kubectl config view
apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: http://localhost:8080
  name: localhost
- cluster:
    insecure-skip-tls-verify: true
    server: http://remotehost:8080
  name: remotehost
contexts:
- context:
    cluster: localhost
    namespace: default
    user: localhost/myself
  name: default/localhost/myself
- context:
    cluster: remotehost
    namespace: default
    user: remotehost/myself
  name: default/remotehost/myself
current-context: ""
kind: Config
preferences: {}
users:
- name: localhost/myself
  user:
    password: passwordlocal
    username: userlocal
- name: remotehost/myself
  user:
    password: passwordremote
    username: userremote

```

Nach dem Erstellen von Kontexten, beginnen wir, Kontext zu wechseln, um verschiedene Cluster zu verwalten. Hier verwenden wir den Befehl `kubectl config use-context <context spickname>`. Wir beginnen am lokalhost:

```
// in localhost cluster: use the context default/localhost/myself
# kubectl config use-context default/localhost/myself
switched to context "default/localhost/myself".
```

Lassen Sie uns Pods, um zu sehen, ob es ein localhost Cluster ist:

```
// list the pods
# kubectl get pods
NAME               READY     STATUS        RESTARTS   AGE
localnginx-1blru   1/1       Running       0          1m
localnginx-p6cyo   1/1       Running       0          1m
```

Ja, es sieht gut aus Wie wäre es, wenn wir in den Kontext mit der Remotehost-Einstellung wechseln?
```
// in localhost cluster: switch to the context default/remotehost/myself
# kubectl config use-context default/remotehost/myself
switched to context "default/remotehost/myself". 
Let's list the pods to make sure it's under the remotehost context:
# kubectl get pods
NAME                READY     STATUS    RESTARTS   AGE
remotenginx-6wz5c   1/1       Running   0          1m
remotenginx-7v5in   1/1       Running   0          1m
remotenginx-c7go6   1/1       Running   0          1m
remotenginx-r1mf6   1/1       Running   0          1m

```

Alle Operationen, die wir gemacht haben, sind im localhost-Cluster. Kubeconfig macht das Umschalten mehrerer Cluster mit mehreren Benutzern einfacher.

### Aufräumen von kubeconfig

Die Datei kubeconfig wird in `$HOME/.kube/config` gespeichert. Wenn die Datei gelöscht wird, ist die Konfiguration weg; Wenn die Datei in das Verzeichnis wiederhergestellt wird, wird auch die Konfiguration wiederhergestellt:
```
// clean up kubeconfig file
# rm -f ~/.kube/config

// check out current view
# kubectl config view
apiVersion: v1
clusters: []
contexts: []
current-context: ""
kind: Config
preferences: {}
users: []

```
