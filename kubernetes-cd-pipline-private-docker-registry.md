---
title: kubernetes-cd-pipline-private-docker-registry
description: 
published: true
date: 2021-06-09T15:31:07.360Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:31:01.427Z
---

Wenn du anfängst, dein eigenes Docker-Image zu pflegen, musst du vielleicht ein privates Docker-Registry haben, um sensible Informationen in ein Image oder deine Organisationspolitik zu bringen.

Docker Hub bietet das private Repository an, das nur der authentifizierte Benutzer Bilder hochladen und ziehen kann und für andere Benutzer nicht sichtbar ist. Allerdings gibt es nur eine Quote für ein kostenloses Docker Hub-Konto. Sie können zahlen, um die private Repositories-Quote zu erhöhen, aber wenn Sie die Microservices-Architektur annehmen, benötigen Sie eine große Anzahl von privaten Repositories:

![docker-hub-accound-billing](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_15.jpg)

Docker Hub private Repositories Preis

Es gibt einige Möglichkeiten, um Ihre eigene private Docker-Registrierung, dass unbegrenzte Docker Bild-Quota lokalisiert innerhalb Ihres Netzwerks.
Fertig werden

Der einfachste Weg, um Ihre Docker-Registrierung einzurichten, ist die Verwendung eines offiziellen Docker-Registrierungsbildes (https://docs.docker.com/registry/). Führen Sie den Docker-Pull-Befehl aus, um das Docker-Registrierungsbild wie folgt herunterzuladen:

```
$ docker pull registry:2
2: Pulling from library/registry
f32095d4ba8a: Pull complete 
9b607719a62a: Pull complete 
973de4038269: Pull complete 
2867140211c1: Pull complete 
8da16446f5ca: Pull complete 
fd8c38b8b68d: Pull complete 
136640b01f02: Pull complete 
e039ba1c0008: Pull complete 
c457c689c328: Pull complete 
Digest: sha256:339d702cf9a4b0aa665269cc36255ee7ce424412d56bee9ad8a247afe8c49ef1
Status: Downloaded newer image for registry:2

//create Docker image datastore under /mnt/docker/images
$ sudo mkdir /mnt/docker/images

//launch registry that expose the 5000/tcp to 8888/tcp on host
$ sudo docker run -p 8888:5000 -v /mnt/docker/images:/var/lib/registry registry:2
```
###### Notiz
Es wird die Bilder auf `/mnt/docker/images` auf dem Host-Rechner speichern. Es wird dringend empfohlen, ein Netzwerkdatenvolumen wie NFS oder ein Docker-Volume zu verwenden

Wie es geht…

Lassen Sie uns Ihr einfaches Docker-Bild basierend auf nginx erstellen:

1. Erstens, `index.html` wie folgt vorbereiten:
```
$ cat index.html
<html>
    <head><title>My Image</title></head>

    <body>
        <h1>Hello Docker !</h1>
    </body>

</html>
```

2. Außerdem bereite ich `Dockerfile` wie folgt vor, um dein Docker-Bild zu bauen:
```
$ cat Dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html
```

3. Dann baue ich einen Docker-Bildnamen als `<your name>/mynginx` wie folgt auf:
```
$ ls
Dockerfile  index.html

$ docker build -t hidetosaito/mynginx .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM nginx
 ---> 9737f81306ee
Step 2 : COPY index.html /usr/share/nginx/html
 ---> 74dd7902a931
Removing intermediate container eefc2bb17e24
Successfully built 74dd7902a931
```
In diesem Moment wird das mynginx-Image nur auf diesem Host gespeichert.

4. Jetzt ist es Zeit, zu deinem privaten Register zu schieben. Zuerst muss man den Bildnamen als <private_registry: `<private_registry:port number>/<your name>/mynginx` wie folgt markieren:
```
 docker tag hidetosaito/mynginx ip-10-96-219-25:8888/hidetosaito/mynginx
$ docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ip-10-96-219-25:8888/hidetosaito/mynginx   latest              b69b2ab1f31b        7 minutes ago       134.6 MB
hidetosaito/mynginx                        latest              b69b2ab1f31b        7 minutes ago       134.6 MB

```

###### Notiz
Sie können sehen, dass die IMAGE ID gleich ist, weil es das gleiche Image ist.

5. Dann schieben Sie zum privaten Registry mit dem `docker push` Befehl wie folgt:
```
$ docker push ip-10-96-219-25:8888/hidetosaito/mynginx
The push refers to a repository [ip-10-96-219-25:8888/hidetosaito/mynginx] (len: 1)
b69b2ab1f31b: Pushed 
ae8e1e9c54b3: Pushed 
18de280c0e54: Pushed 
cd0794b5fd94: Pushed 
f32095d4ba8a: Pushed 
latest: digest: sha256:7ac04fdaedad1cbcc8c92fb2ff099a6509f4f29b0f694ae044a0cffc8ffe58b4 size: 15087
```

Jetzt ist Ihr `mynginx` Image in Ihrem privaten Registry gespeichert worden. Lassen Sie uns dieses Image mit Kubernetes einsetzen.

6. Bereiten Sie die YAML-Datei vor, die den Befehl enthält, `nginx` aus der privaten Registry zu verwenden und den Kubernetes-Dienst zu verwenden, um den TCP-Port `30080` durchzureichen:
```
# cat my-nginx-with-service.yaml 
apiVersion: v1
kind: ReplicationController
metadata:
  name: mynginx
spec:
  replicas: 2
  selector:
        app: mynginx
  template:
    metadata:
      labels:
        app: mynginx
    spec:
      containers:
      - name: mynginx
        image: ip-10-96-219-25:8888/hidetosaito/mynginx
---
apiVersion: v1
kind: Service
metadata:
  name: mynginx-service

spec:
  ports:
    - protocol: TCP
      port: 80
      nodePort: 30080
  type: NodePort
  selector:
     app: mynginx


```

7. Verwenden Sie dann den Befehl `kubectl create`, um diese YAML-Datei zu laden:
```
# kubectl create -f my-nginx-with-service.yaml 
replicationcontroller "mynginx" created
```

Sie haben Ihren Dienst einem externen Port auf allen Nodes in Ihrem Cluster weitergeleitet. Wenn Sie diesen Dienst dem externen Internet verfügbar machen möchten, müssen Sie möglicherweise Firewall-Regeln für den Service-Port (s) (TCP-Port `30080`) einrichten, um den Verkehr zu ermöglichen. Weitere Informationen finden Sie unter http://releases.k8s.io/release-1.1/docs/user-guide/services-firewalls.md:
`service "mynginx-service" created`

Dann greifen Sie auf einen beliebigen Kubernetes-Knoten auf TCP-Port `30080` zu; Sie können `index.html` wie folgt sehen:
![Hello Docker](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_16.jpg)

### Wie es funktioniert…

Beim Ausführen des `docker push` Befehls lädt es dein Docker-Image in die private Registry. Dann, wenn der Befehl `kubectl create` ausgeführt wird, führt der Kubernetes-Node den Docker-Pull Befehl aus der privaten Registry aus.

Mit der privaten Registrierung ist der einfachste Weg, um Ihr Docker-Image auf alle Kubernetes-Nodes zu verteilen:

![docker-private-reg](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_17.jpg)

### Alternativen

Das offizielle Docker Registry image ist die Standard-Weg, um Ihre private Registry anzulegen. Allerdings haben Sie wegen dem Management- und Wartungspunkten auch mehr Aufwand. Es gibt einen alternativen Weg, um Ihre eigene Docker Privatregistrierung zu konstruieren.

### Docker vertrauenswürdige Registry

Docker Trusted Registry ist eine Enterprise-Version der Docker-Registrierung. Es kommt mit Web Console, LDAP-Integration, und so weiter. Um mehr über Docker Trusted Registry zu erfahren, verweisen wir auf den folgenden Link:

Https://www.docker.com/products/docker-trusted-registry

### Nexus Repository Manager

Nexus Repository Manager ist einer der beliebten Repository Manager; Es unterstützt Java Maven, Linux apt / yum, Docker und vieles mehr. Sie können das gesamte Software-Repository in den Nexus Repository Manager integrieren. Lesen Sie hier mehr über Nexus Repository:

Http://www.sonatype.com/nexus/solution-overview/nexus-repository

### Amazon EC2 Container Registry

Amazon Web Services (AWS) bietet auch einen Managed Docker Registry Service. Es ist mit Identity Access Management (IAM) integriert und die Gebühren basieren auf Speicherverbrauch und Datentransferverbrauch statt der Anzahl der Images. Um mehr darüber zu erfahren, verweisen wir auf folgenden Link:

Https://aws.amazon.com/ecr/