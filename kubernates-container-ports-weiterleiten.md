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