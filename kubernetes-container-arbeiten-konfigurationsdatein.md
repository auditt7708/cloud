---
title: kubernetes-container-arbeiten-konfigurationsdatein
description: 
published: true
date: 2021-06-09T15:31:24.095Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:31:18.124Z
---

Kubernetes unterstützt zwei verschiedene Dateiformate YAML und JSON. Jedes Format kann die gleiche Funktion von Kubernetes beschreiben.

### Fertig werden

Sowohl YAML als auch JSON haben offizielle Webseiten, die das Standardformat beschreiben.

#### YAML

Das YAML-Format ist mit weniger Syntaxregeln sehr einfach. Daher ist es leicht zu lesen und zu schreiben von einem Menschen. Um mehr über YAML zu erfahren, kannst du auf die folgende Website verweisen:

Http://www.yaml.org/spec/1.2/spec.html

Im folgenden Beispiel wird das YAML-Format verwendet, um den nginx-Pod einzurichten:
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
```

#### JSON

Das JSON-Format ist auch einfach und leicht von Menschen zu lesen, aber mehr programmfreundlich. Da es Datentypen (Nummer, String, Boolean und Objekt) hat, ist es beliebt, die Daten zwischen Systemen auszutauschen. Um mehr über JSON zu erfahren, kannst du auf die folgende Website verweisen:

Http://json.org/

Das folgende Beispiel des Pod ist das gleiche wie das vorhergehende YAML-Format, aber mit dem JSON-Format:
```
{
    "apiVersion" : "v1",
    "kind" : "Pod",
    "metadata" : {
      "name" : "nginx",
      "labels": {
        "name": "nginx"
      }
    },
    "spec" : {
      "containers" : [
        {
            "name" : "nginx",
            "image" : "nginx",
            "ports" : [
               {
                 "containerPort": 80
               }
            ]
        }
      ]
    }
}
```

Wie es geht…

Kubernetes hat ein Schema, das über das Konfigurationsformat definiert ist. Schema kann man im Verzeichnis `/tmp/kubectl.schema/` beim Ausführen des Befehls `kubectl create` wie folgt generieren:
```
# cat pod.json
{
    "apiVersion" : "v1",
    "kind" : "Pod",
    "metadata" : {
      "name" : "nginx",
      "labels": {
        "name": "nginx"
      }
    },
    "spec" : {
      "containers" : [
        {
            "name" : "nginx",
            "image" : "nginx",
            "ports" : [
               {
                 "containerPort": 80
               }
            ]
        }
      ]
    }
}

# kubectl create -f pod.json
pod "nginx" created

# ls -l /tmp/kubectl.schema/v1.1.3/api/v1/schema.json
-rw------- 2 root root 446224 Jan 24 04:50 /tmp/kubectl.schema/v1.1.3/api/v1/schema.json
```

Es gibt einen alternativen Weg, denn Kubernetes benutzt auch Swagger (http://swagger.io/), um die REST API zu erzeugen; Daher kannst du auf `swagger-ui` über `http://<kubernetes-master>:8080/swagger-ui/` zugreifen.

Jede Konfiguration, z. B. Pods, replication controllers und Services, werden im **POST**-Bereich beschrieben, wie im folgenden Screenshot gezeigt:

![swagger-ui](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_03_06.jpg)

Der vorhergehende Screenshot von `swagger-ui` zeigt die Definition des Pods. Typen von Elementen wie `string`, `array` und `integer` werden angezeigt, wenn Sie auf **Modell** wie folgt klicken:

![swagger-model](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_03_07.jpg)

Der vorherige Screenshot zeigt die Pod-Container-Definition. Es gibt viele Gegenstände, die definiert sind; Allerdings werden einige von ihnen als optional gekennzeichnet, was nicht notwendig und als Standardwert angewendet wird oder nicht gesetzt ist, wenn Sie es nicht angeben.

###### Tip
Einige der Items werden als readonly, wie UID, angegeben. Kubernetes erzeugt diese Gegenstände. Wenn Sie dies in der Konfigurationsdatei angeben, werden diese ignoriert.

### Wie es funktioniert…

Es gibt einige obligatorische Elemente, die in jeder Konfigurationsdatei wie folgt definiert werden müssen:

#### Pods

|Item|Typ|Beispiel|
| :---: | :---: | :---: |
|apiVersion|String|v1|
|kind|String|Pod|
|metadata.name|String|my-nginx|
|spec|v1.PodSpec||
|v1.PodSpec.containers|array[v1.Container]||
|v1.Container.name|String|my-nginx|
|v1.Container.image|String|nginx|

Daher ist die minimale Pod-Konfiguration wie folgt (im YAML-Format):
```
apiVersion: v1
kind: Pod
metadata:
  name: my-nginx
spec:
  containers:
  - name: my-nginx
    image: nginx
```

#### Replication controllers

|Item|Typ|Beispiel|
| :---: | :---: | :---: |
|apiVersion|String|v1|
|kind|String|ReplicationController|
|metadata.name|String|my-nginx-rc|
|spec|v1.PodSpec||
|v1.ReplicationControllerSpec.template|v1.PodTemplateSpec||
|v1.PodTemplateSpec.metadata.labels|Map of String|app:nginx|
|v1.PodTemplateSpec.spec|v1.PodSpec ||
|v1.PodSpec.containers|array[v1.Container]|As same as pod|

Das folgende Beispiel ist die minimale Konfiguration des Replikationscontrollers (im YAML-Format):

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-nginx-rc
spec:
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: my-nginx
        image: nginx
```

#### Services

|Item|Typ|Beispiel|
| :---: | :---: | :---: |
|apiVersion|String|v1|
|kind|String|Service|
|metadata.name|String|my-nginx-service|
|spec|v1.PodSpec||
|v1.ServiceSpec.selector|Map of String|sel: my-selector|
|v1.ServiceSpec.ports|array[v1.ServicePort]||
|v1.ServicePort.protocol|String|TCP|
|v1.ServicePort.port|Integer|80|

Das folgende Beispiel ist die minimale Konfiguration des Dienstes (im YAML-Format):
```
apiVersion: v1
kind: Service
metadata:
  name: my-nginx

spec:
  selector:
     sel: my-selector
  ports:
    - protocol: TCP
      port: 80
```

