---
title: docker-praktischer-einsatz-openstack
description: 
published: true
date: 2021-06-09T15:15:18.856Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:15:13.240Z
---

Ich gehe davon aus, dass der Leser eine gewisse Exposition gegenüber OpenStack für dieses Rezept hat, da es außerhalb des Geltungsbereichs dieses Buches liegt. Weitere Informationen über OpenStack und seine Komponenten finden Sie unter http://www.openstack.org/software/.

In OpenStack unterstützt Nova verschiedene Hypervisoren fürs computing, wie z.B. KVM, XEN, VMware, HyperV und andere. Wir können VMs mit diesen Treibern zur Verfügung stellen. Mit Ironic (https://wiki.openstack.org/wiki/Ironic) können Sie auch bare metal bereitstellen. Nova hat Unterstützung für Container-Provisioning mit Docker in der Havanna (https://www.openstack.org/software/havana/) veröffentlicht, aber derzeit außerhalb der mainline für schnelleren dev-Zyklus. Es gibt Pläne, es in der Hauptlinie in der Zukunft zu verschmelzen. Unter der Haube sieht es so aus:

![docker-under-the-hood](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_15.jpg)
https://wiki.openstack.org/wiki/File:Docker-under-the-hood.png

DevStack (http://docs.openstack.org/developer/devstack/overview.html) ist eine Sammlung von Skripten, um schnell eine OpenStack-Entwicklungsumgebung zu erstellen. Es ist kein Allzweck Installer, aber es ist ein sehr einfacher Weg, um mit OpenStack zu beginnen. In diesem Rezept konfigurieren wir DevStacks Umgebung mit Docker als Nova-Treiber auf Fedora21.

### Fertig werden

1. Installiere Docker auf dem System.

2. Klone nova-docker und devstack:
```
$ git clone https://git.openstack.org/stackforge/nova-docker /opt/stack/nova-docker 
$ git clone https://git.openstack.org/openstack-dev/devstack /opt/stack/devstack 

```

3. Der folgende Schritt ist erforderlich, bis wir `configure_nova_hypervisor_rootwrap` nutzen können:
`$ git clone https://git.openstack.org/openstack/nova /opt/stack/nova`

4. Vorbereiten von Devstack für die Installation:
```
$ cd /opt/stack/nova-docker 
$ ./contrib/devstack/prepare_devstack.sh
```

5. Erstellen Sie den Stack-Benutzer und fügen Sie ihn zu `sudo` hinzu:
`$ /opt/stack/devstack/tools/create-stack-user.sh`

6. Installiere `docker-py`, um mit dem Docker über Python zu kommunizieren:
```
$ yum install python-pip
$ pip install docker-py
```

### Wie es geht…

1. Nachdem die Voraussetzungen abgeschlossen sind, führen Sie die folgenden Befehle aus, um Devstack zu installieren:
```
$ cd /opt/stack/devstack 
$ ./stack.sh
```

### Wie es funktioniert...
* Der `prepare_devstack.sh`-Treiber macht die folgenden Einträge in der Datei `localrc` die richtige Umgebung, um Docker für den Nova-Treiber einzustellen:
```
export VIRT_DRIVER=docker 
export DEFAULT_IMAGE_NAME=cirros 
export NON_STANDARD_REQS=1 
export IMAGE_URLS=" " 
```

* Nach dem Ausführen der `stackrc`-Datei können wir die folgenden Änderungen in Bezug auf Nova und Glance sehen:

1. Die Datei `/etc/nova/nova.conf` ändert den compute treiber:
```
 [DEFAULT] 
 compute_driver = novadocker.virt.docker.DockerDriver 
```
2. Die Datei `/etc/nova/rootwrap.d/docker.filters` wird mit folgendem Inhalt aktualisiert:
```
[Filters] 
# nova/virt/docker/driver.py: 'ln', '-sf', '/var/run/netns/.*' 
ln: CommandFilter, /bin/ln, root
```

3. In `/etc/glance/glance-api.conf`, fügt Docker im Container/Imageformat hinzu:

```
[DEFAULT] 
container_formats = ami,ari,aki,bare,ovf,docker 
```

### Es gibt mehr…

* In localrc haben wir cirros als Standardbild erwähnt, sobald das Setup abgeschlossen ist, können wir sehen, dass das Dockerbild für cirros heruntergeladen wird:
`docker images`

Dies wird automatisch in den Blick importiert:
`su - stack`

Aus dem vorigen Kommando können wir sehen, dass das Containerformat Docker ist.

* Jetzt können Sie eine Instanz mit einem `Cirros` Image mit Horizon oder aus der Befehlszeile erstellen und den Container mit der Docker-Befehlszeile ansehen.

* Um ein Image nach Glance zu importieren, kannst du so etwas wie folgendes machen:
1. Machen  einen pull des gewünschten Images von Docker Hub:
`$ docker pull fedora `

2. Importieren Sie das Image (derzeit kann nur admin das Image importieren):
```
$ source openrc 
$ export OS_USERNAME=admin 
$ sudo docker save fedora | glance image-create --is-public=True --container-format=docker --disk-format=raw --name fedora 
```
```
source openrc
export OS_USERNAME=admin
sudo docker save fedora | glance image-create --is-public=True --container-format=docker --disk-format=raw --name fedore
```

* Es gibt einen Mangel an Integration mit Cinder und Neutron, aber die Dinge sind schnell aufholen.

* Bei der Installation, wenn du das ¸AttributeError: 'module' object has no attribute 'PY2' error`, dann führen Sie die folgenden Befehle, um es zu beheben:
```
$ pip uninstall  six 
$ pip install --upgrade   six 

```

### Siehe auch

* Die Dokumentation auf der OpenStack-Website unter https://wiki.openstack.org/wiki/Docker.

* Docker ist auch einer der Ressourcentypen für OpenStack Heat. Erfahren Sie mehr darüber unter http://docs.openstack.org/developer/heat/template_guide/contrib.html#dockerinc-resource.

* Es gibt ein interessantes Projekt in OpenStack namens Kolla, das sich auf die Bereitstellung von OpenStack-Diensten über Docker-Container konzentriert. Weitere Informationen finden Sie unter https://github.com/stackforge/kolla/.