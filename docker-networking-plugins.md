#### Übersicht
Folgende Plugins sind einsetzbar :

* [weave](https://gitlab.com/tobkern1980/home-net4-environment/wikis/docker-networking-weave-net-install-konfiguration) 
* Project Calico 
* Nuage Networks 
* Cisco 
* VMware 
* Microsoft 
* Midokura 

Um ein Networking plugin zu nutzen müssen wir es folgender massen einbinden 
```
$ docker run -it --publish-service=service.network.cisco ubuntu:latest /bin/bash
$ docker run -it --publish-service=service.network.vmware ubuntu:latest /bin/bash
$ docker run -it --publish-service=service.network.microsoft ubuntu:latest /bin/bash
```
