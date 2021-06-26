---
title: kubernetes-adv-advanced-working-restful-api
description: 
published: true
date: 2021-06-09T15:29:31.734Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:29:26.504Z
---

Der Kubernetes-Administrator kann den Kubernetes-Cluster über den Befehl `kubectl `steuern. Es unterstützt die lokale und entfernte Ausführung. Allerdings müssen einige Administratoren oder Betreiber ein Programm zur Steuerung des Kubernetes-Clusters integrieren.

Kubernetes hat eine RESTful API, die die Steuerung des Kubernetes-Clusters über API ähnlich dem Befehl `kubectl `ermöglicht.

### Fertig werden

Die RESTful API ist standardmäßig geöffnet, wenn wir den API Server starten. Sie können die RESTful API über den `Curl`-Befehl wie folgt aufrufen:
```
//assume API server is running at localhost port number 8080
# curl http://localhost:8080/api
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ]
}
```

### Wie es geht…

Lassen Sie uns einen Replikationscontroller mit dem folgenden JSON-Format erstellen:

```
# cat nginx-rc.json 
{
    "apiVersion": "v1",
    "kind": "ReplicationController",
    "metadata": {
        "name": "my-first-rc"
    },
    "spec": {
        "replicas": 2,
        "template": {
            "spec": {
                "containers": [
                    {
                        "image": "nginx",
                        "name": "my-nginx"
                    }
                ]
            },
            "metadata": {
                "labels": {
                    "app": "nginx"
                }
            }
        },
        "selector": {
            "app": "nginx"
        }
    }
}
```
Senden Sie eine Anfrage zum Erstellen eines Replikationscontrollers wie folgt:

```
# curl -XPOST -H "Content-type: application/json" -d @nginx-rc.json http://localhost:8080/api/v1/namespaces/default/replicationcontrollers
```

Dann `kubectl get rc` Befehl sollte wie folgt sein:

```
# kubectl get rc
CONTROLLER    CONTAINER(S)   IMAGE(S)   SELECTOR    REPLICAS   AGE
my-first-rc   my-nginx       nginx      app=nginx   2          10s
```

Verwenden Sie natürlich den `Curl`-Befehl, um über eine RESTful API zu überprüfen, wie folgt:
```
# curl -XGET http://localhost:8080/api/v1/namespaces/default/replicationcontrollers
```

Die Löschung kann auch über eine RESTful API erfolgen, wie folgt:
`# curl -XDELETE http://localhost:8080/api/v1/namespaces/default/replicationcontrollers/my-first-rc`


Lassen Sie uns das Programm schreiben, das denselben Prozess ausführt. Im Folgenden ist es Python 2.7-Code, der denselben Replikations-Controller erstellt:

```
# cat nginx-rc.py

import httplib
import json
k8s_master_url = "localhost"
k8s_master_port = 8080
namespace="default"

headers = {"Content-type": "applicaiton/json"}

rc = {}
rc["apiVersion"] = "v1"
rc["kind"] = "ReplicationController"
rc["metadata"] = {"name" : "my-second-rc"}
rc["spec"] = {
    "replicas": 2,
    "selector": {"app": "nginx"},
    "template": {
        "metadata": {"labels": {"app": "nginx"}},
        "spec": {
            "containers" :[
                {"name": "my-nginx", "image": "nginx"}
            ]
        }
    }
}

h1 = httplib.HTTPConnection(k8s_master_url, k8s_master_port)
h1.request("POST", "/api/v1/namespaces/%s/replicationcontrollers" % namespace, json.dumps(rc), headers)
res = h1.getresponse()

print "return code = %d" % res.status
```

Sie können diesen Code mit dem Python-Interpreter wie folgt ausführen:
```
# python nginx-rc.py 
return code = 201

//HTTP return code 201 meant "Created"

```

### Wie es funktioniert…

Die RESTful API ermöglicht die CRUD (Erstellen, Lesen, Aktualisieren und Löschen) Operationen, die die gleichen Konzepte hinter jeder modernen Web-Anwendung sind. Weitere Informationen finden Sie unter https://de.wikipedia.org/wiki/Create,_read__update_and_delete.

Kubernetes RESTful API Beispiele und verwandte HTTP Methoden sind wie folgt:

|Operation|Http Metohde|Beispiel|
| :---: | :---: | :---: |
|Create|`POST`|` POST /api/v1/namespaces/default/services `|
|Read|`GET`|` GET /api/v1/componentstatuses `|
|Update|`PUT`|` PUT /api/v1/namespaces/default/replicationcontrollers/my-first-rc `|
|Delete|`DELETE`|` DELETE /api/v1/namespaces/default/pods/my-nginx `|

Die gesamten Kubernetes RESTful APIs werden von Swagger (http://swagger.io/) definiert. Sie können eine detaillierte Beschreibung über `http://<API Server IP Address>:<API Server Port>/swagger-ui` sehen.

![swagger-ui](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_07_06.jpg)

