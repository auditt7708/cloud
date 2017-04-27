Typischerweise hat unsere Anwendungsarchitektur das monolithische Design, das Model-View-Controller (MVC) und jede Komponente innerhalb einer einzigen großen Binärdatei enthält.

Monolithische Software hat einige Vorteile, wie weniger Latenz innerhalb von Komponenten, alle in einer einfachen Verpackung, und einfach zu implementieren und zu testen.

Allerdings hat ein monolithisches Design einige nachteile, weil die Binärdatein werden immer größer und größer. Sie müssen sich immer um die Nebenwirkungen kümmern, wenn Sie den Code hinzufügen oder ändern, also die Freigabezyklen länger machen.

Container und Kubernetes bieten mehr Flexibilität bei der Verwendung von Microservices für Ihre Anwendung. Die microservices Architektur ist sehr einfach, die in einige Module oder einige Service-Klassen mit MVC zusammen unterteilt werden kann.

![Monolithic and microservices design](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_01.jpg)
Monolithic and microservices design

Jeder microservice bietet Remote Procedure Call (RPC) mit RESTful oder einigen Standard-Netzwerk-APIs zu anderen microservices. Der Vorteil ist, dass jeder Microservice unabhängig ist. Es gibt minimale Nebenwirkungen beim Hinzufügen oder Ändern des Codes. 
Lassen Sie den Zyklus unabhängig voneinander, so dass es perfekt mit der Agilen Software-Entwicklungsmethodik passt und so ermöglicht es, diese Microservices wiederzuverwenden, um eine andere Anwendung zu erstellen, die das Mikrosystem-Ökosystem schritt für schritt aufbaut.

### Fertig werden

Bereiten Sie das einfache microservices Programm vor. Um Ihre microservices zu uploaden(push) und zu downloaden(pull), melden Sie sich bitte bei Docker Hub (https://hub.docker.com/) an, um Ihre kostenlose Docker Hub ID zu erstellen.

### Wie es geht…

Bereiten Sie sowohl microservices als auch die Frontend WebUI als Docker-Image vor. Dann entfalten sie sie mit dem Kubernetes replication controller und Service.

### Microservices

* Hier ist der einfache Microservice mit Python Flask (http://flask.pocoo.org/):

```
$ cat entry.py
from flask import Flask, request

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

@app.route("/power/<int:base>/<int:index>")
def power(base, index):
    return "%d" % (base ** index)

@app.route("/addition/<int:x>/<int:y>")
def add(x, y):
    return "%d" % (x+y)

@app.route("/substraction/<int:x>/<int:y>")
def substract(x, y):
    return "%d" % (x-y)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
```

2. Bereiten Sie eine `Dockerfile` wie folgt vor, um das Docker-Bild zu erstellen:
```
$ cat Dockerfile
FROM ubuntu:14.04

# Update packages
RUN apt-get update -y

# Install Python Setuptools
RUN apt-get install -y python-setuptools git telnet curl

# Install pip
RUN easy_install pip

# Bundle app source
ADD . /src
WORKDIR /src

# Add and install Python modules
RUN pip install Flask

# Expose
EXPOSE  5000

# Run
CMD ["python", "entry.py"]
```
3. Verwenden Sie dann den Befehl `docker build`, um das Docker-Bild wie folgt zu erstellen:

###### Tip
Wenn Sie das Docker-Bild veröffentlichen, sollten Sie den `Docker Hub ID/Image name` als Docker Image namen verwenden.
```
//name as "your_docker_hub_id/my-calc"
$ sudo docker build -t hidetosaito/my-calc .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM ubuntu:14.04
 ---> 6cc0fc2a5ee3
Step 2 : RUN apt-get update -y
 ---> Using cache

(snip)

Step 8 : EXPOSE 5000
 ---> Running in 7c52f4bfe373
 ---> 28f79bb7481f
Removing intermediate container 7c52f4bfe373
Step 9 : CMD python entry.py
 ---> Running in 86b39c727572
 ---> 20ae465bf036
Removing intermediate container 86b39c727572
Successfully built 20ae465bf036

//verity your image
$ sudo docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
hidetosaito/my-calc   latest              20ae465bf036        19 seconds ago      284 MB
ubuntu                14.04               6cc0fc2a5ee3        3 weeks ago         187.9 MB
```

4. Verwenden Sie dann den `docker login` Befehl, um sich bei Docker Hub anzumelden:
```
//type your username, password and e-mail address in Docker hub
$ sudo docker login
Username: hidetosaito
Password:
Email: hideto.saito@yahoo.com
WARNING: login credentials saved in /home/ec2-user/.docker/config.json
Login Succeeded 
```

5. Verwenden Sie schließlich den `docker push` Befehl, um sich wie folgt an Ihr Docker-Hub-Repository anzumelden:
```
//push to your docker index
$ sudo docker push hidetosaito/my-calc
The push refers to a repository [docker.io/hidetosaito/my-calc] (len: 1)
20ae465bf036: Pushed 
(snip)
92ec6d044cb3: Pushed 
latest: digest: sha256:203b81c5a238e228c154e0b53a58e60e6eb3d1563293483ce58f48351031a474 size: 19151
```

Beim Zugriff auf Docker Hub können Sie Ihre Microservices im Repository sehen:
![docker-hub-repositories](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_04.jpg)
Microservice image on Docker Hub

### Frontend WebUI


1. Hier ist die einfache Frontend WebUI, die auch Python Flask verwendet:
```
import os
import httplib
from flask import Flask, request, render_template
app = Flask(__name__)
@app.route("/")
def index():
    return render_template('index.html')

@app.route("/add", methods=['POST'])
def add():
    #
    # from POST parameters
    #
    x = int(request.form['x'])
    y = int(request.form['y'])

    #
    # from Kubernetes Service(environment variables)
    #
    my_calc_host = os.environ['MY_CALC_SERVICE_SERVICE_HOST']
    my_calc_port = os.environ['MY_CALC_SERVICE_SERVICE_PORT']

    #
    # remote procedure call to MicroServices(my-calc)
    #
    client = httplib.HTTPConnection(my_calc_host, my_calc_port)
    client.request("GET", "/addition/%d/%d" % (x, y))
    response = client.getresponse()
    result = response.read()

    return render_template('index.html',
        add_x=x, add_y=y, add_result=result)

if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0')
```

###### Tip
Der Kubernetes-Service erzeugt den Kubernetes-Servicenamen und die Portnummer als Umgebungsvariable zu den anderen Pods. 
Daher muss der Name der Umgebungsvariablen und der Name des Kubernetes-Dienstes konsistent sein.

In diesem Szenario muss es der `my-calc` Service-Name `my-calc-service` sein.


2. Frontend WebUI verwendet die Flask HTML Vorlage; Es ist ähnlich wie PHP und JSP, so dass `entry.py` den Parameter an die Vorlage (`index.html`) übergibt, um das HTML zu rendern:
```
<html>
<body>
<div>
    <form method="post" action="/add">
        <input type="text" name="x" size="2"/>
        <input type="text" name="y" size="2"/>
        <input type="submit" value="addition"/>
    </form>

    {% if add_result %}
    <p>Answer : {{ add_x }} + {{ add_y }} = {{ add_result }}</p>
    {% endif %}
</div>
</body>
</html>
```

3. `Dockerfile` ist genau das gleiche wie Microservices. Also, schließlich wird die Dateistruktur wie folgt sein. Beachten Sie, dass index.html eine Vorlagendatei ist. Also stelle es in das Vorlagenverzeichnis:
```
/Dockerfile
/entry.py
/templates/index.html
```

4. Dann baue ich ein Docker-Bild und uploade(push) auf Docker Hub wie folgt:

###### Notiz
Um dein Image auf Docker Hub zu uploaden(push), musst du dich mit dem `docker login` Befehl anmelden. Es wird nur einmal gebraucht; Das System überprüft `~ /.docker/config.json` um von dort aus deine anmeldung zu lesen.

```
//build frontend Webui image 
$ sudo docker build -t hidetosaito/my-frontend .

//login to docker hub, if not login yet
$ sudo docker login

//push frontend webui image
$ sudo docker push hidetosaito/my-frontend
```

![Microservices and Frontend WebUI image on Docker Hub](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_05_05.jpg)
Microservices and Frontend WebUI image on Docker Hub

### Wie es funktioniert…

Starten Sie sowohl Microservices als auch die Frontend WebUI.

### Microservices

Microservices (`my-calc`) nutzt den replication controller und den Service von Kubernetes, muss aber nur mit anderen Pods kommunizieren. Mit anderen Worten, es besteht keine Notwendigkeit, es dem äußeren Kubernetes-Netzwerk verfügbar zu machen. Daher wird der Service-Typ als `ClusterIP` gesetzt:
```
# cat my-calc.yaml 
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-calc-rc
spec:
  replicas: 2
  selector:
        app: my-calc
  template:
    metadata:
      labels:
        app: my-calc
    spec:
      containers:
      - name: my-calc
        image: hidetosaito/my-calc
---
apiVersion: v1
kind: Service
metadata:
  name: my-calc-service

spec:
  ports:
    - protocol: TCP
      port: 5000
  type: ClusterIP
  selector:
     app: my-calc
```

Verwenden Sie den Befehl `kubectl`, um die `my-calc` Pods wie folgt zu laden:

```
$ sudo kubectl create -f my-calc.yaml
replicationcontroller "my-calc-rc" created
service "my-calc-service" created
```

### Frontend WebUI

Frontend WebUI verwendet auch den replication controller und den Dienst, aber er stellt den Port (TCP Port `30080`) bereit, um von einem externen Webbrowser darauf zuzugreifen: