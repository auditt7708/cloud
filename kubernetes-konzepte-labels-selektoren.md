---
title: kubernetes-konzepte-labels-selektoren
description: 
published: true
date: 2021-06-09T15:33:14.387Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:33:08.943Z
---

Labels sind ein Satz von Schlüssel/Wert Paaren, die an Objektmetadaten angehängt sind. Wir könnten Label verwenden, um Objekte wie Pods, replication controller und Services auszuwählen, zum organisieren und zum gruppieren. labels sind nicht unbedingt einmalig. Gegenstände könnten die gleichen Labels tragen.

Label selektoren werden verwendet, um Objekte über Etiketten abzufragen. Die aktuell unterstützten Selektionstypen sind:

* Gleichheits basierter Label selektor
* Set-based label selector
* Leerer label selektor
* Null-Label-Selektor

Ein gleichheits basierter Label selektor ist ein Satz von Gleichheitsanforderungen, die label durch gleicher oder nicht gleicher Vorgang filtern können. Ein Set-basierter Label-Selektor wird verwendet, um Label durch einen Satz von Werten zu filtern, und unterstützt derzeit `in` und `notin` Operatoren. Wenn ein Labelwert mit den Werten des Operators `in` übereinstimmt, wird er vom Selektor zurückgegeben. Umgekehrt, wenn ein Label-Wert nicht mit den Werten im `notin`-Operator übereinstimmt, wird er zurückgegeben. Leere Label selektoren auswählen alle Objekte und Null-Label wählen keine Objekte aus. Selektoren sind kombinierbar. Kubernetes wird die Objekte zurückgeben, die allen Anforderungen in Selektoren entsprechen.

### Fertig werden

Bevor Sie labels in die Objekte setzen, sollten Sie die gültige Namenskonvention von Schlüssel und Wert berücksichtigen.

Ein gültiger Schlüssel sollte diesen Regeln folgen:

* Ein Name mit einem optionalen Präfix, getrennt durch einen Schrägstrich.
* Ein Präfix muss eine DNS-Subdomain sein, die durch Punkte getrennt ist, nicht länger als 253 Zeichen.
* Ein Name muss weniger als 63 Zeichen mit der Kombination von [a-z0-9A-Z] und Bindestrichen, Unterstrichen und Punkten sein. Beachten Sie, dass Symbole illegal sind, wenn Sie am Anfang oder/und am Ende.

Ein gültiger Wert sollte den folgenden Regeln folgen:

* Ein Name muss weniger als 63 Zeichen mit der Kombination von [a-z0-9A-Z] und Bindestrichen, Unterstrichen und Punkten sein. Beachten Sie, dass Symbole illegal sind, wenn Sie am Anfang und/oder am Ende.

Sie sollten auch den Zweck betrachten. Zum Beispiel haben wir einen Service im Pilotprojekt unter verschiedenen Entwicklungsumgebungen, die mehrere Ebenen enthalten. Dann könnten wir unsere Labels folgender maßen machen:

* `project: Pilot`
* `environment: development`, `environment: staging`, `environment: production`
* `tier: Frontend`, `tier: Backend`

### Wie es geht…

Lassen Sie uns versuchen, eine Nginx-Pod mit den vorherigen Labels in beiden staging und Produktions umgebung zu erstellen:

1. Wir schaffen das gleiche staging für Pod und Produktion wie die für die Replikation Controller (RC):
```
# cat staging-nginx.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    project: pilot
    environment: staging
    tier: frontend
spec:
  containers:
    -
      image: nginx
      imagePullPolicy: IfNotPresent
      name: nginx
      ports:
      - containerPort: 80

// create the pod via configuration file
# kubectl create -f staging-nginx.yaml
pod "nginx" created

```

2. Sehen wir die Details der Pod:
```
# kubectl describe pod nginx
Name:        nginx
Namespace:      default
Image(s):      nginx
Node:        ip-10-96-219-231/
Start Time:      Sun, 27 Dec 2015 18:12:31 +0000
Labels:        environment=staging,project=pilot,tier=frotend
Status:        Running
...
```
Wir konnten dann die Labels in der Podbeschreibung sehen
`environment=staging`,`project=pilot`,`tier=frontend`.

Gut. Jetzt haben wir ein staging Pod.

3. Jetzt das Ganze mit dem Erstellen der RC für eine Produktionsumgebung mit der Befehlszeile:
```
$ kubectl run nginx-prod --image=nginx --replicas=2 --port=80 --labels="environment=production,project=pilot,tier=frontend"
```
Dies wird dann einen RC namens `nginx-prod` mit zwei Repliken, einem geöffneten Port `80` und mit den Labels `environment=production`,`project=pilot`,`tier=frontend` erstellt.

4. Wir können sehen, dass wir derzeit insgesamt drei Pods haben. Eine pod wird für die Inszenierung geschaffen, die beiden anderen sind für die Produktion:
```
# kubectl get pods 
NAME               READY     STATUS    RESTARTS   AGE
nginx              1/1       Running   0          8s
nginx-prod-50345   1/1       Running   0          19s
nginx-prod-pilb4   1/1       Running   0          19s

```

5. Lassen Sie uns einige Filter für die Auswahl von Pods ausprobiren. Zum Beispiel, wenn ich im Pilotprojekt Produktions pods wählen wollte:
```
# kubectl get pods -l "project=pilot,environment=production"
NAME               READY     STATUS    RESTARTS   AGE
nginx-prod-50345   1/1       Running   0          9m
nginx-prod-pilb4   1/1       Running   0          9m

```
Durch Hinzufügen von `-l` gefolgt von Schlüssel / Wert-Paaren als Filteranforderungen konnten wir die gewünschten Pods sehen.

### Verknüpfen des Dienstes mit einem replication controller unter Verwendung von Label selektoren

Service in Kubernetes wird verwendet, um den port und für Lastausgleich zu verwenden:

1. In einigen Fällen müssen Sie einen Dienst vor dem replication controller hinzufügen, um den Port der Außenwelt verfügbar zu machen oder die Last auszugleichen. Wir verwenden die Konfigurationsdatei, um im folgenden Beispiel Dienste für den Staging-Pod und die Befehlszeile für Produktions-Pods zu erstellen:
```
// example of exposing staging pod
# cat staging-nginx-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    project: pilot
    environment: staging
    tier: frontend
spec:
  ports:
    -
      protocol: TCP
      port: 80
      targetPort: 80
  selector:
    project: pilot
    environment: staging
    tier: frontend
  type: LoadBalancer
// create the service by configuration file
# kubectl create -f staging-nginx-service.yaml
service "nginx" created


```

2. Benutze `kubectl describe` um die details zum Service zu beschreiben.
```
// describe service
# kubectl describe service nginx
Name:      nginx
Namespace:    default
Labels:      environment=staging,project=pilot,tier=frontend
Selector:    environment=staging,project=pilot,tier=frontend
Type:      LoadBalancer
IP:	    192.168.167.68
Port:      <unnamed>  80/TCP
Endpoints:    192.168.80.28:80
Session Affinity:  None
No events.
```
Mit `curl` für die ClusterIP kann die Willkommensseite von nginx zurückgeben werden.

3. Als nächstes fügen wir den Service für RC mit Label selektoren hinzu:
```
// add service for nginx-prod RC
# kubectl expose rc nginx-prod --port=80 --type=LoadBalancer --selector="project=pilot,environment=production,tier=frontend"
```

4.  Mit `kubectl describe`, um die Details des Dienstes zu beschreiben:
```
# kubectl describe service nginx-prod
Name:      nginx-prod
Namespace:    default
Labels:      environment=production,project=pilot,tier=frontend
Selector:    environment=production,project=pilot,tier=frontend
Type:      LoadBalancer
IP:      192.168.200.173
Port:      <unnamed>  80/TCP
NodePort:    <unnamed>  32336/TCP
Endpoints:    192.168.80.31:80,192.168.80.32:80
Session Affinity:  None
No events.
```
Wenn wir `curl` `192.168.200.173` verwenden, können wir die Willkommensseite von nginx genau wie die staging variante sehen.

### Notiz
Es wird eine Verbindung mit dem Fehler `Connection reset by peer` ausgegeben, wenn Sie die leere Pod-Set durch den Selektor angeben haben.

### Es gibt mehr…

In einigen Fällen möchten wir vielleicht die Ressourcen mit einigen Werten nur als Referenz in den Programmen oder Tools markieren. Die nicht identifizierenden Tags könnten stattdessen Annotationen verwenden, die strukturierte oder unstrukturierte Daten verwenden können. Im Gegensatz zu Labeln sind Anmerkungen nicht zum Abfragen und Auswählen. Das folgende Beispiel zeigt Ihnen, wie Sie eine Annotation in einen Pod hinzufügen und wie Sie sie innerhalb des Containers durch downward-API nutzen können:
```
# cat annotation-sample.yaml
apiVersion: v1
kind: Pod
metadata:
  name: annotation-sample
  labels:
    project: pilot
    environment: staging
  annotations:
    git: 6328af0064b3db8b913bc613876a97187afe8e19
    build: "20"
spec:
  containers:
    -
      image: busybox
      imagePullPolicy: IfNotPresent
      name: busybox
      command: ["sleep", "3600"]
```
Sie könnten dann auch die downward API, die wir in Volumen besprochen haben, wie auf Annotationen in Containern zugreifen:
```
# cat annotation-sample-downward.yaml
apiVersion: v1
kind: Pod
metadata:
  name: annotation-sample
  labels:
    project: pilot
    environment: staging
  annotations:
    git: 6328af0064b3db8b913bc613876a97187afe8e19
    build: "20"
spec:
  containers:
    -
      image: busybox
      imagePullPolicy: IfNotPresent
      name: busybox
      command: ["sh", "-c", "while true; do if [[ -e /etc/annotations ]]; then cat /etc/annotations; fi; sleep 5; done"]
      volumeMounts:
      - name: podinfo
        mountPath: /etc
volumes:
    - name: podinfo
      downwardAPI:
        items:
          - path: "annotations"
            fieldRef:
              fieldPath: metadata.annotations

```
Auf diese Weise werden `metadata.annotations` im Container als Dateiformat unter `/etc/annotations` angeboten. Wir könnten auch die Pod-Logs überprüfen und via stout in eine datei Datei schreiben:
```
// check the logs we print in command section
# kubectl logs -f annotation-sample
build="20"
git="6328af0064b3db8b913bc613876a97187afe8e19"
kubernetes.io/config.seen="2015-12-28T12:23:33.154911056Z"
kubernetes.io/config.source="api"
```
