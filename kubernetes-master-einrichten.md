Der Masternode von Kubernetes arbeitet als Kontrollzentrum für Container. Die Aufgaben, die vom Master übernommen werden, beinhalten ein Portal für Endbenutzer, die Zuweisung von Aufgaben an Knoten und das Sammeln von Informationen. In diesem Rezept werden wir sehen, wie man den Kubernetes Master aufbaut. Es gibt drei Dämonenprozesse am Meister:

*      API Server
*      Scheduler
*      Controller Manager

Wir können entweder mit dem Wrapper-Befehl, `hyperkube` starten oder sie einzeln als Daemons starten. Beide Lösungen werden in diesem Abschnitt behandelt.

### Fertig werden

Bevor Sie den Master-Knoten einsetzen, stellen Sie sicher, dass Sie den etcd-Endpunkt bereit haben, der wie der Datenspeicher von Kubernetes arbeitet. Sie müssen überprüfen, ob es zugänglich ist und auch mit dem Overlay-Netzwerk konfiguriert ist. **Classless Inter-Domain Routing** (CIDR https://de.wikipedia.org/wiki/Classless_Inter-Domain_Routing). Es ist möglich, es mit der folgenden Befehlszeile zu überprüfen:

```
// Check both etcd connection and CIDR setting
$ curl -L <etcd endpoint URL>/v2/keys/coreos.com/network/config
```

Wenn die Verbindung erfolgreich ist, aber die etcd-Konfiguration keinen erwarteten CIDR-Wert hat, können Sie auch durch Curl-Wert schreiben:

```
$ curl -L <etcd endpoint URL>/v2/keys/coreos.com/network/config -XPUT -d value="{ \"Network\": \"<CIDR of overlay network>\" }"
```

### Tip
Darüber hinaus notieren Sie bitte die folgenden Elemente: die URL von `etcd endpoint`, den Port von `etcd endpoint`, und die CIDR des Overlay-Netzwerks.
Sie benötigen sie bei der Konfiguration der Master-Dienste.

### Wie es geht…

Um einen Master aufzubauen, schlagen wir die folgenden Schritte für die Installation des Quellcodes vor, beginnend mit den Dämonen und dann die Überprüfung. Folgen Sie dem Verfahren und Sie erhalten schließlich einen praktischen Meister .

### Installation

Hier bieten sich zwei Arten von Installationsverfahren an:

* Einer ist ein RHEL-basiertes Betriebssystem mit Paketmanager; Master-Daemons werden von systemd gesteuert
* Die andere ist für andere Linux-Distributionen; Wir bauen Master mit Binärdateien und Service-Init-Skripten auf

### CentOS 7 oder Red Hat Enterprise Linux 7

1. RHEL 7, CentOS 7 oder später ein offizielles Paket für Kubernetes. Sie können sie über den `yum`-Befehl installieren:

```
// install Kubernetes master package
# yum install kubernetes-master kubernetes-client
```

Das `kubernetes-master` Paket enthält Master-Daemons, während der `kubernetes-client` ein Tool namens `kubectl` installiert, welches die Command Line Interface für die Kommunikation mit dem Kubernetes-System ist. Da der Master-Knoten als Endpunkt für Anfragen dienen wird, kann  `kubectl` mit installiert werden. Benutzer können die Containeranwendungen und die Umgebung einfach über Befehle steuern.

## Notiz
CentOS 7s RPM von Kubernetes

Es gibt fünf Kubernetes-RPMs (die `.rpm` Dateien, https://en.wikipedia.org/wiki/RPM_Package_Manager) für verschiedene Funktionalitäten:
`kubernetes`, `kubernetes-master`, `kubernetes-client`, `kubernetes-node` und `kubernetes-unit-test`.

Das erste, `kubernetes`, ist genau wie ein Hyperlink zu den folgenden drei Items. Sie werden `kubernetes-master`, `kubernetes-client` und `kubernetes-node` sofort installieren. Derjenige namens kubernetes-node ist für die Nodeinstallation. Und der letzte, der Kubernetes-Unit-Test enthält nicht nur Test-Scripts, sondern auch Kubernetes-Template-Beispiele.

2. Hier sind die dateien nach der Installation zu finden:

```
// profiles as environment variables for services
# ls /etc/kubernetes/
apiserver  config  controller-manager  scheduler
// systemd files
# ls /usr/lib/systemd/system/kube-*
/usr/lib/systemd/system/kube-apiserver.service           /usr/lib/systemd/system/kube-scheduler.service
/usr/lib/systemd/system/kube-controller-manager.service
```

3. Als nächstes werden wir die `systemd` Original einstellungen ändern und die Werte in den Konfigurationsdateien unter dem Verzeichnis `/etc/kubernetes` ändern, um eine Verbindung mit etcd zu erstellen. Die Datei  `config` ist eine gemeinsame Umgebungsdatei für mehrere Kubernetes-Daemon-Prozesse. Für grundlegende Einstellungen, einfach änderungen in der `apiserver` Datei durchführen:

```
# cat /etc/kubernetes/apiserver
###
# kubernetes system config
#
# The following values are used to configure the kube-apiserver
#

# The address on the local server to listen to.
KUBE_API_ADDRESS="--address=0.0.0.0"

# The port on the local server to listen on.
KUBE_API_PORT="--insecure-port=8080"

# Port nodes listen on
# KUBELET_PORT="--kubelet_port=10250"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd_servers=<etcd endpoint URL>:<etcd exposed port>"

# Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=<CIDR of overlay network>"

# default admission control policies
KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"

# Add your own!
KUBE_API_ARGS="--cluster_name=<your cluster name>"
```

4. Dann starten Sie den Daemon `kube-apiserver`, `kube-scheduler` und `kube-controller-manager` eins nach dem anderen; Der Befehl `systemctl` kann für das Management helfen. Seien Sie sich bewusst, dass der `kube-apiserer` immer zuerst anfangen sollte, da der `kube-Scheduler` und der `kube-controller-manager` beim Start mit dem Kubernetes API-Server verbunden sind:

```
// start services
# systemctl start kube-apiserver
# systemctl start kube-scheduler
# systemctl start kube-controller-manager
// enable services for starting automatically while server boots up.
# systemctl enable kube-apiserver
# systemctl enable kube-scheduler
# systemctl enable kube-controller-manager
```

### Hinzufügen von Daemon Abhängigkeiten

1. Obwohl systemd keine Fehlermeldungen ohne den laufenden API-Server zurückgibt, erhalten sowohl der `kube-scheduler` als auch der `kube-controller-manager` Verbindungsfehler und bieten keine regelmäßigen Dienste an:
```
$ sudo systemctl status kube-scheduler -l—output=cat kube-scheduler.service - Kubernetes Scheduler Plugin
   Loaded: loaded (/usr/lib/systemd/system/kube-scheduler.service; enabled)
   Active: active (running) since Thu 2015-11-19 07:21:57 UTC; 5min ago
     Docs: https://github.com/GoogleCloudPlatform/kubernetes
 Main PID: 2984 (kube-scheduler)
   CGroup: /system.slice/kube-scheduler.service
           └─2984 /usr/bin/kube-scheduler—logtostderr=true—v=0 --master=127.0.0.1:8080
E1119 07:27:05.471102    2984 reflector.go:136] Failed to list *api.Node: Get http://127.0.0.1:8080/api/v1/nodes?fieldSelector=spec.unschedulable%3Dfalse: dial tcp 127.0.0.1:8080: connection refused

```

2. Um also die Startreihenfolge zu beeinflussen, können Sie zwei Einstellungen unter dem Abschnitt von `systemd.unit` in `/usr/lib/systemd/system/kube-scheduler` und `/usr/lib/systemd/system/kube-controller-manager`:

```
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=kube-apiserver.service
Wants=kube-apiserver.service
```

Mit den vorherigen Einstellungen können wir sicherstellen, dass der `kube-apiserver` der erste Dämon ist.

3. Darüber hinaus sollte man sicherstellen , dass der Scheduler und der Controller Manager immer mit einem gesunden API-Server zuverlässig laufen, was bedeutet, wenn `kube-apiserver` gestoppt ist, werden auch `kube-scheduler` und der `kube-controller-manager` gestoppt; Sie können `systemd.unit` wenn wir `Wants`, wie folgt zu `Requires` ändern:

`Requires=kube-apiserver.service`


`Requires` hat strengere Einschränkungen.
Falls der daemon `kube-apiserver` abgestürzt ist, würde auch der `kube-scheduler` und der `kube-controller-manager` gestoppt werden.
Auf der anderen Seite ist die Konfiguration mit `Requires` für das Debuggen der Master installation schwer zu benutzen.
Es wird empfohlen, diesen Parameter zu aktivieren, sobald Sie sicherstellen, dass jede Einstellung korrekt ist.


> Wichtig: Für Docker muss unter Centos 7 ein versionlock eingerichetet werden 
>
> `sudo yum install yum-plugin-versionlock`
> Zum hinzufügen
>
> `sudo yum versionlock add docker-ce-cli-*` 
> Wenn nicht daraufgeachetet wurde ist auch noch ein downgrade notwendig
> 
> yum downgrade docker-ce
> rpm -qa | grep docker-ce
> yum list | grep docker-ce
> yum list docker-ce --showduplicates | sort -r

docker-ce-cli-18.09.9-3.el7


### Andere Linux-Optionen

Es ist auch möglich, dass wir eine Binärdatei zur Installation herunterladen. Die offizielle Website für die neueste Version ist hier: https://github.com/kubernetes/kubernetes/releases:

1. Wir werden die Version, die als neues Release markiert ist, installieren und alle Dämonen mit dem Wrapper-Befehl `hyperkube` starten:

```
// download Kubernetes package
# curl -L -O https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v1.1.2/kubernetes.tar.gz

// extract the tarball to specific local, here we put it under /opt. the KUBE_HOME would be /opt/kubernetes
# tar zxvf kubernetes.tar.gz -C /opt/

// copy all binary files to system directory
# cp /opt/kubernetes/server/bin/* /usr/local/bin/
```

2. Der nächste Schritt besteht darin, ein Startskript (init) zu erstellen, das drei Master-Daemons abdecken und individuell starten würde:

```
 cat /etc/init.d/kubernetes-master
#!/bin/bash
#
# This shell script takes care of starting and stopping kubernetes master

# Source function library.
. /etc/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

prog=/usr/local/bin/hyperkube
lockfile=/var/lock/subsys/`basename $prog`
hostname=`hostname`
logfile=/var/log/kubernetes.log

CLUSTER_NAME="<your cluster name>"
ETCD_SERVERS="<etcd endpoint URL>:<etcd exposed port>"
CLUSTER_IP_RANGE="<CIDR of overlay network>"
MASTER="127.0.0.1:8080"
```

3. Um Ihre Kubernetes-Einstellungen einfacher und klarer zu verwalten, werden wir am Anfang dieses Init-Skripts die Deklaration der veränderbaren Variablen setzen. Bitte überprüfen Sie die etcd URL und überschreiben Sie das Netzwerk CIDR, um zu bestätigen, dass sie die gleiche wie Ihre vorherige Installation sind:

```
start() {

  # Start daemon.
  echo $"Starting apiserver: "
  daemon $prog apiserver \
  --service-cluster-ip-range=${CLUSTER_IP_RANGE} \
  --port=8080 \
  --address=0.0.0.0 \
  --etcd_servers=${ETCD_SERVERS} \
  --cluster_name=${CLUSTER_NAME} \
  > ${logfile}_apiserver 2>&1 &

  echo $"Starting controller-manager: "
  daemon $prog controller-manager \
  --master=${MASTER} \
  > ${logfile}_controller-manager 2>&1 &

  echo $"Starting scheduler: "
  daemon $prog scheduler \
  --master=${MASTER} \
  > ${logfile}_scheduler 2>&1 &

  RETVAL=$?
  [ $RETVAL -eq 0 ] && touch $lockfile
  return $RETVAL
}

stop() {
  [ "$EUID" != "0" ] && exit 4
        echo -n $"Shutting down $prog: "
  killproc $prog
  RETVAL=$?
        echo
  [ $RETVAL -eq 0 ] && rm -f $lockfile
  return $RETVAL
}
```

4. Als nächstes fühlen Sie sich frei, die folgenden Zeilen als den letzten Teil in das Skript für allgemeine Service-Nutzung hinzuzufügen:

```
# See how we were called.
case "$1" in
  start)
  start
  ;;
  stop)
  stop
  ;;
  status)
  status $prog
  ;;
  restart|force-reload)
  stop
  start
  ;;
  try-restart|condrestart)
  if status $prog > /dev/null; then
      stop
      start
  fi
  ;;
  reload)
  exit 3
  ;;
  *)
  echo $"Usage: $0 {start|stop|status|restart|try-restart|force-reload}"
  exit 2
esac
```

5. Nun ist es möglich, den Service namens `kubernetes-master` zu starten:
`$sudo service kubernetes-master start`

Hinweis:
Zum Zeitpunkt des Schreibens dieses Buches war die neueste Version von Kubernetes 1.1.2. Also, wir verwenden 1.1.2 in den Beispielen für die meisten Kapitel.

### Überprüfung

1. Nachdem Sie alle drei Dämonen des Master Node gestartet haben, können Sie überprüfen, ob sie ordnungsgemäß ausgeführt werden, indem Sie den Service-Status überprüfen. Sowohl die Befehle, `systemd` und `Service`, können die Protokolle abrufen:

`# systemd status <service name>`

2. Für eine ausführlichere Protokollierung der Geschichte können Sie den Befehl `journalctl` verwenden:

Hier soll die meldung `Started..` erscheinen.

3. Darüber hinaus kann in Kubernetes der Befehl`kubectl`, die Operation durchführen:

```
// check Kubernetes version
# kubectl version
Client Version: version.Info{Major:"1", Minor:"0.3", GitVersion:"v1.0.3.34+b9a88a7d0e357b", GitCommit:"b9a88a7d0e357be2174011dd2b127038c6ea8929", GitTreeState:"clean"}
Server Version: version.Info{Major:"1", Minor:"0.3", GitVersion:"v1.0.3.34+b9a88a7d0e357b", GitCommit:"b9a88a7d0e357be2174011dd2b127038c6ea8929", GitTreeState:"clean"}
```
