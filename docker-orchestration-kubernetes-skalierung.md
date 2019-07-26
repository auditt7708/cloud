# Kubernetes Skalierung

Im vorherigen Abschnitt haben wir erwähnt, dass der replication controller sicherstellt, dass die benutzerdefinierte Anzahl von pod replicas zu einem beliebigen Zeitpunkt ausgeführt wird. Um Replikate mit dem replication controller zu verwalten, müssen wir eine Konfigurationsdatei mit dem Replikat für einen Pod definieren. Diese Konfiguration kann zur Laufzeit geändert werden.

## Fertig werden

Vergewissern Sie sich, dass das Kubernetes-Setup wie im vorherigen Rezept beschrieben läuft und dass Sie sich im Kubernetes-Verzeichnis befinden, das mit der vorherigen Installation erstellt wurde.

### Wie es geht…

1.Starten Sie den Nginx-Container mit einer Replikzahl von 3:
`$ ./cluster/kubectl.sh run-container my-nginx --image=nginx --replicas=3 --port=80`

Dies wird drei Repliken des Nginx-Containers starten. Liste der Pods, um den Status zu erhalten:
`$  ./cluster/kubectl.sh get pods`

2.Holen Sie sich die Replikations-Controller-Konfiguration:
`$ ./cluster/kubectl.sh get replicationControllers`

Wie Sie sehen können, haben wir einen `my-nginx` Controller, der eine Replikzählung von 3 hat. Es gibt einen replication controller für `kube-dns`, den wir im nächsten Rezept erforschen werden.

3.Fordern Sie den replication controller Dienst an, um auf Replik von 1 zu skalieren und den replication controller zu aktualisieren:

```s
$ ./cluster/kubectl.sh resize rc my-nginx –replicas=1
$ ./cluster/kubectl.sh get rc
```

4.Holen Sie sich die Liste der Pods zu überprüfen; Du solltest nur einen Pod für `nginx` sehen:
`$  ./cluster/kubectl.sh get pods`

## Wie es funktioniert…

Wir fordern den replication controller Dienst an, der auf dem Master ausgeführt wird, um die Replikate für einen Pod zu aktualisieren, der die Konfiguration aktualisiert und die Knoten / Minions auffordert, entsprechend zu handeln, um die Größenänderung zu durchzuführen.

## Es gibt mehr…

Holen Sie sich die Dienstleistungen:

`$ ./cluster/kubectl.sh get services`

Wie Sie sehen können, haben wir keinen Service für unsere `nginx` Container, die früher gestartet wurden. Dies bedeutet, dass wir, obwohl wir einen Container laufen lassen, von außen nicht darauf zugreifen können, da der entsprechende Service nicht definiert ist.

### Siehe auch

* Einrichten der vagabunden Umgebung unter https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/vagrant.md

* Die Kubernetes Bedienungsanleitung unter https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/user-guide.md
