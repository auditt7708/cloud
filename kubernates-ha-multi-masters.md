Der Masterknoten dient als Kernelkomponente im Kubernetes-System. Zu seinen Aufgaben gehören:

* Schieben und Ziehen von Informationen aus dem Datenspeicher und den etcd-Servern
* Als das Portal für Anfragen
* Zuweisen von Aufgaben zu Knoten
* Überwachung der laufenden Aufgaben

Drei Hauptdämonen unterstützen den Meister, der die vorangehenden Aufgaben erfüllt, die im folgenden Bild nummeriert sind:
![multimaster-kubernates](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_04_01.jpg)

Wie Sie sehen können, ist der Meister der Kommunikator zwischen Arbeiter und Klienten. Daher wird es ein Problem sein, wenn der Master-Knoten abstürzt. Ein Multimaster-Kubernetes-System ist nicht nur fehlertolerant, sondern auch arbeitsbelastbar. Es gibt nicht mehr nur einen API-Server für den Zugriff auf Knoten und Clients, die Anfragen senden. Mehrere API-Server-Dämonen in getrennten Master-Knoten würden dazu beitragen, die Aufgaben gleichzeitig zu lösen und die Reaktionszeit zu verkürzen.

### Fertig werden

Hier sind die kurzen Konzepte zum Aufbau eines Multimaster-Systems aufgeführt:

* Füge einen Load Balancer Server vor den Mastern hinzu. Der Load Balancer wird der neue Endpunkt, der von Knoten und Clients abgerufen wird.

* Jeder Master führt seinen eigenen API-Server-Daemon aus.

* Nur ein Scheduler und ein Controller-Manager sind im System, die Konfliktrichtungen von verschiedenen Dämonen beim Verwalten von Containern vermeiden können.

* `Pod Master` ist ein neuer Dämon in jedem Master installiert. Es entscheidet sich, den Masterknoten-laufenden Daemon-Scheduler und den Master-Knoten-laufenden Controller-Manager zu entscheiden. Es könnte der gleiche Meister sein, der beide Dämonen läuft.

* Machen Sie einen flexibleren Weg, um einen Daemon-Scheduler und einen Controller-Manager als Container zu betreiben. Installiere Kubelet im Master und verwalte die Daemons als Pods, indem du Dateien konfigurierst.

In diesem Rezept werden wir ein Zwei-Master-System, das ähnliche Methoden bei der Skalierung mehr Meister hat zu bauen.

### Wie es geht…

Jetzt führen wir Sie Schritt für Schritt beim Aufbau eines Multimaster-Systems. Davor müssen Sie einen Load Balancer Server für Master einsetzen.

###### Notiz
Um über den Einsatz des Load Balancers zu erfahren und das System auf AWS zu bauen, schau bitte das Gebäude der Kubernetes Infrastruktur im AWS Rezept in [Einrichten von Kubernates bei AWS](../kubernates-aws-einrichten) auf, wie man einen Master Load Balancer baut.

### Vorbereiten mehrerer Masterknoten

Zuerst installieren Sie einen anderen Master-Knoten in Ihrem vorherigen Kubernetes-System, das in der gleichen Umgebung wie der ursprüngliche Master sein sollte. Dann stoppen Sie die Dämon-Dienste von Scheduler und Controller-Manager in beiden Meister:

* Für das systemgesteuerte System stoppen Sie die Dienste direkt über die Befehle `systemctl kube-scheduler stop` und `systemctl kube-controller-manager stop`

* Für die init Service-gesteuerte System, stoppen Sie den Master-Service zuerst. Als nächstes löschen oder kommentieren Sie die Zeilen über Scheduler und Controller Manager im Initialisierungsskript:
```
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

Weil wir den Daemons Scheduler und Controller Manager als Pods installieren werden, ist ein Kubelet-Prozess ein Must-Have-Daemon. Laden Sie die neueste (Version 1.1.4) Kubelet-Binärdatei herunter (https://storage.googleapis.com/kubernetes-release/release/v1.1.4/bin/linux/amd64/kubelet) und legen Sie sie unter das Verzeichnis des Systems Binärdateien:
```
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
|` --register-node `|`false`|Vermeiden Sie es, diesen Master, den lokalen Host, als Knoten zu registrieren.|
|`--allow-privileged`|`true`|Um den Containern zu gestatten, den privilegierten Modus anzufordern, was bedeutet, dass Container in der Lage sind, auf das Hostgerät zuzugreifen, insbesondere das Netzwerkgerät in diesem Fall.|
| `--config` |`/etc/kubernetes/manifests`|Um lokale Container durch die Vorlagendateien unter diesem angegebenen Verzeichnis zu verwalten.|

Wenn Ihr System von `systemctl` überwacht wird, setzen Sie die vorherigen Parameter in die Konfigurationsdateien:

>
> In `/etc/kubernetes/config`:
>>
>> * Modifieziren von `KUBE_MASTER` zu `--master=127.0.0.1:8080` :
>> 
```
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
```
KUBELET_ADDRESS="--address=0.0.0.0"
KUBELET_HOSTNAME="--hostname_override=127.0.0.1"
KUBELET_API_SERVER="--api_servers=127.0.0.1:8080"
KUBELET_ARGS="--register-node=false --allow-privileged=true --config /etc/kubernetes/manifests"
```
>>
>