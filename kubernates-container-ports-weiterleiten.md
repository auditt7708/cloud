In den vorangegangenen Kapiteln haben Sie gelernt, mit den Kubernetes-Diensten zu arbeiten, um den Container-Port intern und extern weiterzuleiten. Jetzt ist es Zeit, es noch einen Schritt weiter zu sehen, wie es funktioniert.

Es gibt vier Netzwerkmodelle in Kubernetes, und wir werden die Details in den folgenden Abschnitten erkunden:

    Container-zu-Container-Kommunikation

    Pod-to-Pod-Kommunikation

    Pod-to-Service-Kommunikation

    Externe-zu-interne Kommunikation

Fertig werden

In diesem Abschnitt werden wir zwei nginx Web-Apps ausführen, um zu zeigen, wie diese vier Modelle funktionieren. Der Standard-Port von nginx in Docker Hub (https://hub.docker.com/_/nginx) ist 80. Wir erstellen dann ein weiteres nginx Docker-Bild, indem wir die nginx-Konfigurationsdatei und die Dockerfile von 80 auf 8800 ändern. Die folgenden Schritte Wird Ihnen zeigen, wie man es von Grund auf baut, aber Sie sind frei, es zu überspringen und verwenden Sie unser vorgebautes Bild (https://hub.docker.com/r/msfuko/nginx_8800) als gut.

Lassen Sie uns zuerst eine einfache nginx Konfigurationsdatei erstellen. Beachten Sie, dass wir den 8800 Port anhören müssen:
```
// create one nginx config file
# cat nginx.conf
server {
    listen       8800;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/log/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
Als nächstes müssen wir die Standard-Nginx `Dockerfile` von expose `80` auf `8800` ändern:
```
// modifying Dockerfile as expose 8800 and add config file inside
# cat Dockerfile
FROM debian:jessie

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.9-1~jessie

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
        rm -rf /var/lib/apt/lists/*
COPY nginx.conf /etc/nginx/conf.d/default.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log


VOLUME ["/var/cache/nginx"]

EXPOSE 8800

CMD ["nginx", "-g", "daemon off;"]
```
Dann müssen wir es mit dem Docker-Befehl aufbauen:
```
// build docker image
# docker build -t $(YOUR_DOCKERHUB_ACCOUNT)/nginx_8800 .
```
Schließlich können wir zu unserem Docker Hub Repository drücken:
```
// be sure to login via `docker login` first
# docker push $(YOUR_DOCKERHUB_ACCOUNT)/nginx_8800
```
Danach solltest du den Container mit dem reinen Docker-Befehl ausführen können: `docker run -d -p 8800:8800 msfuko/nginx_8800`. Mit `curl $ IP:8800`, sollten Sie in der Lage sein, die Willkommensseite von nginx zu sehen.

### Tip
Wie finde ich meine $IP?

Wenn Sie auf Linux arbeiten, dann könnte `ifconfig` helfen, herauszufinden, den Wert von $IP. Wenn Sie auf einer anderen Plattform über Docker maschine arbeiten, könnte `docker-machine ip` Ihnen helfen.

### Wie es geht…

Pod enthält einen oder mehrere Container, die auf demselben Host laufen. Jeder Pod hat seine eigene IP-Adresse; Alle Container in einem Pod sehen sich auf dem gleichen Host. Container innerhalb eines Pods werden fast zur gleichen Zeit erstellt, eingesetzt und gelöscht.
Container-zu-Container-Kommunikation

Wir erstellen zwei Nginx-Container in einem Pod, der Port `80` und `8800` einzeln hören wird. In der folgenden Konfigurationsdatei solltest du den zweiten Bildpfad ändern, den du gerade gebaut und gedrückt hast:
```
// create 2 containers inside one pod
# cat nginxpod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginxpod
spec:
  containers:
    -
      name: nginx80
      image: nginx
      ports:
        -
          containerPort: 80
          hostPort: 80
    -
      name: nginx8800
      image: msfuko/nginx_8800
      ports:
        -
          containerPort: 8800
          hostPort: 8800
// create the pod
# kubectl create -f nginxpod.yaml
pod "nginxpod" created

```
Nachdem das Bild gezogen und ausgeführt wird, können wir sehen, dass der Status mit dem Befehl `kubectl` läuft:
```
// list nginxpod pod
# kubectl get pods nginxpod
NAME       READY     STATUS    RESTARTS   AGE
nginxpod   2/2       Running   0          12m
```
Wir konnten die Zählung in der `READY` Spalte finden, werden `2/2`, da gibt es zwei Container in diesem Pod. Mit dem Befehl `kubectl describe` wir die Details des Pods:
```
// show the details of nginxpod
# kubectl describe pod nginxpod
Name:        nginxpod
Namespace:      default
Image(s):      nginx,msfuko/nginx_8800
Node:        kube-node1/10.96.219.33
Start Time:      Sun, 24 Jan 2016 10:10:01 +0000
Labels:        <none>
Status:        Running
Reason:
Message:
IP:        192.168.55.5
Replication Controllers:  <none>
Containers:
  nginx80:
    Container ID:  docker://3b467d8772f09c57d0ad85caa66b8379799f3a60da055d7d8d362aee48dfa832
    Image:    nginx
    ...
  nginx8800:
    Container ID:  docker://80a77983f6e15568db47bd58319fad6d22a330c1c4c9263bca9004b80ecb6c5f
    Image:    msfuko/nginx_8800
   ...

```
Wir konnten sehen, dass der Pod auf `kube-node1` läuft und die IP des Pods ist `192.168.55.5`. Melden wir uns bei `kube-node1` an, um diese beiden Container zu untersuchen:
```
// list containers
# docker ps
CONTAINER ID        IMAGE                                                      COMMAND                  CREATED             STATUS              PORTS                                        NAMES
80a77983f6e1        msfuko/nginx_8800                                          "nginx -g 'daemon off"   32 minutes ago      Up 32 minutes                                                    k8s_nginx8800.645004b9_nginxpod_default_a08ed7cb-c282-11e5-9f21-025a2f393327_9f85a41b
3b467d8772f0        nginx                                                      "nginx -g 'daemon off"   32 minutes ago      Up 32 minutes                                                    k8s_nginx80.5098ff7f_nginxpod_default_a08ed7cb-c282-11e5-9f21-025a2f393327_9922e484
71073c074a76        gcr.io/google_containers/pause:0.8.0                       "/pause"                 32 minutes ago      Up 32 minutes       0.0.0.0:80->80/tcp, 0.0.0.0:8800->8800/tcp   k8s_POD.5c2e23f2_nginxpod_default_a08ed7cb-c282-11e5-9f21-025a2f393327_77e79a63
```
Wir wissen, dass die ID der beiden Container, die wir erstellt haben, `3b467d8772f0` und `80a77983f6e1` ist.

Wir werden `jq` als JSON-Parser verwenden, um die redundanten Informationen zu reduzieren. Für die Installation von `jq`, laden Sie einfach die Binärdatei von https://stedolan.github.io/jq/download:
```
// inspect the nginx container and use jq to parse it
# docker inspect 3b467d8772f0 | jq '.[]| {NetworkMode: .HostConfig.NetworkMode, NetworkSettings: .NetworkSettings}'
{
  "NetworkMode": "container:71073c074a761a33323bb6601081d44a79ba7de3dd59345fc33a36b00bca613f",
  "NetworkSettings": {
    "Bridge": "",
    "SandboxID": "",
    "HairpinMode": false,
    "LinkLocalIPv6Address": "",
    "LinkLocalIPv6PrefixLen": 0,
    "Ports": null,
    "SandboxKey": "",
    "SecondaryIPAddresses": null,
    "SecondaryIPv6Addresses": null,
    "EndpointID": "",
    "Gateway": "",
    "GlobalIPv6Address": "",
    "GlobalIPv6PrefixLen": 0,
    "IPAddress": "",
    "IPPrefixLen": 0,
    "IPv6Gateway": "",
    "MacAddress": "",
    "Networks": null
  }
}
```
Wir können sehen, dass der Netzwerkmodus als zugeordneter Containermodus eingestellt ist. Der Netzwerkbrückenbehälter ist `Container: 71073c074a761a33323bb6601081d44a79ba7de3dd59345fc33a36b00bca613f`.

Lass uns eine andere Einstellung über den Container sehen `nginx_8800`:
```
// inspect nginx_8800
# docker inspect 80a77983f6e1 | jq '.[]| {NetworkMode: .HostConfig.NetworkMode, NetworkSettings: .NetworkSettings}'
{
  "NetworkMode": "container:71073c074a761a33323bb6601081d44a79ba7de3dd59345fc33a36b00bca613f",
  "NetworkSettings": {
    "Bridge": "",
    "SandboxID": "",
    "HairpinMode": false,
    "LinkLocalIPv6Address": "",
    "LinkLocalIPv6PrefixLen": 0,
    "Ports": null,
    "SandboxKey": "",
    "SecondaryIPAddresses": null,
    "SecondaryIPv6Addresses": null,
    "EndpointID": "",
    "Gateway": "",
    "GlobalIPv6Address": "",
    "GlobalIPv6PrefixLen": 0,
    "IPAddress": "",
    "IPPrefixLen": 0,
    "IPv6Gateway": "",
    "MacAddress": "",
    "Networks": null
  }
}

```
Der Netzwerkmodus ist auch auf Container eingestellt: 71073c074a761a33323bb6601081d44a79ba7de3dd59345fc33a36b00bca613. Welcher Container ist das? Wir werden dann herausfinden, dass dieser Netzwerkcontainer von Kubernetes erstellt wird, wenn dein Pod beginnt. Der Container heißt gcr.io/google_containers/pause:
```
// inspect network container `pause`
# docker inspect 71073c074a76 | jq '.[]| {NetworkMode: .HostConfig.NetworkMode, NetworkSettings: .NetworkSettings}'
{
  "NetworkMode": "default",
  "NetworkSettings": {
    "Bridge": "",
    "SandboxID": "59734bbe4e58b0edfc92db81ecda79c4f475f6c8433e17951e9c9047c69484e8",
    "HairpinMode": false,
    "LinkLocalIPv6Address": "",
    "LinkLocalIPv6PrefixLen": 0,
    "Ports": {
      "80/tcp": [
        {
          "HostIp": "0.0.0.0",
          "HostPort": "80"
        }
      ],
      "8800/tcp": [
        {
          "HostIp": "0.0.0.0",
          "HostPort": "8800"
        }
      ]
    },
    "SandboxKey": "/var/run/docker/netns/59734bbe4e58",
    "SecondaryIPAddresses": null,
    "SecondaryIPv6Addresses": null,
    "EndpointID": "d488fa8d5ee7d53d939eadda106e97ff01783f0e9dc9e4625d9e69500e1fa451",
    "Gateway": "192.168.55.1",
    "GlobalIPv6Address": "",
    "GlobalIPv6PrefixLen": 0,
    "IPAddress": "192.168.55.5",
    "IPPrefixLen": 24,
    "IPv6Gateway": "",
    "MacAddress": "02:42:c0:a8:37:05",
    "Networks": {
      "bridge": {
        "EndpointID": "d488fa8d5ee7d53d939eadda106e97ff01783f0e9dc9e4625d9e69500e1fa451",
        "Gateway": "192.168.55.1",
        "IPAddress": "192.168.55.5",
        "IPPrefixLen": 24,
        "IPv6Gateway": "",
        "GlobalIPv6Address": "",
        "GlobalIPv6PrefixLen": 0,
        "MacAddress": "02:42:c0:a8:37:05"
      }
    }
  }
}
```
Wir werden feststellen, dass der Netzwerkmodus auf Standard eingestellt ist und seine IP-Adresse auf die IP des Pods gesetzt ist 192.168.55.5; Das Gateway ist auf Docker0 des Knotens gesetzt. Die Routing-Abbildung wird wie im folgenden Bild gezeigt. Die Netzwerk-Container-Pause wird erstellt, wenn ein Pod erstellt wird, mit dem die Route des Pod-Netzwerks verarbeitet wird. Dann werden zwei Container die Netzwerkschnittstelle mit Pause teilen; Deshalb sehen sie einander als localhost:

![container-forwartd-ports-01](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_03_02.jpg)

### Pod-to-Pod-Kommunikation

Da jeder Pod seine eigene IP-Adresse hat, macht er die Kommunikation zwischen Pods einfach. Im vorigen Kapitel verwenden wir Flanell als Overlay-Netzwerk, das für jeden Knoten unterschiedliche Netzwerksegmente definiert. Jedes Paket ist in ein UDP-Paket eingekapselt, so dass jede Pod-IP routbar ist. Das Paket von Pod1 wird durch das **veth** (virtuelle Netzwerkschnittstelle) Gerät gehen, das mit **docker0** und Routen zu **flannel0** verbindet. Der Verkehr wird durch flanneld eingekapselt und an den Host (**10.42.1.172**) des Ziel-Pods gesendet:
https://www.packtpub.com/graphics/9781788297615/graphics/B05161_03_03.jpg

### Pod-to-Service-Kommunikation

Pods konnten versehentlich gestoppt werden, so dass die IP des Pods geändert werden konnte. Wenn wir den Port für einen Pod oder einen Replikationscontroller freigeben, erstellen wir einen Kubernetes Service, der als Proxy oder Load Balancer fungiert. Kubernetes wird eine virtuelle IP erstellen, die die Anfrage von Clients erhalten und den Traffic auf die Pods in einem Service verletzen wird. Lassen Sie uns überprüfen, wie dies zu tun. Zuerst erstellen wir einen Replikationscontroller namens `my-first-nginx`:
```
// create a rc named my-first-nginx
# kubectl run my-first-nginx --image=nginx --replicas=2 --port=80
replicationcontroller "my-first-nginx" created
```
Dann lasst uns die Pods auflisten, um sicherzustellen, dass zwei Pods von diesem `rc` erstellt werden:
```
// two pods will be launched by this rc
# kubectl get pod
NAME                         READY     STATUS    RESTARTS   AGE
my-first-nginx-hsdmz         1/1       Running   0          17s
my-first-nginx-xjtxq         1/1       Running   0          17s
```
Als nächstes lassen wir einen Port `80` für den Pod aussetzen, der der Standard-Port der `nginx` App ist:
```
// expose port 80 for my-first-nginx
# kubectl expose rc my-first-nginx --port=80 
service "my-first-nginx" exposed
``
Verwenden Sie `describe`, um die Details des Dienstes zu sehen. Der Service-Typ, den wir erstellen, ist ein ClusterIP:
```
// check the details of the service
# kubectl describe service my-first-nginx
Name:      my-first-nginx
Namespace:    default
Labels:      run=my-first-nginx
Selector:    run=my-first-nginx
Type:      ClusterIP
IP:      192.168.235.209
Port:      <unnamed>  80/TCP
Endpoints:    192.168.20.2:80,192.168.55.5:80
Session Affinity:  None
No events.

```
Die virtuelle IP des Dienstes ist `192.168.235.209`, die den Port `80` aussetzt. Der Dienst sendet dann den Verkehr in zwei Endpunkte 192.168.20.2:80 und `192.168.55.5:80`. Die Abbildung ist wie folgt:
![ports-forward-02](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_03_04.jpg)
```
`kube-proxy` ist ein Dämon, der als Netzwerk-Proxy auf jedem Knoten arbeitet. Es hilft, die Einstellungen von Diensten, wie IPs oder Ports, auf jedem Knoten zu reflektieren. Es werden die entsprechenden iptables Regeln erstellt:
```
// list iptables rule by filtering my-first-nginx
# iptables -t nat -L | grep my-first-nginx
REDIRECT   tcp  --  anywhere             192.168.235.209      /* default/my-first-nginx: */ tcp dpt:http redir ports 43321
DNAT       tcp  --  anywhere             192.168.235.209      /* default/my-first-nginx: */ tcp dpt:http to:10.96.219.33:43321
```

Diese beiden Regeln befinden sich unter den `KUBE-PORTALS-CONTAINER`- und `KUBE-PORTALS-HOST` Ketten, die jeden Verkehr darstellen, der für die virtuelle IP mit Port `80` bestimmt ist, der an den lokalen Host auf Port `43321` umgeleitet wird, egal ob der Verkehr aus Containern oder Gastgeber Die kube-proxy-Programme die iptables-Regel, um die Pod- und Service-Kommunikation zur Verfügung zu stellen. Sie sollten in der Lage sein, auf localhost zuzugreifen `localhost:43321` auf dem Zielknoten oder `$nodeIP:43321` innerhalb des Clusters.

###### Notiz
Verwenden Sie die Umgebungsvariablen des Kubernetes-Dienstes in Ihrem Programm

Manchmal müssen Sie auf den Kubernetes-Service in deinem Programm im Kubernetes-Cluster zugreifen. Sie können Umgebungsvariablen oder DNS verwenden, um darauf zuzugreifen. Umgebungsvariablen sind der einfachste Weg und werden natürlich unterstützt. Wenn ein Dienst erstellt wird, wird `kubelet` einen Satz von Umgebungsvariablen zu diesem Dienst hinzufügen:

* $SVCNAME_SERVICE_HOST
* $SVCNAME_SERVICE_PORT

Hier ist `$SVNNAME` Großbuchstaben und die Bindestriche werden in Unterstriche umgewandelt. Der Dienst, den ein Pod zugreifen möchte, muss vor dem Pod erstellt werden, sonst werden die Umgebungsvariablen nicht besetzt. Zum Beispiel sind die Umgebungsvariablen, die mein-first-nginx bevölkert,:

* `MY_FIRST_NGINX_PORT_80_TCP_PROTO=tcp`
* `MY_FIRST_NGINX_SERVICE_HOST=192.168.235.209`
* `MY_FIRST_NGINX_SERVICE_PORT=80`
* `MY_FIRST_NGINX_PORT_80_TCP_ADDR=192.168.235.209`
* `MY_FIRST_NGINX_PORT=tcp://192.168.235.209:80`
* `MY_FIRST_NGINX_PORT_80_TCP_PORT=80`
* `MY_FIRST_NGINX_PORT_80_TCP=tcp://192.168.235.209:80`


Externe-zu-interne Kommunikation

Die externe interne Kommunikation könnte mit dem externen Load Balancer, wie z. B. GCE's ForwardingRules oder AWS ELB, oder durch den Zugriff auf Knoten IP direkt eingerichtet werden. Hier werden wir vorstellen, wie der Zugriff auf Knoten IP funktionieren könnte. Zuerst führen wir einen replication controller mit zwei Repliken namens `my-second-nginx`:
```
// create a rc with two replicas
# kubectl run my-second-nginx --image=nginx --replicas=2 --port=80
```

Als nächstes setzen wir den Service mit Port `80` mit dem Typ `LoadBalancer` aus. Wie wir im Service-Bereich diskutiert haben, wird `LoadBalancer` auch einen Knoten-Port aussetzen:

```
// expose port 80 for my-second-nginx rc with type LoadBalancer
# kubectl expose rc my-second-nginx --port=80 --type=LoadBalancer
```
Wir konnten jetzt die Details von `my-second-nginx` Service überprüfen. Es hat eine virtuelle IP `192.168.156.93` mit Port `80`. Es hat auch einen Knoten Port `31150`:
```
// list the details of service 
# kubectl describe service my-second-nginx
Name:      my-second-nginx
Namespace:    default
Labels:      run=my-second-nginx
Selector:    run=my-second-nginx
Type:      LoadBalancer
IP:      192.168.156.93
Port:      <unnamed>  80/TCP
NodePort:    <unnamed>  31150/TCP
Endpoints:    192.168.20.3:80,192.168.55.6:80
Session Affinity:  None
No events.
```

Lassen Sie uns die iptables Regeln aufführen, um die Unterschiede zwischen den verschiedenen Arten von Service zu sehen:

```
// list iptables rules and filtering my-seconde-nginx on node1
# iptables -t nat -L | grep my-second-nginx
REDIRECT   tcp  --  anywhere             anywhere             /* default/my-second-nginx: */ tcp dpt:31150 redir ports 50563
DNAT       tcp  --  anywhere             anywhere             /* default/my-second-nginx: */ tcp dpt:31150 to:10.96.219.141:50563
REDIRECT   tcp  --  anywhere             192.168.156.93       /* default/my-second-nginx: */ tcp dpt:http redir ports 50563
DNAT       tcp  --  anywhere             192.168.156.93       /* default/my-second-nginx: */ tcp dpt:http to:10.96.219.141:50563

// list iptables rules and filtering my-second-nginx on node2
# iptables -t nat -L | grep my-second-nginx
REDIRECT   tcp  --  anywhere             anywhere             /* default/my-second-nginx: */ tcp dpt:31150 redir ports 53688
DNAT       tcp  --  anywhere             anywhere             /* default/my-second-nginx: */ tcp dpt:31150 to:10.96.219.33:53688
REDIRECT   tcp  --  anywhere             192.168.156.93       /* default/my-second-nginx: */ tcp dpt:http redir ports 53688
DNAT       tcp  --  anywhere             192.168.156.93       /* default/my-second-nginx: */ tcp dpt:http to:10.96.219.33:53688
```

Wir haben vier Regeln im Zusammenhang mit meinem-Zweit-Nginx jetzt. Sie befinden sich unter den KUBE-NODEPORT-CONTAINER-, KUBE-NODEPORT-HOST-, KUBE-PORTALS-CONTAINER- und KUBE-PORTALS-HOST-Ketten. Da wir den Knoten-Port in diesem Beispiel aussetzen, wenn der Verkehr von der Außenwelt zum Knoten-Port 31150 ist, wird der Verkehr an den Ziel-Pod lokal oder über Knoten weitergeleitet. Im Folgenden finden Sie eine Veranschaulichung des Routings:

![container-ports-forward-03](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_03_05.jpg)

Der Verkehr vom Knotenport (`x.x.x.x: 31150`) oder von ClusterIP (`192.168.156.93:80`) wird auf Ziel-Pods umgeleitet, indem ein Lastausgleichsmechanismus über Knoten bereitgestellt wird. Die Ports `50563` und `53688` werden von Kubernetes dynamisch zugewiesen.

