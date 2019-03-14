# Kubernates HA Multi Master

Der Masterknoten dient als Kernel komponente im Kubernetes-System. Zu seinen Aufgaben gehören:

* Uploaden(Phushing) und Downlaoden(pulling) von Informationen aus dem Datenspeicher und den etcd-Servern
* Als das Portal für Anfragen
* Zuweisen von Aufgaben zu Nodes
* Überwachung der laufenden Aufgaben

Drei Haupt daemons unterstützen den MAster, der die vorangehenden Aufgaben erfüllt, die im folgenden Bild nummeriert sind:
![multimaster-kubernetes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_04_01.jpg)

Wie Sie sehen können, ist der Meister der Kommunikator zwischen Worker und clients. Daher wird es ein Problem sein, wenn der Master-Knoten abstürzt. Ein Multimaster-Kubernetes-System ist nicht nur fehlertolerant(fault tolerant,), sondern auch _workload-balanced_. Es gibt nicht mehr nur einen API-Server für den Zugriff auf Knoten und Clients, die Anfragen senden. Mehrere API-Server-Dämonen in getrennten Master-Nodes würden dazu beitragen, die Aufgaben gleichzeitig zu lösen und die Reaktionszeit zu verkürzen.

## Fertig werden

Hier sind die kurz die Konzepte zum Aufbau eines Multimaster-Systems aufgeführt:

* Füge einen Load Balancer Server vor den Mastern hinzu. Der Load Balancer wird der neue Endpunkt, der von Nodes und Clients abgerufen wird.

* Jeder Master führt seinen eigenen API-Server-Daemon aus.

* Nur ein Scheduler und ein Controller-Manager sind im System, die Konfliktrichtungen von verschiedenen Dämonen beim Verwalten von Containern vermeiden können.

* `Pod Master` ist ein neuer Dämon der in jedem Master installiert ist. Er entscheidet wer, den node-running daemon Daemon-Scheduler und den master node-running controller manager stellt. Es könnte der gleiche Meister sein, auf dem beide Dämonen laufen.

* Machen Sie einen flexibleren Weg, um einen Daemon-Scheduler und einen Controller-Manager als Container zu betreiben. Installiere Kubelet im Master und verwalte die Daemons als Pods, indem du Dateien konfigurierst.

In diesem Rezept werden wir ein Zwei-Master-System, das ähnliche Methoden bei der Skalierung mehrer Meister hat zu bauen.

### Wie es geht…

Jetzt führen wir Sie Schritt für Schritt durch den Aufbau eines Multimaster-Systems. Doch zuvor müssen Sie einen Load Balancer Server für den Master einsetzen.

> Notiz
> Um über den Einsatz des Load Balancers zu erfahren und das System auf AWS zu bauen, schau bitte das Gerüst der Kubernetes Infrastruktur im AWS Rezept in [Einrichten von kubernetes bei AWS](../kubernetes-aws-einrichten) nach, wie man einen Master Load Balancer baut.

### Vorbereiten mehrerer Masternodes

Zuerst installieren Sie einen anderen Master-Node in ihr vorhandenes Kubernetes-System, das in der gleichen Umgebung ist wie der ursprüngliche Master. Dann stoppen Sie die Dämon-Dienste von Scheduler und Controller-Manager in beiden Meistern:

* Für das  systemd-controlled System stoppen Sie die Dienste direkt über die Befehl `systemctl kube-scheduler stop` und `systemctl kube-controller-manager stop`

* Für die init systemd-controlled System, stoppen Sie den Master-Service zuerst. Als nächstes löschen oder kommentieren Sie die Zeilen über Scheduler und Controller Manager im Initialisierungsskript aus:

```sh
// Checking current daemon processes on master server
# service kubernetes-master status
kube-apiserver (pid 3137) is running...
kube-scheduler (pid 3138) is running...
kube-controller-manager (pid 3136) is running...
# service kubernetes-master stop
Shutting down /usr/local/bin/kube-controller-manager:      [  OK  ]
Shutting down /usr/local/bin/kube-scheduler:               [  OK  ]
Shutting down /usr/local/bin/kube-apiserver:               [  OK  ]
// Or, for "hypercube" command with init script, we block out scheduler and controller-manager. Just leave apiserver daemon in master node.
// Put comment on the scheduler and controller manager daemons
// the variable $prog is /usr/local/bin/hyperkube
# cat /etc/init.d/kubernetes-master
(ignored above parts)
       # Start daemon.
       echo $"Starting apiserver: "
       daemon $prog apiserver \
       --service-cluster-ip-range=${CLUSTER_IP_RANGE} \
       --insecure-port=8080 \
       --secure-port=6443 \
       --address=0.0.0.0 \
       --etcd_servers=${ETCD_SERVERS} \
       --cluster_name=${CLUSTER_NAME} \
       > ${logfile}-apiserver.log 2>&1 &

#       echo $"Starting controller-manager: "
#       daemon $prog controller-manager \
#       --master=${MASTER} \
#       > ${logfile}-controller-manager.log 2>&1 &
#
#       echo $"Starting scheduler: "
#       daemon $prog scheduler \
#       --master=${MASTER} \
#       > ${logfile}-scheduler.log 2>&1 &
(ignored below parts)
# service kubernetes-master start
Starting apiserver:
```

In diesem Schritt haben Sie zwei Master im System mit zwei Prozessen des API-Servers.

### Kubelet im Master einrichten

Weil wir den Daemons Scheduler und Controller Manager als Pods installieren werden, ist ein Kubelet-Prozess ein Must-Have-Daemon. Laden Sie die neueste (Version 1.1.4) [Kubelet-Binärdatei herunter](https://storage.googleapis.com/kubernetes-release/release/v1.1.4/bin/linux/amd64/kubelet) und legen Sie sie in das Verzeichnis des Systems der Binärdateien:

```sh
# wget https://storage.googleapis.com/kubernetes-release/release/v1.1.4/bin/linux/amd64/kubelet
# chmod 755 kubelet
# mv kubelet /usr/local/bin/
```

Alternativ können Sie für das RHEL-System `kubelet` aus dem YUM-Repository herunterladen:
`# yum install kubernetes-node`

Später werden wir den `kubelet` Daemon mit bestimmten Parametern und Werten konfigurieren:

|Tag Name|Wert|Zweck|
| :---: | :---: | :---: |
| `--api-servers` | `127.0.0.1:8080` |Um mit dem API-Server lokal zu kommunizieren.|
| `--register-node`|`false`|Vermeiden Sie es, diesen Master, den lokalen Host, als Knoten zu registrieren.|
| `--allow-privileged`|`true`|Um den Containern zu gestatten, den privilegierten Modus anzufordern, was bedeutet, dass Container in der Lage sind, auf das Hostgerät zuzugreifen, insbesondere das Netzwerkgerät in diesem Fall.|
| `--config` |`/etc/kubernetes/manifests`|Um lokale Container durch die Vorlagendateien unter diesem angegebenen Verzeichnis zu verwalten.|

Wenn Ihr System von `systemctl` überwacht wird, setzen Sie die vorherigen Parameter in die Konfigurationsdateien:

>
> In `/etc/kubernetes/config`:
>>
>> * Modifieziren von `KUBE_MASTER` zu `--master=127.0.0.1:8080` :
>>

```sh
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=0"
KUBE_ALLOW_PRIV="--allow_privileged=false"
KUBE_MASTER="--master=127.0.0.1:8080"
```

>>
>
> * In `/etc/kubernetes/kubelet` :
>
>>
>> * Setzen Sie den Tag `--api-Server` auf die Variable `KUBELET_API_SERVER`.
>> * Setzen Sie die anderen drei Tags in die Variable `KUBELET_ARGS` :
>>

```sh
KUBELET_ADDRESS="--address=0.0.0.0"
KUBELET_HOSTNAME="--hostname_override=127.0.0.1"
KUBELET_API_SERVER="--api_servers=127.0.0.1:8080"
KUBELET_ARGS="--register-node=false --allow-privileged=true --config /etc/kubernetes/manifests"
```

>>
>

Auf der anderen Seite, ändern Sie Ihre Skript-Datei von `init` Service-Management und fügen Sie die Tags nach dem Daemon `kubelet` hinzu. Zum Beispiel haben wir folgende Einstellungen in `/etc/init.d/kubelet` vorzunehmen:

```sh
# cat /etc/init.d/kubelet
prog=/usr/local/bin/kubelet
lockfile=/var/lock/subsys/`basename $prog`
hostname=`hostname`
logfile=/var/log/kubernetes.log

start() {
       # Start daemon.
       echo $"Starting kubelet: "
       daemon $prog \
               --api-servers=127.0.0.1:8080 \
               --register-node=false \
               --allow-privileged=true \
               --config=/etc/kubernetes/manifests \
               > ${logfile} 2>&1 &
     (ignored)
```

Es ist gut, deinen Kubelet-Service im gestoppten Zustand zu lassen, da wir ihn nach der Konfiguration der Scheduler und des Controller-Managers starten werden.

### Die Konfigurationsdateien fertig stellen

Wir benötigen drei Vorlagen als Konfigurationsdateien: für den Pod Master, Scheduler und Controller Manager. Diese Dateien sollten an bestimmten Orten platziert werden.

Pod Master behandelt die Wahlen, um zu entscheiden, auf welchen Master den Scheduler-Daemon läuft und welcher Master den Controller Manager-Daemon leitet. Das Ergebnis wird in den etcd-Servern aufgezeichnet. Die Vorlage des Pod-Masters wird in das Kubelet-Konfigurationsverzeichnis gelegt, um sicherzustellen, dass der Pod-Master direkt nach dem Start des Kubeletts erstellt wird:

```sh
# cat /etc/kubernetes/manifests/podmaster.yaml
apiVersion: v1
kind: Pod
metadata:
 name: podmaster
 namespace: kube-system
spec:
 hostNetwork: true
 containers:
 - name: scheduler-elector
   image: gcr.io/google_containers/podmaster:1.1
   command: ["/podmaster", "--etcd-servers=<ETCD_ENDPOINT>", "--key=scheduler", "--source-file=/kubernetes/kube-scheduler.yaml", "--dest-file=/manifests/kube-scheduler.yaml"]
   volumeMounts:
   - mountPath: /kubernetes
     name: k8s
     readOnly: true
   - mountPath: /manifests
     name: manifests
 - name: controller-manager-elector
   image: gcr.io/google_containers/podmaster:1.1
   command: ["/podmaster", "--etcd-servers=<ETCD_ENDPOINT>", "--key=controller", "--source-file=/kubernetes/kube-controller-manager.yaml", "--dest-file=/manifests/kube-controller-manager.yaml"]
   terminationMessagePath: /dev/termination-log
   volumeMounts:
   - mountPath: /kubernetes
     name: k8s
     readOnly: true
   - mountPath: /manifests
     name: manifests
 volumes:
 - hostPath:
     path: /srv/kubernetes
   name: k8s
 - hostPath:
     path: /etc/kubernetes/manifests
   name: manifests
```

In der Konfigurationsdatei von pod master werden wir eine Pod mit zwei Containern einsetzen, mit den beiden Wählern für verschiedenen Dämonen. Der Pod `podmaster` wird in einem neuen Namensraum namens `kube-System` erstellt, um Pods für Dämonen und Anwendungen zu trennen. Wir müssen einen neuen Namespace erstellen, bevor wir Ressourcen mit Vorlagen erstellen. Es ist auch wichtig zu wissen, dass der Pfad `/srv/kubernetes` ist, wo wir die Konfigurationsdateien der Dämonen setzen. Der Inhalt der Dateien hat folgenden inhalt:

```sh
# cat /srv/kubernetes/kube-scheduler.yaml
apiVersion: v1
kind: Pod
metadata:
 name: kube-scheduler
 namespace: kube-system
spec:
 hostNetwork: true
 containers:
 - name: kube-scheduler
   image: gcr.io/google_containers/kube-scheduler:34d0b8f8b31e27937327961528739bc9
   command:
   - /bin/sh
   - -c
   - /usr/local/bin/kube-scheduler --master=127.0.0.1:8080 --v=2 1>>/var/log/kube-scheduler.log 2>&1
   livenessProbe:
     httpGet:
       path: /healthz
       port: 10251
     initialDelaySeconds: 15
     timeoutSeconds: 1
   volumeMounts:
   - mountPath: /var/log/kube-scheduler.log
     name: logfile
   - mountPath: /usr/local/bin/kube-scheduler
     name: binfile
 volumes:
 - hostPath:
     path: /var/log/kube-scheduler.log
   name: logfile
 - hostPath:
     path: /usr/local/bin/kube-scheduler
   name: binfile

```

Es gibt einige spezielle Elemente in der Vorlage, wie Namespace und zwei angehängte Dateien gesetzt. Einer ist eine Protokolldatei; Die Streaming-Ausgabe kann auf der lokalen Seite zugegriffen und gespeichert werden. Die andere ist die Ausführungsdatei. Der Container kann den aktuellen Kube-Scheduler auf dem lokalen Host nutzen:

```sh
# cat /srv/kubernetes/kube-controller-manager.yaml
apiVersion: v1
kind: Pod
metadata:
 name: kube-controller-manager
 namespace: kube-system
spec:
 containers:
 - command:
   - /bin/sh
   - -c
   - /usr/local/bin/kube-controller-manager --master=127.0.0.1:8080 --cluster-cidr=<KUBERNETES_SYSTEM_CIDR> --allocate-node-cidrs=true --v=2 1>>/var/log/kube-controller-manager.log 2>&1
   image: gcr.io/google_containers/kube-controller-manager:fda24638d51a48baa13c35337fcd4793
   livenessProbe:
     httpGet:
       path: /healthz
       port: 10252
     initialDelaySeconds: 15
     timeoutSeconds: 1
   name: kube-controller-manager
   volumeMounts:
   - mountPath: /srv/kubernetes
     name: srvkube
     readOnly: true
   - mountPath: /var/log/kube-controller-manager.log
     name: logfile
   - mountPath: /usr/local/bin/kube-controller-manager
     name: binfile
 hostNetwork: true
 volumes:
 - hostPath:
     path: /srv/kubernetes
   name: srvkube
 - hostPath:
     path: /var/log/kube-controller-manager.log
   name: logfile
 - hostPath:
     path: /usr/local/bin/kube-controller-manager
   name: binfile
```

Die Konfigurationsdatei des Controller-Managers ähnelt der des Schedulers. Denken Sie daran, der CIDR-Bereich Ihres Kubernetes-Systems im Daemon-Befehl bereitzustellen.

Um die Vorlagen erfolgreich bearbeiten zu können, sind noch einige Vorkonfigurationen erforderlich, bevor Sie den Pod-Master starten:

* Erstellen Sie leere Log-Dateien. Andernfalls wird der Container anstelle des Dateiformats den Pfad als Verzeichnis betrachten und den Fehler der pod-Erstellung verursachen:

```sh
// diese Befehle auf jedem Master ausführen
# Touch /var/log/kube-scheduler.log
# Touch /var/log/kube-controller-manager.log
```

* Erstellen Sie den neuen Namespace. Der neue Namespace ist von der Standardeinstellung getrennt. Wir werden die Pod für die Systemnutzung in diesem Namespace setzen:

```sh
// Just execute this command in a master, and other masters can share this update.
# kubectl create namespace kube-system
// Or
# curl -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"kube-system"}}' "http://127.0.0.1:8080/api/v1/namespaces"
```

### Starten des Kubeletts und  Daemons

Bevor wir Kubelet für unsere Pod Master und zwei master-owned Dämonens starten, bitte stellen Sie sicher, dass Sie Docker und Flanneld zuerst beginnen:

```sh
# Now, it is good to start kubelet on every masters
# service kubelet start
```

Warten Sie eine Weile; Sie erhalten einen Pod-Master, der auf jedem Master läuft und Sie werden endlich ein Paar Scheduler und Controller Manager bekommen:

```sh
# Pods im Namespace überprüfen "kube-system"
# Kubectl bekommen pod --namespace = kube-system
NAME READY STATUS RESTARTS ALTER
Kube-controller-manager-kube-master1 1/1 Laufen 0 3m
Kube-scheduler-kube-master2 1/1 Laufen 0 3m
Podmaster-kube-master1 2/2 Laufen 0 1m
Podmaster-kube-master2 2/2 Laufen 0 1m
```

Glückwünsche! Sie haben Ihr Multimaster-Kubernetes-System erfolgreich aufgebaut. Und die Struktur der Maschinen sieht aus wie folgendes Bild:

![multi-master-node-schema](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_04_02.jpg)

Sie können sehen, dass jetzt ein einzelner Node nicht mit der gesamten Anforderungslast umgehen muss. Außerdem sind die Dämonen nicht in einem Meister überfüllt; Sie können an verschiedene Master verteilt werden und jeder Master hat die Fähigkeit, sich zu erhollen. Versuche, einen Meister zu beenden; Sie werden feststellen, dass Ihr Scheduler und Controller Manager noch Dienstleistungen erbringt.

### Wie es funktioniert…

Überprüfen Sie das Protokoll des Container-Pod-Masters. Du bekommst zwei Arten von Nachrichten, eine für den der den Schlüssel hält und einen ohne Schlüssel:

```sh
// Get the log with specified container name
# kubectl logs podmaster-kube-master1 -c scheduler-elector --namespace=kube-system
I0211 15:13:46.857372       1 podmaster.go:142] --whoami is empty, defaulting to kube-master1
I0211 15:13:47.168724       1 podmaster.go:82] key already exists, the master is kube-master2, sleeping.
I0211 15:13:52.506880       1 podmaster.go:82] key already exists, the master is kube-master2, sleeping.
(ignored)
# kubectl logs podmaster-kube-master1 -c controller-manager-elector --namespace=kube-system
I0211 15:13:44.484201       1 podmaster.go:142] --whoami is empty, defaulting to kube-master1
I0211 15:13:50.078994       1 podmaster.go:73] key already exists, we are the master (kube-master1)
I0211 15:13:55.185607       1 podmaster.go:73] key already exists, we are the master (kube-master1)
(ignored)
```

Der Master mit dem Schlüssel sollte den jeweiligen Dämon und den besagten Scheduler oder Controller Manager übernehmen. Diese aktuelle Hochverfügbarkeitslösung für den Master wird durch die Lease-Lock-Methode in etcd realisiert:

![psp-etcd](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_04_03.jpg)

Das vorhergehende Schleifenbild zeigt den Fortschritt der Lease-Lock-Methode an. Zwei Zeiträume sind bei dieser Methode wichtig: **SLEEP** ist der Zeitraum für die Überprüfung der Sperre und **Time to Live (TTL)** ist der Zeitraum des Leasingablaufs. Wir können sagen, dass, wenn der Dämon-laufende Master abgestürzt ist, der schlimmste Fall für den anderen Meister, der seinen Job übernimmt, die Zeit **SLEEP + TTL** erfordert. Standardmäßig ist **SLEEP** 5 Sekunden und TTL ist 30 Sekunden.

> Notiz
> Man kann noch einen Blick auf den Quellcode von pod master für mehr Konzepte werfen [podmaster.go](https://github.com/kubernetes/contrib/blob/master/pod-master/podmaster.go).