#### Übersicht
Folgende Plugins sind einsetzbar :

Weave
Project Calico
Nuage Networks
Cisco
VMware
Microsoft
Midokura

Um ein Networking plugin zu nutzen müssen wir es folgender massen einbinden 
```
$ docker run -it --publish-service=service.network.cisco ubuntu:latest /bin/bash
$ docker run -it --publish-service=service.network.vmware ubuntu:latest /bin/bash
$ docker run -it --publish-service=service.network.microsoft ubuntu:latest /bin/bash
```
