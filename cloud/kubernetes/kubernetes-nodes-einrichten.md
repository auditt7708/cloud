---
title: kubernetes-nodes-einrichten
description: 
published: true
date: 2021-06-09T15:35:21.452Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:35:14.503Z
---

Ein Node ist der Slave im Kubernetes-Cluster. Um den Meister einen Node unter seiner Aufsicht zu lassen, installiert der Node einen Agenten namens Kubelet, um sich an einen bestimmten Master zu registrieren. Nach der Registrierung, behandelt der Daemon Kubelet auch Container-Operationen und Berichte Ressourcen-Utilities und Container-Status an den Master. Der andere Dämon, der auf dem Node läuft, ist der Kube-Proxy, der TCP/UDP-Pakete zwischen Containern verwaltet. In diesem Abschnitt zeigen wir Ihnen, wie Sie einen Node konfigurieren können.

### Fertig werden

Da der Node der Arbeiter von Kubernetes ist und die wichtigste Aufgabe Container sind, muss man sicherstellen, dass Docker und flanneld am Anfang installiert sind. Kubernetes setzt auf Docker, die Anwendungen in Containern laufen lassen. Und durch flanneld können die pods auf getrennten nodes miteinander kommunizieren.

Nachdem Sie die beiden Daemons installiert haben, sollte die Netzwerkschnittstelle docker0 entsprechend der Datei `/run/flannel/subnet.env` unter demselben LAN wie `flannel0` sein:

```
# cat /run/flannel/subnet.env
FLANNEL_SUBNET=192.168.31.1/24
FLANNEL_MTU=8973
FLANNEL_IPMASQ=true

// check the LAN of both flanneld0 and docker0
# ifconfig docker0 ; ifconfig flannel0
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 192.168.31.1  netmask 255.255.255.0  broadcast 0.0.0.0
        ether 02:42:6e:b9:a7:51  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
flannel0: flags=81<UP,POINTOPOINT,RUNNING>  mtu 8973
        inet 192.168.31.0  netmask 255.255.0.0  destination 192.168.11.0
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 500  (UNSPEC)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


```
Wenn sich `docker0` in einem anderen CIDR-Bereich befindet, können Sie die folgenden Service-Scripts als Referenz für eine zuverlässige Docker-Service-Einrichtung verwenden:
```
# cat /etc/sysconfig/docker
# /etc/sysconfig/docker
#
# Other arguments to pass to the docker daemon process
# These will be parsed by the sysv initscript and appended
# to the arguments list passed to docker -d, or docker daemon where docker version is 1.8 or higher

. /run/flannel/subnet.env 

other_args="--bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}"
DOCKER_CERT_PATH=/etc/docker
```
Alternativ kann die Konfiguration auch systematisch die Abhängigkeit behandeln:
```
$ cat /etc/systemd/system/docker.service.requires/flanneld.service
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
Before=docker.service

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/flanneld
EnvironmentFile=-/etc/sysconfig/docker-network
ExecStart=/usr/bin/flanneld -etcd-endpoints=${FLANNEL_ETCD} -etcd-prefix=${FLANNEL_ETCD_KEY} $FLANNEL_OPTIONS
ExecStartPost=/usr/libexec/flannel/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker

[Install]
RequiredBy=docker.service

$ cat /run/flannel/docker
DOCKER_OPT_BIP="--bip=192.168.31.1/24"
DOCKER_OPT_MTU="--mtu=8973"
DOCKER_NETWORK_OPTIONS=" --bip=192.168.31.1/24 --mtu=8973 "
```

Sobald Sie das Docker-Service-Skript auf ein korrektes geändert haben, stoppen Sie den Docker-Dienst, bereinigen Sie die Netzwerkschnittstelle und starten Sie es erneut.

Sie können sogar einen Master an den Node konfigurieren. Installiere einfach die notwendigen Dämonen.

### Wie es geht…

Sobald Sie überprüft haben, dass Docker und flanneld gut auf Ihrem Knotenhost gehen, fahren Sie fort, das Kubernetes Paket für den Node zu installieren. Wir decken sowohl RPM- als auch Tarball-Setup ab.

### Installation

Dies ist das gleiche wie die Kubernetes Master-Installation, Linux OS mit dem Kommandozeilen-Tool `yum`, das Paket-Management-Dienstprogramm, kann leicht  das Nodenpaket installieren. Auf der anderen Seite sind wir auch in der Lage, die neueste Version zu installieren, indem wir eine Tarball-Datei herunterladen und Binärdateien in das angegebene Systemverzeichnis kopieren, das für jede Linux-Distribution geeignet ist. Sie können die Lösungen für Ihre Bereitstellung ausprobieren.

### CentOS 7 oder Red Hat Enterprise Linux 7

1. Zuerst werden wir das Paket `kubernetes-node` installieren, was wir für den Node benötigen:
```
// install kubernetes node package
$ yum install kubernetes-node
```

Das Paket `kubernetes-node` enthält zwei Daemon-Prozesse, `kubelet` und `kube-Proxy`.

2. Wir müssen zwei Konfigurationsdateien ändern, um auf den Masterknoten zuzugreifen:
```
# cat /etc/kubernetes/config
###
# kubernetes system config
#
# The following values are used to configure various aspects of all
# kubernetes services, including
#
#   kube-apiserver.service
#   kube-controller-manager.service
#   kube-scheduler.service
#   kubelet.service
#   kube-proxy.service
# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"

# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow_privileged=false"

# How the controller-manager, scheduler, and proxy find the apiserver
KUBE_MASTER="--master=<master endpoint>:8080"
```
3. In der Konfigurationsdatei ändern wir das Master-Standort-Argument in die URL / IP der Maschine, wo Sie den Master installiert haben. Wenn Sie einen anderen exponierten Port für den API-Server angegeben haben, denken Sie daran, es auch zu aktualisieren, anstelle von Port `8080`:
```
# cat /etc/kubernetes/kubelet
###
# kubernetes kubelet (node) config

# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
# KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
KUBELET_HOSTNAME="--hostname_override=127.0.0.1"

# location of the api-server
KUBELET_API_SERVER="--api_servers=<master endpoint>:8080"

# Add your own!
KUBELET_ARGS=""

```
Wir öffnen die Kubelet-Adresse für alle Schnittstellen und den verbundenen Master standort.

4. Dann ist es gut, Dienste mit dem Befehl `systemd` zu starten. Es gibt keine Abhängigkeit zwischen `kubelet` und `kube-proxy`:
```
Wir öffnen die Kubelet-Adresse für alle Schnittstellen und den angeschlossenen Masterstandort.

Dann ist es gut, Dienste mit dem Befehl systemd zu starten. Es gibt keine Abhängigkeit zwischen `kubelet` und `kube-proxy`:
```
### Andere Linux-Optionen

1. Wir können auch die neuesten Kubernetes Binärdateien herunterladen und ein kundenspezifisches Service-Init-Skript für die Knotenkonfiguration schreiben. Das Tarball von Kubernetes 'neuesten Updates wird unter https://github.com/kubernetes/kubernetes/releases veröffentlicht:
```
// download Kubernetes package
# curl -L -O https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v1.1.2/kubernetes.tar.gz

// extract the tarball to specific local, here we put it under /opt. the KUBE_HOME would be /opt/kubernetes
# tar zxvf kubernetes.tar.gz -C /opt/

// copy all binary files to system directory
# cp /opt/kubernetes/server/bin/* /usr/local/bin/
```

2. Als nächstes wird unter `/etc/init.d` eine Datei namens `kubernetes-node` mit folgendem Inhalt erstellt:
```
# cat /etc/init.d/kubernetes-node
#!/bin/bash
#
# kubernetes    This shell script takes care of starting and stopping kubernetes

# Source function library.
. /etc/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

prog=/usr/local/bin/hyperkube
lockfile=/var/lock/subsys/`basename $prog`
MASTER_SERVER="<master endpoint>"
hostname=`hostname`
logfile=/var/log/kubernetes.log

```

3. Achten Sie darauf, die Master-URL / IP für den Zugriff auf den Kubernetes API-Server zur Verfügung zu stellen. Wenn Sie versuchen, ein Knotenpaket auch auf dem Master-Host zu installieren, was bedeutet, dass Master auch als Node arbeitet kann, sollte der API-Server auf dem lokalen Host arbeiten. Dann können Sie `localhost` oder `127.0.0.1` bei `<master endpoint>` anhängen:

```
start() {
    # Start daemon.
    echo $"Starting kubelet: "
    daemon $prog kubelet \
        --api_servers=http://${MASTER_SERVER}:8080 \
        --v=2 \
        --address=0.0.0.0 \
        --enable_server \
        --hostname_override=${hostname} \
        > ${logfile}_kubelet 2>&1 &

    echo $"Starting proxy: "
    daemon $prog proxy \
        --master=http://${MASTER_SERVER}:8080 \
        --v=2 \
        > ${logfile}_proxy 2>&1 &

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

4. Die folgenden Zeilen sind für das allgemeine Daemon-Management, indem sie sie in das Skript, um die Funktionalitäten erweitern die Sie brauchen:
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

5. Nun können Sie den Service mit dem Namen Ihres `Init`-Skripts starten:
`# service kubernetes-node start`

### Überprüfung

Um zu überprüfen, ob ein Knoten gut konfiguriert ist, wäre der einfache Weg, um es von der Masterseite zu überprüfen:
```
// push command at master
# kubelet get nodes
NAME                               LABELS                                                    STATUS
ip-10-97-217-56.sdi.trendnet.org   kubernetes.io/hostname=ip-10-97-217-56.sdi.trendnet.org   Ready
```
### Siehe auch

Es wird auch empfohlen, die Rezepte über die Architektur der Cluster- und Systemumgebung zu lesen. Da der Kubernetesknoten wie ein Arbeiter ist, der Aufgaben erhält und den anderen zuhört; Sie sollten nach den anderen Komponenten gebaut werden. Es ist gut für Sie, sich mit dem ganzen System vertraut zu machen, bevor Sie Nodes einrichten. Darüber hinaus können Sie auch die Ressource in Nodes verwalten. Bitte überprüfen Sie die folgenden Rezepte für weitere Informationen:

*      Architektur erforschen

*      Vorbereitung der Umgebung