Um die Kubernetes-Cluster-Informationen zu erhalten, müssen wir den Datenspeicher einrichten. Kubernetes verwendet etcd als Standard-Datenspeicher. Dieser Abschnitt führt Sie zum Aufbau des etcd-Servers.

### Wie es geht…

Die etcd-Datenbank erfordert Linux-Betriebssystem; Einige Linux-Distributionen bieten das etcd-Paket und einige nicht. Dieser Abschnitt beschreibt die Installation von etcd.

### Red Hat Enterprise Linux 7 oder CentOS 7

Red Hat Enterprise Linux (RHEL) 7, CentOS 7 oder höher hat ein offizielles Paket für etcd. Sie können über den `yum` Befehl wie folgt installieren:
```
//it will perform to install etcd package on RHEL/CentOS Linux
sudo yum update -y
sudo yum install etcd 
```

### Ubuntu Linux 15.10 Wily Werewolf

Ubuntu 15.10 or later has an official package for etcd as well. You can install via the `apt-get` command as follows:
```
//it will perform to install etcd package on Ubuntu Linux
sudo apt-get update -y
sudo apt-get install etcd
```

### Andere Linux Umgebungen

Wenn Sie eine andere Linux-Version wie Amazon Linux verwenden, können Sie eine Binärdatei von der offiziellen Website herunterladen und wie folgt installieren.
Laden Sie eine Binärdatei herunter

Etcd wird über https://github.com/coreos/etcd/releases zur Verfügung gestellt. OS X (darwin-amd64), Linux, Windows Binär und Quellcode stehen zum Download zur Verfügung.

Verwenden Sie auf Ihrem Linux-Rechner den Befehl curl, um die Datei etcd-v2.2.1-linux-amd64.tar.gz herunterzuladen:

```
// follow redirection(-L) and use remote name (-O)
curl -L -O https://github.com/coreos/etcd/releases/download/v2.2.1/etcd-v2.2.1-linux-amd64.tar.gz
```

### Erstellen eines Benutzers

Aus Sicherheitsgründen können Sie einen neuen Benutzer und eine Gruppe, die eigene etcd besitzen können anlegen:

1. Führen Sie das `useradd` kommando aus:
```
//options
//    create group(-U), home directory(-d), and create it(-m)
//    name in GCOS field (-c), login shell(-s)
$ sudo useradd -U -d /var/lib/etcd -m -c "etcd user" -s /sbin/nologin etcd
```

2. Sie können `/etc/passwd` überprüfen, um zu sehen, ob das Ausführen von `etcd user` einen Benutzer erstellt hat oder nicht:
```
//search etcd user on /etc/passwd, uid and gid is vary
$ grep etcd /etc/passwd
etcd:x:997:995:etcd user:/var/lib/etcd:/sbin/nologin
```

### Tip
Sie können jederzeit einen Benutzer löschen; mit `sudo userdel -r etcd ` zum löschen etcd Benutzer.

### Install etcd

1. Nach dem Herunterladen einer etcd-Binärdatei verwenden Sie den Befehl `tar`, um Dateien zu extrahieren:
```
$ tar xf etcd-v2.2.1-linux-amd64.tar.gz 
$ cd etcd-v2.2.1-linux-amd64

//use ls command to see that there are documentation and binaries 
$ ls
Documentation  README-etcdctl.md  README.md  etcd  etcdctl 
```

2. Es gibt `etcd` daemon und `etcdctl` Befehl, die kopiert werden müssen nach `/usr/local/bin`. Erstellen Sie auch `/etc/etcd/etcd.conf` als Einstellungsdatei:
```
$ sudo cp etcd etcdctl /usr/local/bin/

//create etcd.conf
$ sudo mkdir -p /etc/etcd/
$ sudo touch /etc/etcd/etcd.conf
$ sudo chown -R etcd:etcd /etc/etcd
```

### Wie es funktioniert…

Lassen Sie uns testen ob der `etcd` Daemon und die etcd Funktionalitäten funktionieren. Geben Sie den Befehl `etcd` mit dem `namen` und das `data-dir` als Argument wie folgt ein:
```
//for the testing purpose, create data file under /tmp
$ etcd --name happy-etcd --data-dir /tmp/happy.etcd &
```

Nun können Sie versuchen, den Befehl `etcdctl` zu verwenden, um auf etcd zuzugreifen und die Daten wie folgt zu laden und zu speichern:
```
//set value "hello world" to the key /my/happy/data 
$ etcdctl set /my/happy/data "hello world"

//get value for key /my/happy/data
$ etcdctl get /my/happy/data
hello world
```
Darüber hinaus öffnet etcd den standard TCP Port 2379, um auf die RESTful API zuzugreifen, also können Sie auch versuchen, einen HTTP-Client zu verwenden, z. B. den curl-Befehl, um auf Daten wie folgt zuzugreifen:
```
//get value for key /my/happy/data using cURL
$ curl -L http://localhost:2379/v2/keys/my/happy/data
{"action":"get","node":{"key":"/my/happy/data","value":"hello world","modifiedIndex":4,"createdIndex":4}}

//set value "My Happy world" to the key /my/happy/data using cURL
$ curl http://127.0.0.1:2379/v2/keys/my/happy/data -XPUT -d value="My Happy world"

//get value for key /my/happy/data using etcdctl 
$ etcdctl get /my/happy/data
My Happy world
```

Okay! Nun können Sie den Schlüssel mit dem Befehl curl wie folgt löschen:

```
$ curl http://127.0.0.1:2379/v2/keys/my?recursive=true -XDELETE

//no more data returned afterword
$ curl http://127.0.0.1:2379/v2/keys/my/happy/data
{"errorCode":100,"message":"Key not found","cause":"/my","index":10}

$ curl http://127.0.0.1:2379/v2/keys/my/happy
{"errorCode":100,"message":"Key not found","cause":"/my","index":10}

$ curl http://127.0.0.1:2379/v2/keys/my
{"errorCode":100,"message":"Key not found","cause":"/my","index":10}
```

### Auto-Start-Skript

Basierend auf Ihrem Linux, entweder systemd oder init, gibt es verschiedene Möglichkeiten, um ein Auto-Start-Skript zu erstellen.

Wenn Sie nicht sicher sind, überprüfen Sie die Prozess-ID `1` auf Ihrem System. Geben Sie `ps -P1` ein, um den Prozessnamen wie folgt zu sehen:
```
//This Linux is systemd based
$ ps -P 1
  PID PSR TTY      STAT   TIME COMMAND
    1   0 ?        Ss     0:03 /usr/lib/systemd/systemd --switched-root –system
```

```
//This Linux is init based
# ps -P 1
  PID PSR TTY      STAT   TIME COMMAND
    1   0 ?        Ss     0:01 /sbin/init
```

### Startup-Skript (systemd)

Wenn Sie Systemd-basiertes Linux wie RHEL 7, CentOS 7, Ubuntu 15.4 oder höher verwenden, müssen Sie die Datei `/usr/lib/systemd/system/etcd.service` wie folgt vorbereiten:
```
[Unit]
Description=Etcd Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=/etc/etcd/etcd.conf
User=etcd
ExecStart=/usr/local/bin/etcd

[Install]
WantedBy=multi-user.target
```

Danach aktiviren Sie das erstellte startup Script mit dem Befehl systemctl wie folgt:
`# sudo systemctl enable etcd`

Dann starten Sie das System neu oder geben Sie `sudo systemctl start etcd` ein, um den etcd-Daemon zu starten. Sie können den etcd-Service-Status mit `sudo systemctl status -l etcd `überprüfen.

### Startup-Skript (init)

Wenn Sie das init-basierte Linux wie Amazon Linux verwenden, verwenden Sie die traditionelle Methode, um das /etc/init.d/etcd-Skript wie folgt vorzubereiten:
```
#!/bin/bash
#
# etcd This shell script takes care of starting and stopping etcd
#
# chkconfig: - 60 74
# description: etcd

### BEGIN INIT INFO
# Provides: etcd
# Required-Start: $network $local_fs $remote_fs
# Required-Stop: $network $local_fs $remote_fs
# Should-Start: $syslog $named ntpdate
# Should-Stop: $syslog $named
# Short-Description: start and stop etcd
# Description: etcd
### END INIT INFO

# Source function library.
. /etc/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

prog=/usr/local/bin/etcd
etcd_conf=/etc/etcd/etcd.conf
lockfile=/var/lock/subsys/`basename $prog`
hostname=`hostname`

start() {
  # Start daemon.
. $etcd_conf
  echo -n $"Starting $prog: "
  daemon --user=etcd $prog > /var/log/etcd.log 2>&1 &
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
  restart)
  stop
  start
  ;;
  reload)
  exit 3
  ;;
  *)
  echo $"Usage: $0 {start|stop|status|restart|reload}"
  exit 2
esac
```

Danach registrieren Sie den Service mit dem Befehl `chkconfig` wie folgt in das init-Skript:
```
//set file permission correctly
$ sudo chmod 755 /etc/init.d/etcd
$ sudo chown root:root /etc/init.d/etcd

//auto start when boot Linux
$ sudo chkconfig --add etcd
$ sudo chkconfig etcd on
```

Dann starten Sie das System neu oder geben Sie /etc/init.d/etcd ein, um den etcd-Daemon zu starten.

### Konfiguration

Es gibt die Datei /etc/etcd/etcd.conf, um die Konfiguration von etcd zu ändern, z. B. Datendateienpfad und TCP-Portnummer.

Die minimale Konfiguration ist wie folgt:

|NAME|Zweck|Beispiel|Notiz|
| :---: | :---: | :---: | :---: |
|||||
|||||
|||||
|||||
|||||