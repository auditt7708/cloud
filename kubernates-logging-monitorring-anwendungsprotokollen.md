Wenn Sie mit der Verwaltung der Anwendung beginnen, sind die Protokollsammlung und -analyse zwei der wichtigen Routinen, um den Status der Anwendung zu verfolgen.

Allerdings gibt es einige Schwierigkeiten, wenn die Anwendung von Docker/Kubernetes verwaltet wird; Da sich die Log-Dateien im Container befinden, ist es nicht leicht, von außen auf den Container zuzugreifen. Darüber hinaus, wenn die Anwendung viele Pods hat durch die Replikations Controller, wird es auch schwierig sie zu verfolgen oder zu identifizieren, in welchem ​​Pod das Problem, um das gerade geht und wo es passiert ist zu finden.

Eine Möglichkeit, diese Schwierigkeit zu überwinden, besteht darin, eine zentrale Log-Sammlungsplattform vorzubereiten, die das Anwendungsprotokoll ansammelt und bewahrt. Dieses Rezept beschreibt eine der beliebten Log-Sammlungs Plattformen **ELK (Elasticsearch, Logstash und Kibana)**.

### Fertig werden

Zuerst müssen wir am Anfang den Elasticsearch-Server vorbereiten. Dann wird die Anwendung ein Protokoll an Elasticsearch mit Logstash senden. Wir werden das Analyseergebnis mit Kibana visualisieren.

### Elasticsearch

Elasticsearch (https://www.elastic.co/products/elasticsearch) ist einer der populären Textindizes und analytischen Motoren. Es gibt einige Beispiele YAML-Dateien, die von der Kubernetes-Quelldatei bereitgestellt wird. Lasst uns es mit dem Curl-Befehl herunterladen, um Elasticsearch einzurichten:

###### Notiz
Eine Beispiel-YAML-Datei befindet sich auf GitHub unter https://github.com/kubernetes/kubernetes/tree/master/examples/elasticsearch.

```
# curl -L -O https://github.com/kubernetes/kubernetes/releases/download/v1.1.4/kubernetes.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   593    0   593    0     0   1798      0 --:--:-- --:--:-- --:--:--  1802
100  181M  100  181M    0     0  64.4M      0  0:00:02  0:00:02 --:--:-- 75.5M
# tar zxf kubernetes.tar.gz 
# cd kubernetes/examples/elasticsearch/
# ls
es-rc.yaml  es-svc.yaml  production_cluster  README.md  service-account.yaml
```

Erstellen Sie den ServiceAccount (`service-account.yaml`) und erstellen Sie dann den Elasticsearch-Replikationscontroller (`es-rc.yaml`) und den Dienst hinterher (`es-svc.yaml`) wie folgt:

```
# kubectl create -f service-account.yaml 
serviceaccount "elasticsearch" created

//As of Kubernetes 1.1.4, it causes validation error
//therefore append --validate=false option
# kubectl create -f es-rc.yaml --validate=false
replicationcontroller "es" created

# kubectl create -f es-svc.yaml 
service elasticsearch" created

```
Dann können Sie über den Kubernetes-Service wie folgt auf die Elasticsearch-Schnittstelle zugreifen:
//Elasticsearch is open by 192.168.45.152 in this example
# kubectl get service
NAME            CLUSTER_IP       EXTERNAL_IP   PORT(S)             SELECTOR                  AGE
elasticsearch   192.168.45.152                 9200/TCP,9300/TCP   component=elasticsearch   9s
kubernetes      192.168.0.1      <none>        443/TCP             <none>                    110d

//access to TCP port 9200
# curl http://192.168.45.152:9200/
{
  "status" : 200,
  "name" : "Wallflower",
  "cluster_name" : "myesdb",
  "version" : {
    "number" : "1.7.1",
    "build_hash" : "b88f43fc40b0bcd7f173a1f9ee2e97816de80b19",
    "build_timestamp" : "2015-07-29T09:54:16Z",
    "build_snapshot" : false,
    "lucene_version" : "4.10.4"
  },
  "tagline" : "You Know, for Search"
}
```

Jetzt mach dich bereit, ein Bewerbungsprotokoll an Elasticsearch zu schicken.

### Wie es geht…

Lassen Sie uns eine Beispielanwendung verwenden, die in der beweglichen monolithischen zu microservices Rezept in [Einrichten einer Continuous Delivery Pipeline](../kubernetes-cd-pipline) eingeführt wurden. Bereiten Sie ein Python Flask Programm wie folgt vor:
```
# cat entry.py

from flask import Flask, request 
app = Flask(__name__) 

@app.route("/") 
def hello(): 
    return "Hello World!" 

@app.route("/addition/<int:x>/<int:y>") 
def add(x, y): 
    return "%d" % (x+y) 

if __name__ == "__main__": 
    app.run(host='0.0.0.0') 
```
Verwenden Sie diese Anwendung, um ein Log an Elasticsearch zu senden.

### Logstash

Senden Sie ein  application log an Elasticsearch; Mit Logstash (https://www.elastic.co/products/logstash) ist der einfachste Weg, weil er aus einem Klartextformat in das Format Elasticsearch (JSON) konvertiert.

Logstash benötigt eine Konfigurationsdatei, die die Elasticsearch IP Adresse und Portnummer angibt. In diesem Rezept wird Elasticsearch von Kubernetes Service verwaltet; Daher können die IP-Adresse und die Portnummer mit der Umgebungsvariablen wie folgt gefunden werden:

|Item|Umgebung Variable|Beispiel|
| :---: | :---: | :---: |
|Elasticsearch IP address|` ELASTICSEARCH_SERVICE_HOST `|`192.168.45.152`|
|Elasticsearch port number|`ELASTICSEARCH_SERVICE_PORT`|`9200`|

Die Logstash-Konfigurationsdatei unterstützt jedoch keine Umgebungsvariable direkt. Daher verwendet die Logstash-Konfigurationsdatei den Platzhalter wie`_ES_IP_` und `_ES_PORT_`  folgender maßen:
```
# cat logstash.conf.temp 

input { 
    stdin {}
}

filter {
  grok {
    match => {
        "message" => "%{IPORHOST:clientip} %{HTTPDUSER:ident} %{USER:auth} \[%{DATA:timestamp}\] \"(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})\" %{NUMBER:response} (?:%{NUMBER:bytes}|-)"
    }
  }
}

output {
  elasticsearch {
    hosts => ["_ES_IP_:_ES_PORT_"]
    index => "mycalc-access"
}

stdout { codec => rubydebug }
}
```

### Startup-Skript

Das Startup-Skript liest eine Umgebungsvariable und ersetzt dann den Platzhalter, um die reale IP- und Portnummer wie folgt festzulegen:
```
#!/bin/sh

TEMPLATE="logstash.conf.temp"
LOGSTASH="logstash-2.2.2/bin/logstash"

cat $TEMPLATE | sed "s/_ES_IP_/$ELASTICSEARCH_SERVICE_HOST/g" | sed "s/_ES_PORT_/$ELASTICSEARCH_SERVICE_PORT/g" > logstash.conf

python entry.py 2>&1 | $LOGSTASH -f logstash.conf
```

### Dockerfile

Schließlich bereite ich Dockerfile wie folgt vor, um eine Beispielanwendung zu erstellen:
```
FROM ubuntu:14.04

# Update packages
RUN apt-get update -y

# Install Python Setuptools
RUN apt-get install -y python-setuptools git telnet curl openjdk-7-jre

# Install pip
RUN easy_install pip

# Bundle app source
ADD . /src
WORKDIR /src

# Download LogStash
RUN curl -L -O https://download.elastic.co/logstash/logstash/logstash-2.2.2.tar.gz

RUN tar -zxf logstash-2.2.2.tar.gz

# Add and install Python modules
RUN pip install Flask

# Expose
EXPOSE  5000

# Run
CMD ["./startup.sh"]
```

### Docker build

Lassen Sie uns eine Beispielanwendung mit dem Befehl `docker build` erstellen:
```
# ls
Dockerfile  entry.py  logstash.conf.temp  startup.sh

# docker build -t hidetosaito/my-calc-elk .
Sending build context to Docker daemon  5.12 kB
Step 1 : FROM ubuntu:14.04
 ---> 1a094f2972de
Step 2 : RUN apt-get update -y
 ---> Using cache
 ---> 40ff7cc39c20
Step 3 : RUN apt-get install -y python-setuptools git telnet curl openjdk-7-jre
 ---> Running in 72df97dcbb9a

(skip…)

Step 11 : CMD ./startup.sh
 ---> Running in 642de424ee7b
 ---> 09f693436005
Removing intermediate container 642de424ee7b
Successfully built 09f693436005

//upload to Docker Hub using your Docker account
# docker login
Username: hidetosaito
Password: 
Email: hideto.saito@yahoo.com
WARNING: login credentials saved in /root/.docker/config.json
Login Succeeded

//push to Docker Hub
# docker push hidetosaito/my-calc-elk
The push refers to a repository [docker.io/hidetosaito/my-calc-elk] (len: 1)
09f693436005: Pushed 
b4ea761f068a: Pushed 

(skip…)

c3eb196f68a8: Image already exists 
latest: digest: sha256:45c203d6c40398a988d250357f85f1b5ba7b14ae73d449b3ca64b562544cf1d2 size: 22268
```

#### Kubernetes Replikations-Controller und Service

Verwenden Sie diese Anwendung jetzt von Kubernetes, um ein Log an Elasticsearch zu senden. Zuerst bereite ich die YAML-Datei vor, um diese Anwendung mit dem Replikations controller und dem Dienst wie folgt zu laden:
```
# cat my-calc-elk.yaml 
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-calc-elk-rc
spec:
  replicas: 2
  selector:
        app: my-calc-elk
  template:
    metadata:
      labels:
        app: my-calc-elk
    spec:
      containers:
      - name: my-calc-elk
        image: hidetosaito/my-calc-elk
---
apiVersion: v1
kind: Service
metadata:
  name: my-calc-elk-service

spec:
  ports:
    - protocol: TCP
      port: 5000
  type: ClusterIP
  selector:
     app: my-calc-elk
```

Verwenden Sie den Befehl `kubectl`, um den Replikations controller und den Dienst wie folgt zu erstellen:

```
# kubectl create -f my-calc-elk.yaml 
replicationcontroller "my-calc-elk-rc" created
service "my-calc-elk-service" created
```
Überprüfen Sie den Kubernetes-Service, um eine IP-Adresse für diese Anwendung wie folgt zu finden. Es zeigt hier `192.168.121.63`:

```
# kubectl get service
NAME                  CLUSTER_IP        EXTERNAL_IP   PORT(S)             SELECTOR                  AGE
elasticsearch         192.168.101.143                 9200/TCP,9300/TCP   component=elasticsearch   15h
kubernetes            192.168.0.1       <none>        443/TCP             <none>                    19h
my-calc-elk-service   192.168.121.63    <none>        5000/TCP            app=my-calc-elk           39s
```

Lassen Sie uns diese Anwendung mit dem Befehl `curl `wie folgt aufrufen:

```
# curl http://192.168.121.63:5000/
Hello World!

# curl http://192.168.121.63:5000/addition/3/5
8
```

### Kibana

Kibana (https://www.elastic.co/products/kibana) ist ein Visualisierungswerkzeug für Elasticsearch. Laden Sie Kibana herunter und geben Sie die Elasticsearch IP Adresse und Portnummer an, um Kibana zu starten:
```
//Download Kibana 4.1.6
# curl -O https://download.elastic.co/kibana/kibana/kibana-4.1.6-linux-x64.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 17.7M  100 17.7M    0     0  21.1M      0 --:--:-- --:--:-- --:--:-- 21.1M

//unarchive
# tar -zxf kibana-4.1.6-linux-x64.tar.gz

//Find Elasticsearch IP address
# kubectl get services
NAME                  CLUSTER_IP        EXTERNAL_IP   PORT(S)             SELECTOR                  AGE
elasticsearch         192.168.101.143                 9200/TCP,9300/TCP   component=elasticsearch   19h
kubernetes            192.168.0.1       <none>        443/TCP             <none>                    23h

//specify Elasticsearch IP address
# sed -i -e "s/localhost/192.168.101.143/g" kibana-4.1.6-linux-x64/config/kibana.yml

//launch Kibana
# kibana-4.1.6-linux-x64/bin/kibana
```
Dann sehen Sie das Anwendungsprotokoll. Erstellen Sie ein Diagramm wie folgt:

###### Hinweis

Dieses Kochbuch deckt nicht, wie man Kibana konfiguriert; Bitte besuchen Sie die offizielle Seite über die Kibana-Konfiguration über https://www.elastic.co/products/kibana.

![kibana-01](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_01.jpg)

### Wie es funktioniert…

Nun wird das Anwendungsprotokoll von Logstash erfasst; Es wird in das JSON-Format umgewandelt und dann an Elasticsearch geschickt.

Da Logstash mit einem Anwendungscontainer gebündelt wird, gibt es keine Probleme, wenn der Replikationscontroller die Anzahl der Repliken (Pods) erhöht. Es erfasst alle Anwendungsprotokolle ohne Konfigurationsänderungen.

Alle Protokolle werden in Elasticsearch wie folgt gespeichert:
![elk-diagram](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_08_02.jpg)

