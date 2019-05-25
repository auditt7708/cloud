Wie wir wissen, erstellt Docker standardmäßig sechs verschiedene Namespaces - Prozess, Netzwerk, Mount, Hostname, Shared Memory und User für einen Container. In einigen Fällen möchten wir vielleicht einen Namespace zwischen zwei oder mehr Containern teilen. Zum Beispiel, in Kubernetes, alle Container in einem Pod teilen sich die gleichen Netzwerk-Namespace.

In einigen Fällen möchten wir die Namespaces des Host-Systems mit den Containern teilen. Zum Beispiel teilen wir den gleichen Netzwerk-Namespace zwischen dem Host und dem Container, um nahe der Nativen Geschwindigkeit innerhalb des Containers zu bekommen. In diesem Rezept sehen wir, wie man Namensräume zwischen Host und Container freigibt.

### Fertig werden

Ein Host mit der neuesten Version von Docker muss installiert sein, auf den Docker-Client kan zugegriffen werden .

### Wie es geht…

1. Um den Host-Netzwerk-Namespace mit dem Container zu teilen, führen Sie den folgenden Befehl aus:
`$ docker run -it  --net=host fedora bash`

Wenn Sie die Netzwerkdetails im Container sehen, führen Sie den folgenden Befehl aus:
`$ ip a `

Sie sehen ein Ergebnis wie der Gastgeber.

2. Um das Host-Netzwerk, PID und IPC-Namespaces mit dem Container zu teilen, führen Sie den folgenden Befehl aus:
`$ docker run -it --net=host --pid=host --ipc=host fedora bash`

### Wie es funktioniert…

Docker erstellt keine separaten Namensräume für Container, wenn solche Argumente an den Container übergeben werden.

### Es gibt mehr...

Für Hosts, die gebaut werden, um nur Container laufen zu lassen, wie z.B Project Atomic (http://www.projectatomic.io/), die wir in [Docker Orchestration und Hosting](../docker-Orchestration-hosting) gesehen haben, haben wir Debugging-Tools wie tcpdump und Sysstat auf dem Host-System. So haben wir Container mit diesen Tools erstellt und haben Zugriff auf Host-Ressourcen. In solchen Fällen wird das Teilen von Namespaces zwischen dem Host und dem Container praktisch. Sie können mehr darüber über die folgenden Links lesen:

* Http://developerblog.redhat.com/2014/11/06/introducing-a-super-privileged-container-concept/

* Http://developerblog.redhat.com/2015/03/11/introducing-the-rhel-container-for-rhel-atomic-host/

### Siehe auch

Dan Walshs Dokumentation über Docker Security unter http://opensource.com/business/15/3/docker-security-tuning