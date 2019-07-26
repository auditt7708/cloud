# Docker Pervormence und Leistungsüberwachung

Wir haben Werkzeuge wie SNMP, Nagios und so weiter, um Bare Metal und VM Performance zu überwachen. 
Ebenso gibt es ein paar Tools / Plugins zur Überwachung der Container-Performance wie cAdvisor (https://github.com/google/cadvisor) und sFlow (http://blog.sflow.com/2014/06/docker-performance -monitoring.html). In diesem Rezept sehen wir, wie wir cAdvisor konfigurieren können.

## Fertig werden

 CAdvisor einrichten

* Der einfachste Weg, um CAdvisor laufen zu lassen, ist, seinen Docker-Container auszuführen, der mit dem folgenden Befehl durchgeführt werden kann:

```s
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest
```

* Wenn Sie CAdvisor außerhalb von Docker ausführen möchten, dann folgen Sie den Anweisungen auf der cAdvisor-Homepage unter https://github.com/google/cadvisor/blob/master/docs/running.md#standalone

## Wie es geht…

Nachdem der Container gestartet ist, zeigen Sie Ihren Browser auf http: // localhost: 8080. Sie erhalten zunächst die Graphen für CPU, Speicherverbrauch und andere Informationen für den Host-Rechner. Dann, indem Sie auf den Link Docker Container klicken, erhalten Sie die URLs für die Container, die auf dem Rechner unter dem Abschnitt Subcontainer laufen. Wenn Sie auf einen von ihnen klicken, sehen Sie die Ressourcenverwendungsinformationen für den entsprechenden Container.

Das folgende ist der Screenshot eines solchen Containers:

![benchmark](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_07_03.jpg)

## Wie es funktioniert…

Mit dem `docker run` Befehl haben wir nur wenige Bände von Host-Maschinen im schreibgeschützten Modus installiert. CAdvisor liest die relevanten Informationen von denen wie die Cgroup Details für Container und zeigt sie grafisch.

## Es gibt mehr…

CAdvisor unterstützt den Export der Performance-Matrizen in influxdb (http://influxdb.com/). Heapster (https://github.com/GoogleCloudPlatform/heapster) ist ein weiteres Projekt von Google, das eine Cluster-weite (Kubernetes) Überwachung mit CAdvisor ermöglicht.

### Siehe auch

* Sie können sich die Matrizen von cAdvisor von Cgroups in der Dokumentation auf der Docker-Website https://docs.docker.com/articles/runmetrics/
