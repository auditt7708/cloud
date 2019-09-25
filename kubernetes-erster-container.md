Glückwünsche! Du hast in den vorherigen Abschnitten deinen eigenen Kubernetes-Cluster aufgebaut. Nun, lasst uns mit dem Ausführen deines ersten Containers nginx (http://nginx.org/) fortfahren, das ist ein Open-Source-Reverse-Proxy-Server, Load Balancer und Web-Server.

### Fertig werden

Bevor wir mit dem ersten Container in Kubernetes beginnen, ist es besser zu prüfen, ob jede Komponente wie erwartet funktioniert. Bitte befolgen Sie diese Schritte auf ihrem Master, um zu überprüfen, ob die Umgebung betriebsbereit ist:

1. Prüfen Sie, ob die Kubernetes-Komponenten laufen:

### Notiz:
Wenn eine der Komponenten nicht läuft, schauen Sie sich die Einstellungen in den vorherigen Abschnitten an. Starten Sie die zugehörigen Dienste neu, z.B. `service kube-apiserver start`.

2- Master status Überprüfen:
```
# Check master is running
$ kubectl cluster-info
Kubernetes master is running at http://localhost:8080
```

### Notiz:
Wenn der Kubernetes master nicht läuft dann starte den service folgendermassen
`service kubernetes-master start` oder `/etc/init.d/kubernetes-master start` .

3. Prüfen, dass alle nodes erreichbar sind:
```
# check nodes are all Ready
$ kubectl get nodes
NAME          LABELS                               STATUS
kub-node1   kubernetes.io/hostname=kub-node1   Ready
kub-node2   kubernetes.io/hostname=kub-node2   Ready
```
### Notiz
Wenn es vorkommen, dass ein Node als `Ready` erkannt wird aber nicht erreichbar ist dann kann es hilfreich sein Docker und den Node service neu zu starten `service docker start` und `service kubernetes-node start`.

Bevor wir zum nächsten Abschnitt gehen, stellen Sie sicher, dass die Nodes für die Docker-Registrierung zugänglich sind. Wir verwenden das nginx Bild von Docker Hub (https://hub.docker.com/) als Beispiel. Wenn du deine eigene Anwendung ausführen möchtest, solltest du es zuerst dockerisieren! Was Sie für Ihre benutzerdefinierte Anwendung tun müssen, ist, eine Dockerfile (https://docs.docker.com/v1.8/reference/builder) zu schreiben, den Build durchführen und in die öffentliche / private Docker-Registrierung kopieren.

### Tip
Testen Sie Ihre Node verbindung mit der öffentlichen / privaten Docker-Registrierung

Auf deinem Knoten versuchet Docker, nginx zu testen, um zu testen, ob du das Image von Docker Hub Downloaden kannst. Wenn du hinter einem Proxy steckst, füge bitte `HTTP_PROXY` in deine Docker-Konfigurationsdatei (normalerweise in `/etc/sysconfig/docker`) ein. Wenn Sie das Image aus dem privaten Repository im Docker Hub ausführen möchten, können Sie die Anmeldeinformationen in `/var/lib/kubelet/.dockercfg `kopieren, indem Sie das Docker-Login auf dem Node verwenden, um Ihre Anmeldeinformationen in `~/.docker/config.json` zu platzieren im Json format und neu starten Docker:
```
# put the credential of docker registry
$ cat /var/lib/kubelet/.dockercfg

{
        "<docker registry endpoint>": {
                "auth": "SAMPLEAUTH=",
                "email": "noreply@sample.com"
        }
}
```
Wenn Sie Ihre eigene private Registrierung verwenden, geben Sie `INSECURE_REGISTRY` in der Docker-Konfigurationsdatei an.

### Wie es geht…

Wir verwenden das offizielle Docker-Image von nginx als Beispiel. Das Image wird im Docker Hub angeboten (https://hub.docker.com/_/nginx/).

Viele offizielle und öffentliche Images sind auf Docker Hub verfügbar,so dass Sie es nicht von Grund auf neu zu bauen müssen. Laden Sie es einfach runter und richten Sie Ihre benutzerdefinierte Einstellung wie beschrieben ein.

### Einen HTTP-Server ausführen (nginx)

1. Auf dem Kubernetes-Meister konnten wir `kubectl run` laufen lassen, um eine bestimmte Anzahl von Containern zu erstellen. Der Kubernetes-Master wird dann die Pods für die zu laufenden Nodes planen:
`$ kubectl run <replication controller name> --image=<image name> --replicas=<number of replicas> [--port=<exposing port>]`

2. Im folgenden Beispiel werden zwei Repliken mit dem Namen `my-first-nginx` aus dem nginx-Image erstellt und der Port `80` frei gegeben. Wir könnten einen oder mehrere Container in einem sogenannten Pod bereitstellen. In diesem Fall werden wir einen Container pro Pod einsetzen. Genau wie ein normale Docker-Umgebung, wenn das nginx-Bild nicht lokal existiert, wird es es aus Docker Hub standardmäßig geladen:
```
# Pull the nginx image and run with 2 replicas, and expose the container port 80
$ kubectl run my-first-nginx --image=nginx --replicas=2 --port=80
CONTROLLER       CONTAINER(S)     IMAGE(S)   SELECTOR             REPLICAS
my-first-nginx   my-first-nginx   nginx      run=my-first-nginx   2
```

### Tip
Der Name des Replikationscontrollers <my-first-nginx> kann nicht dupliziert werden

Die Ressource (Pods, Services, Replikationscontroller usw.) in einem Kubernetes-Namespace kann nicht dupliziert werden. Wenn Sie den vorherigen Befehl zweimal ausführen, wird der folgende Fehler angezeigt:

Fehler vom Server: replikationController "my-first-nginx" existiert bereits.

Lassen Sie sich also nicht verwirren.


3. Lasst uns den aktuellen Status aller Pods mit `kubectl get pods` ausgeben. Normalerweise wird der Status der Pods für eine Weile im `Pending` stehen, da es einige Zeit dauert, bis die Nodes das Bild von Docker Hub gedownloadet haben:

```
# get all pods
$ kubectl get pods
NAME                     READY     STATUS    RESTARTS   AGE
my-first-nginx-nzygc     1/1       Running   0          1m
my-first-nginx-yd84h     1/1       Running   0          1m
```

### Tip

Wenn der Pod-Status für eine lange Zeit nicht läuft

Sie könnten immer `kubectl get pods`, um den aktuellen Status der Pods zu überprüfen und , um die detaillierten Informationen eines Pod zu überprüfen `kubectl describe pods $pod_name`. Wenn Sie einen Tippfehler des Imagenamens machen, erhalten Sie möglicherweise die Fehlermeldung des Images nicht, und wenn Sie das Image aus einem privaten Repository oder einer Registrierung ohne ordnungsgemäße Anmeldeinformationen laden, können Sie die `Authentication error` erhalten. Wenn Sie den Status "Ausstehen" für eine lange Zeit erhalten und die Knotenkapazität überprüfen, stellen Sie sicher, dass Sie nicht zu viele Repliken ausführen, die die Knotenkapazität überschreiten, die im Abschnitt "Vorbereiten der Umgebung" beschrieben wurde. Wenn es noch andere unerwartete Fehlermeldungen gibt, kannst du entweder die Pods oder den gesamten Replikationscontroller stoppen, um den Master zu zwingen, die Aufgaben erneut zu planen.

Nach dem Warten ein paar Sekunden gibt es zwei Pods, die mit dem Running-Status laufen:
```
# get replication controllers
$ kubectl get rc
CONTROLLER         CONTAINER(S)       IMAGE(S)                                                   SELECTOR                                                        REPLICAS
my-first-nginx     my-first-nginx     nginx                                                      run=my-first-nginx
2

```


### Den Port für den externen Zugriff aussetzen

Vielleicht möchten wir auch eine externe IP-Adresse für den `nginx`-Replikationscontroller erstellen. Bei Cloud-Providern, die einen externen Load-Balancer (wie Google Compute Engine) mit dem `LoadBalancer`-Typ unterstützen, wird ein Load-Balancer für den externen Zugriff bereitgestellt. Auf der anderen Seite können Sie den Port immer noch verfügbar machen, indem Sie einen Kubernetes-Dienst wie folgt erstellen, obwohl Sie nicht auf den Plattformen laufen, die einen externen LoadBalancer unterstützen. Wir werden später beschreiben, wie man später zugreifen kann:
```
# expose port 80 for replication controller named my-first-nginx
$ kubectl expose rc my-first-nginx --port=80 --type=LoadBalancer
NAME             LABELS               SELECTOR             IP(S)     PORT(S)
my-first-nginx   run=my-first-nginx   run=my-first-nginx             80/TCP
```
Wir können den Status des soeben erstellten Service sehen:
```
# get all services
$ kubectl get service
NAME                       LABELS                                                                    SELECTOR                                                                     IP(S)             PORT(S)
my-first-nginx             run=my-first-nginx                                                        run=my-first-nginx                                                           192.168.61.150     80/TCP

```

Glückwünsche! Sie haben gerade Ihren ersten Container mit einem Kubernetes Pod und den Port 80 verbunden mit dem Kubernetes Service.

### Stoppen der Anwendung

Wir könnten die Anwendung mit Befehlen wie dem `stop` replication controller und dem Dienst beenden. Davor empfehlen wir Ihnen, die folgende Einleitung zu lesen, um mehr darüber zu erfahren, wie es funktioniert:
```
# stop replication controller named my-first-nginx
$ kubectl stop rc my-first-nginx
replicationcontrollers/my-first-nginx

# stop service named my-first-nginx
$ kubectl stop service my-first-nginx
services/my-first-nginx
```

### Wie es funktioniert…
 
Schauen wir uns die Einsicht in den Dienst an, indem wir im Befehl `kubectl` mit `describe` aufrufen. Wir erstellen einen Kubernetes-Service mit dem Typ `LoadBalancer`, der den Verkehr in zwei `Endpoints` `192.168.50.4` und `192.168.50.5` mit Port `80` leitet:
```
$ kubectl describe service my-first-nginx
Name:      my-first-nginx
Namespace:    default
Labels:      run=my-first-nginx
Selector:    run=my-first-nginx
Type:      LoadBalancer
IP:      192.168.61.150
Port:      <unnamed>  80/TCP
NodePort:    <unnamed>  32697/TCP
Endpoints:    192.168.50.4:80,192.168.50.5:80
Session Affinity:  None
No events.

```
`Port` hier ist ein abstrakter Service-Port, der es ermöglicht, dass alle anderen Ressourcen auf den Service innerhalb des Clusters zugreifen können. Der `nodePort` zeigt den externen Port an, um einen externen Zugriff zu ermöglichen. Der `targetPort` ist der `Port` der Container ermöglicht den Verkehr in; Standardmäßig ist es bei Port gleich. Die Abbildung ist wie folgt. Der externe Zugriff greift auf den Dienst mit nodePort zu. Service fungiert als Load-Balancer, um den Traffic an den Pod mit `Port` `80` zu versenden. Der Pod wird dann durch den Traffic in den entsprechenden Container mit `targetPort` `80` weiterleiten:

![net-erster-container](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_07.jpg)

In jedem Node oder Master (wenn dein Master Flanell installiert ist) solltest du mit dem ClusterIP `192.168.61.150` mit Port `80` auf den nginx Service zugreifen können:
```
# curl from service IP
$ curl 192.168.61.150:80
<!DOCTYPE html>
<html>
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
```
Es wird das gleiche Ergebnis sein, wenn wir den Zielhafen der Pod direkt locken:
```
# curl from endpoint
$ curl 192.168.50.4:80
<!DOCTYPE html>
<html>
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
```

Wenn Sie einen externen Zugriff ausprobieren möchten, verwenden Sie Ihren Browser, um auf die externe IP-Adresse zuzugreifen. Bitte beachten Sie, dass die externe IP-Adresse davon abhängt, in welcher Umgebung Sie sich befinden.

In Google Compute Engine können Sie über ein ClusterIP mit der richtigen Firewall-Regeln auf sie zugreifen:

`$ curl http://<clusterIP>`

In einer benutzerdefinierten Umgebung, wie z. B. auf einem premise datacenter, können Sie durch die IP-Adresse der Nodes gehen, um auf folder weise zuzugreifen:

`$ curl http://<nodeIP>:<nodePort>`

Sie sollten die folgende Seite mit einem Webbrowser sehen können:

`Welcome to nginx!`

