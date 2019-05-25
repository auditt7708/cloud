Kubernetes abstrahiert die Vernetzung, um die Kommunikation zwischen Containern über Knoten zu ermöglichen. Die Grundeinheit, die es möglich macht, heißt pod, das ist die kleinste Einsatzeinheit in Kubernetes mit einem gemeinsamen Kontext in einer Containerumgebung. Container innerhalb einer Pod können mit anderen über den Hafen mit dem localhost kommunizieren. Kubernetes wird die Pods über die Knoten einsetzen.

Dann, wie gehen Pods miteinander?

Kubernetes verteilt jedem Pod eine IP-Adresse in einem freigegebenen Netzwerk-Namespace, so dass Pods mit anderen Pods über das Netzwerk kommunizieren können. Es gibt ein paar Möglichkeiten, um die Umsetzung zu erreichen. Die einfachste und quer über die Plattform Weg wird mit Flanell.

Flanell gibt jedem Host ein IP-Subnetz, das von Docker akzeptiert werden kann und die IPs den einzelnen Containern zuordnen kann. Flanell verwendet etcd, um die IP-Mapping-Informationen zu speichern, und hat ein paar Backend-Entscheidungen für die Weiterleitung der Pakete. Die einfachste Backend-Wahl würde TUN-Gerät verwenden, um IP-Fragment in einem UDP-Paket zu verkapseln. Der Port ist standardmäßig 8285.

Flanell unterstützt auch In-Kernel VXLAN als Backend, um die Pakete zu verkapseln. Es könnte eine bessere Leistung als UDP-Backend bieten, während es nicht im Benutzerbereich läuft. Eine weitere beliebte Wahl ist die Verwendung der erweiterten Routing-Regel auf Google Cloud Engine (https://cloud.google.com/compute/docs/networking#routing). Wir verwenden sowohl UDP als auch VXLAN als Beispiele in diesem Abschnitt.

Flanneld ist der Agent von Flanell, der verwendet wird, um die Informationen von etcd zu beobachten, das Subnetz-Leasing auf jedem Host zuzuordnen und die Pakete zu leiten. Was wir in diesem Abschnitt tun werden, ist, dass flanneld auf und läuft und ein Subnetz für jeden Host zuordnen wird.

#### Notiz

Wenn Sie kämpfen, um herauszufinden, welches Backend verwendet werden soll, hier ist ein einfacher Performance-Test zwischen UDP und VXLAN. Wir verwenden qperf (http://linux.die.net/man/1/qperf), um die Paketübertragungsleistung zwischen den Containern zu messen. TCP Streaming One Way Bandbreite durch UDP ist 0,3x langsamer als VXLAN, wenn es einige Lasten auf den Hosts. Wenn Sie es vorziehen, Kubernetes auf der Wolke zu bauen, ist GCP die einfachste Wahl.

### Fertig werden

Bevor Sie flannel installieren, stellen Sie sicher, dass Sie den etcd Endpunkt haben. Flanell braucht etcd als seinen Datenspeicher. Wenn Docker läuft, stoppen Sie zuerst den Docker-Dienst und löschen Sie `docker0`, was eine virtuelle Brücke ist, die von Docker erstellt wurde:
```
# Stop docker service
$ service docker stop

# delete docker0
$ ip link delete docker0
```

### Installation

Mit dem Befehl `etcdctl` haben wir im vorherigen Abschnitt auf der etcd-Instanz gelernt, die gewünschte Konfiguration in etcd mit dem Schlüssel `/coreos.com/network/config` einfügen:

|Konfigurations Key|Beschreibung|
| :---: | :---: |
|`Network`| IPv4-Netzwerk für flannel, um das gesamte virtuelle Netzwerk zuzuordnen|
|`SubnetLen`|Die Subnetz-Präfixlänge für jeden Host ist standardmäßig `24`.|
| `SubnetMin` |Der Anfang des IP-Bereichs für die flannel-Subnetz-Zuweisung|
| `SubnetMax` |Das Ende des IP-Bereichs für die flannel-Subnetz-Zuordnung|
|`Backend`|Backend-Auswahlmöglichkeiten für die Weiterleitung der Pakete. Standard ist `udp`.|

```
# insert desired CIDR for the overlay network Flannel creates
$ etcdctl set /coreos.com/network/config '{ "Network": "192.168.0.0/16" }'
```

flannel wird die IP-Adresse innerhalb von `192.168.0.0/16` für Overlay-Netzwerk mit `/24` für jeden Host standardmäßig zuweisen, aber Sie können auch die Standardeinstellung überschreiben und in etcd einfügen:
```
$ cat flannel-config-udp.json
{
    "Network": "192.168.0.0/16",
    "SubnetLen": 28,
    "SubnetMin": "192.168.10.0",
    "SubnetMax": "192.168.99.0",
    "Backend": {
        "Type": "udp",
        "Port": 7890
    }
}
```

Verwenden Sie den Befehl `etcdctl`, um die Konfiguration von `flannel-config-udp.json` einzufügen:
```
# insert the key by json file
$ etcdctl set /coreos.com/network/config < flannel-config-udp.json
```

Dann wird Flannel jedem Host mit `/28` Subnetz zuordnen und nur die Subnetze innerhalb von `192.168.10.0` und `192.168.99.0` ausgeben. Backend wird immer noch `udp` und der Default-Port wird von `8285` auf `7890` geändert.

Wir könnten auch VXLAN verwenden, um die Pakete abzukapseln und `etcdctl` zu verwenden, um die Konfiguration einzufügen:
```
$ cat flannel-config-vxlan.json
{
    "Network": "192.168.0.0/16",
    "SubnetLen": 24,
    "Backend": {
        "Type": "vxlan",
        "VNI": 1
    }
}

# insert the key by json file
$ etcdctl set /coreos.com/network/config < flannel-config-vxlan.json
```

Sie können die Konfiguration sehen, die Sie mit etcdctl verwenden:
```
$ etcdctl get /coreos.com/network/config
{
    "Network": "192.168.0.0/16",
    "SubnetLen": 24,
    "Backend": {
        "Type": "vxlan",
        "VNI": 1
     }
}
```

### CentOS 7 oder Red Hat Enterprise Linux 7

RHEL 7, CentOS 7 oder später hat ein offizielles Paket für flannel. Sie können es über den yum-Befehl installieren:
```
# install flannel package
$ sudo yum install flannel
```

Nach der Installation müssen wir den etcd-Server konfigurieren, um den flannel service nutzen zu können:
```
$ cat /etc/sysconfig/flanneld

# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD="<your etcd server>"

# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_KEY="/coreos.com/network"

# Any additional options that you want to pass
#FLANNEL_OPTIONS=""
```

Wir sollten immer prüfen das `flanneld`  immer läuft, wenn wir den Server hochfahren wird. Mit systemctl könnte man es folgender maßen erreichen:
```
# Enable flanneld service by default
$ sudo systemctl enable flanneld

# start flanneld
$ sudo service flanneld start

# check if the service is running
$ sudo service flannel status
```
### Andere Linux-Optionen

Sie können immer eine Binärdatei als Alternative herunterladen. Die CoreOS flannel offizielle Release-Seite ist hier: https://github.com/coreos/flannel/releases. Wählen Sie die Pakete mit dem neuesten Release-Tag aus version 2. Es wird immer die neuesten Fehlerkorrekturen enthalten:
```
# download flannel package
$ curl -L -O https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz

# extract the package
$ tar zxvf flannel-0.5.5-linux-amd64.tar.gz

# copy flanneld to $PATH
$ sudo cp flannel-0.5.5/flanneld /usr/local/bin
```

Wenn du ein Start-Skript (Systemd) im etcd-Bereich benutzt, kannst du auch die gleiche wie bestimmen, um flanneld zu beschreiben:
```
$ cat /usr/lib/systemd/system/flanneld.service
[Unit]
Description=Flanneld overlay address etcd agent
Wants=etcd.service
After=etcd.service
Before=docker.service

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/flanneld
EnvironmentFile=-/etc/sysconfig/docker-network
ExecStart=/usr/bin/flanneld -etcd-endpoints=${FLANNEL_ETCD} -etcd-prefix=${FLANNEL_ETCD_KEY} $FLANNEL_OPTIONS
Restart=on-failure

RestartSec=5s

[Install]
WantedBy=multi-user.target
```

Dann aktivieren Sie den Dienst beim Booten mit` sudo systemctl enable flanneld`.

Alternativ können Sie ein Startup-Skript (init) unter /etc/init.d/flanneld verwenden, wenn Sie ein init-basiertes Linux verwenden:
```
#!/bin/bash

# flanneld  This shell script takes care of starting and stopping flanneld
#

# Source function library.
. /etc/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

prog=/usr/local/bin/flanneld
lockfile=/var/lock/subsys/`basename $prog`
```

Nachdem Sie die Variablen abgelegt und eingestellt haben, sollten Sie den Start starten, den Status stoppen und den Dienst neu starten. 

```
start() {
  # Start daemon.
  echo -n $"Starting $prog: "
  daemon $prog \
    --etcd-endpoints=="<your etcd server>" \
    -ip-masq=true \
    > /var/log/flanneld.log 2>&1 &
  RETVAL=$?
  echo
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

#### Tip
Wenn Flanell beim Anfahren stecken bleibt

Prüfe ob der etcd Endpunkt  zugänglich ist und der Schlüssel in FLANNEL_ETCD_KEY aufgeführt ist:
```
# FLANNEL_ETCD_KEY="/coreos.com/network/config"
$ curl -L http://<etcd endpoint>:2379/v2/keys/coreos.com/network/config `
```

Du könntest auch Flanell-Logs mit `sudo journalctl -u flanneld` ausprobieren.

Nachdem der Flanell-Service gestartet ist, solltest du eine Datei in `/run/flannel/subnet.env` und die `flannel0`-Brücke in ifconfig sehen können.

### Wie es geht…

Um sicherzustellen, dass Flanell gut funktioniert und die Pakete aus der virtuellen Docker-Schnittstelle überträgt, müssen wir sie mit Docker integrieren.

### Flanell-Netzwerkkonfiguration

1. Nachdem `flanneld` auf- und ablaufen, verwenden Sie die `ifconfig`- oder `ip`-Befehle, um zu sehen, ob es eine `flannel0` virtuelle Brücke in der Schnittstelle gibt:
```
# check current ipv4 range
$ ip a | grep flannel | grep inet
    inet 192.168.50.0/16 scope global flannel0
```
Wir können aus dem vorstehenden Beispiel sehen, die Subnet-Lease von flannel0 ist 192.168.50.0/16.

2. Immer wenn Ihr `flanneld` startet, wird Flannel das Subnetz-Leasing abwarten und in etcd speichern und dann die Umgebungsvariablen-Datei in `/run/flannel/subnet.env` standardmäßig schreiben oder den Standardpfad mit der `--subnet-file` ändern Parameter beim Starten:
```
# check out flannel subnet configuration on this host
$ cat /run/flannel/subnet.env
FLANNEL_SUBNET=192.168.50.1/24
FLANNEL_MTU=1472
FLANNEL_IPMASQ=true
```

### Integration mit Docker

Es gibt ein paar Parameter, die vom Docker-Daemon unterstützt werden. In `/run/flannel/subnet.env` hat flannel bereits ein Subnetz mit den vorgeschlagenen MTU- und IPMASQ-Einstellungen vergeben. Die entsprechenden Parameter im Docker sind:

|Parameter|Bedeutung|
| :---: | :---:|
| `--bip=""` |Geben Sie die Netzwerkbrücke IP an (`docker0`)|
|`--mtu=0`|Setzen Sie das Containernetzwerk MTU (für `docker0` und veth)|
|`--ip-masq=true`|(Optional) IP-Masquerading aktivieren|

1. Wir könnten die in `/run/flannel/subnet.env` aufgeführten Variablen in den Docker-Daemon eintragen:
```
# import the environment variables from subnet.env
$ . /run/flannel/subnet.env

# launch docker daemon with flannel information
$ docker -d --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}
# Or if your docker version is 1.8 or higher, use subcommand daemon instead
$ docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}
```

2. Alternativ können Sie sie auch in `OPTIONS` von `/etc/sysconfig/docker` angeben, welches die Docker-Konfigurationsdatei in CentOS ist:
```
### in the file - /etc/sysconfig/docker
# set the variables into OPTIONS 
$ OPTIONS="--bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} --ip-masq=${FLANNEL_IPMASQ}"

```

Im vorherigen Beispiel ist `${FLANNEL_SUBNET}` ersetzt durch `192.168.50.1/24` und `${FLANNEL_MTU} `ist `1472` im `/etc/sysconfig/docker`.

### Wie es funktioniert…

Es gibt zwei virtuelle Brücken namens `flannel0` und `docker0`, die in den vorherigen Schritten erstellt wurden. Lassen Sie uns einen Blick auf ihren IP-Bereich mit dem `ip`-Befehl werfen:
```
# checkout IPv4 network in local
$ ip -4 a | grep inet
    inet 127.0.0.1/8 scope host lo
    inet 10.42.1.171/24 brd 10.42.21.255 scope global dynamic ens160
    inet 192.168.50.0/16 scope global flannel0
    inet 192.168.50.1/24 scope global docker0

```
Host-IP-Adresse ist `10.42.1.171/24`, `flannel0` ist `192.168.50.0/16`, `docker0` ist `192.168.50.1/24` und die Route ist für den IP-Bereich eingestellt:
```
# check the route 
$ route -n 
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.42.1.1       0.0.0.0         UG    100    0        0 ens160
192.168.0.0     0.0.0.0         255.255.0.0     U     0      0        0 flannel0
192.168.50.0    0.0.0.0         255.255.255.0   U     0      0        0 docker0
```

Lass uns ein bisschen tiefer gehen, um zu sehen, wie etcd die flannel-Subnetz-Informationen speichert. Sie können die Netzwerkkonfiguration mit dem Befehl `etcdctl` in etcd abrufen:

```
# get network config
$ etcdctl get /coreos.com/network/config
{ "Network": "192.168.0.0/16" }

# show all the subnet leases
$ etcdctl ls /coreos.com/network/subnets
/coreos.com/network/subnets/192.168.50.0-24
```

Das vorstehende Beispiel zeigt, dass das Netzwerk CIDR `192.168.0.0/16` ist. Es gibt eine Subnet-Lease. Überprüfe den Wert der Taste; Es ist genau die IP-Adresse von `eth0` auf dem Host:

```
# show the value of the key of `/coreos.com/network/subnets/192.168.50.0-24`
$ etcdctl get /coreos.com/network/subnets/192.168.50.0-24
{"PublicIP":"10.42.1.171"}
```

Wenn Sie andere Backend-Lösungen anstelle von einfachem UDP verwenden, sehen Sie möglicherweise mehr Konfiguration wie folgt:
```
# show the value when using different backend
$ etcdctl get /coreos.com/network/subnets/192.168.50.0-24
{"PublicIP":"10.97.1.171","BackendType":"vxlan","BackendData":{"VtepMAC":"ee:ce:55:32:65:ce"}}
```

Im Folgenden finden Sie eine Illustration, wie ein Paket von **Pod1** durch das Overlay-Netzwerk nach **Pod4** geht. Wie wir bereits besprochen haben, hat jeder Pod eine eigene IP-Adresse und das Paket ist eingekapselt, so dass pod IPs routbar sind. Das Paket von **Pod1** wird durch das veth (virtuelle Netzwerkschnittstelle) Gerät gehen, das mit docker0 verbindet und Routen zu **flannel0** führt. Der Verkehr wird durch flanneld eingekapselt und an den Host (**10.42.1.172**) des Zielpods gesendet.

![flannel0-digram](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_01_06.jpg)

Lass uns einen einfachen Test durchführen, indem wir zwei einzelne Container laufen lassen, um zu sehen, ob Flanell gut funktioniert. Angenommen, wir haben zwei Hosts (10.42.1.171 und 10.42.1.172) mit verschiedenen Subnetzen, die von Flannel mit dem gleichen etcd Backend zugewiesen werden und haben Docker ausgeführt von Docker laufen -ein ubuntu / bin / bash in jedem Host:

**Container 1 auf host 1 (10.42.1.171)**

```
root@0cd2a2f73d8e:/# ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 02:42:c0:a8:3a:08
          inet addr:192.168.50.2  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::42:c0ff:fea8:3a08/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:8951  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:648 (648.0 B)  TX bytes:648 (648.0 B)
root@0cd2a2f73d8e:/# ping 192.168.65.2
PING 192.168.4.10 (192.168.4.10) 56(84) bytes of data.
64 bytes from 192.168.4.10: icmp_seq=2 ttl=62 time=0.967 ms
64 bytes from 192.168.4.10: icmp_seq=3 ttl=62 time=1.00 ms
```

**Container 2 auf host 2 (10.42.1.172)**


``` 
root@619b3ae36d77:/# ifconfig eth0

eth0      Link encap:Ethernet  HWaddr 02:42:c0:a8:04:0a
          inet addr:192.168.65.2  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::42:c0ff:fea8:40a/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:8973  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:648 (648.0 B)  TX bytes:648 (648.0 
```

Wir können sehen, dass zwei Container mit Ping miteinander kommunizieren können. Lassen Sie uns das Paket mit `tcpdump` in `host2` beobachten, das ein Befehlszeilentool ist, das helfen kann, Verkehr in einem Netzwerk zu Dumpen:
```
# install tcpdump in container
$ yum install -y tcpdump

# observe the UDP traffic from host2
$ tcpdump host 10.42.1.172 and udp
11:20:10.324392 IP 10.42.1.171.52293 > 10.42.1.172.6177: UDP, length 106
11:20:10.324468 IP 10.42.1.172.47081 > 10.42.1.171.6177: UDP, length 106
11:20:11.324639 IP 10.42.1.171.52293 > 10.42.1.172.6177: UDP, length 106
11:20:11.324717 IP 10.42.1.172.47081 > 10.42.1.171.6177: UDP, length 106
```

Der Verkehr zwischen den Containern ist in UDP durch Port `6177` unter Verwendung von Flanneld eingekapselt.

