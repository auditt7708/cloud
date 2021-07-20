---
title: kubernetes-konzepte-secrets
description: 
published: true
date: 2021-06-09T15:33:54.137Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:33:48.660Z
---

# Kubernates Konzepte zur Sicherheit

Kubernetes Geheimnisse verwalten Informationen in  key-value Formate mit dem value codiert. Mit secrets müssen die Benutzer keine Werte in der Konfigurationsdatei setzen oder in CLI eingeben. Wenn secrets ordnungsgemäß verwendet werden, können sie das Risiko von Credential Leck reduzieren und unsere Ressourcenkonfigurationen besser organisieren.

Derzeit gibt es drei Arten von Secrets:

* [Opaque](https://de.wikipedia.org/wiki/Opaque_data_type)

* Service account Token

* Docker Authentifizierung

Opaque ist der Standardtyp. Wir setzen Dienstkonto-Token und die Authentifizierung von Docker in der Bemerkung Teil.

## Fertig werden

Vor der Verwendung unserer Anmeldeinformationen mit secrets müssen einige Vorsichtsmaßnahmen getroffen werden. Zuerst haben secrets eine 1 MB Größenbeschränkung. Es funktioniert gut für die Definition mehrerer key-value Paare in einem einzigen secrets. Sie müssen sich aber bewusst sein, dass die Gesamtgröße 1 MB nicht überschreiten sollte. Als nächstes fungieren secrets wie ein Volumen für Container, so dass Geheimnisse vor abhängigen Pods erstellt werden sollten.

### Wie es geht…

Wir können nur mit Hilfe von Konfigurationsdateien Geheimnisse erzeugen. In diesem Rezept werden wir eine einfache Vorlagendatei liefern und uns auf die Funktionalität konzentrieren. Für verschiedene Vorlagen-Designs, werfen Sie bitte einen Blick auf die Arbeiten mit Konfigurationsdateien Rezept in [Spielen mit Containern](../kubernetes-container).

### Ein secret einrichten

Die Konfigurationsdatei schreiben die das secret type und data enthält:

```sh
// A simple file for configuring secret
# cat secret-test.json
{
  "kind": "Secret",
  "apiVersion": "v1",
  "metadata": {
    "name": "secret-test"
  },
  "type": "Opaque",
  "data": {
    "username": "YW15Cg==",
    "password": " UGEkJHcwcmQhCg=="
  }
}
```

Der geheime Typ Opaque ist der Standard, der einfach anzeigt, dass die Daten nicht angezeigt werden.
Die anderen Typen, account token und Docker-Authentifizierung werden bei der Verwendung der Werte `kubernetes.io/service-account-token` und `kubernetes.io/dockercfg` bei dem Typ stage angewendet.

Der `username` und das `password` sind benutzerdefinierte Schlüssel. Ihre entsprechenden Werte sind eine base64-codierte Zeichenfolge. Sie können Ihren codierten Wert durch diese Pipe-Befehle erhalten:

```sh
# echo "amy" | base64
YW15Cg==
```

Die Ressource Annotation und das Management von Geheimnissen ähnelt anderen Ressourcentypen. Fühlen Sie sich frei, ein Geheimnis zu erstellen und seinen Status zu überprüfen, indem Sie allgemeine Unterbefehle verwenden:

```sh
# kubectl create -f secret-test.json
secret "secret-test" created
# kubectl get secret
NAME          TYPE      DATA      AGE
secret-test   Opaque    2         39s
# kubectl describe secret secret-test
Name:    secret-test
Namespace:  default
Labels:    <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  10 bytes
username:  4 bytes

```

Wie Sie sehen können, obwohl das Geheimnis die Informationen verbirgt, können wir die Datenmenge, den Datennamen und auch die Größe des Wertes erhalten.

### secret in den Container aufheben

Um im Pod die geheimen Informationen zu erhalten, werden geheime Daten als Datei im Container eingebunden. Die Key-Value Pair-Daten werden im Klartext-Dateiformat angezeigt, das als Dateiname und den decodierten Wert als Dateieinhalt einen Schlüsselnamen einnimmt. Deshalb erstellen wir den Pod durch die Konfigurationsdatei, in der das gemountete volumen des Containers auf Secrets hingewiesen wird:

```sh
# cat pod-secret.json
{
  "kind": "Pod",
  "apiVersion": "v1",
  "metadata": {
    "name": "pod-with-secret"
  },
  "spec": {
    "volumes": [
      {
        "name": "secret-volume",
        "secret": {
          "secretName": "secret-test"
        }
      }
    ],
    "containers": [
      {
  "name": "secret-test-pod",
        "image": "nginx",
        "volumeMounts": [
          {
            "name": "secret-volume",
            "readOnly": true,
            "mountPath": "/tmp/secret-volume"
          }
        ]
      }
    ]
  }
}
```

Für die vorherige Vorlage definierten wir ein Volumen namens `secret-volume`, das physische Dateien mit dem Inhalt des geheimen `secret-test` enthält; Der Befestigungspunkt der Container wird auch zusammen mit dem Ort definiert, wo man geheime Dateien platziert und mit `secret-volume` verbunden ist. In diesem Fall könnte der Container auf Geheimnisse in seinem lokalen Dateisystem zugreifen, indem er `/tmp/secrets/<SECRET_KEY>` verwendet.

Um zu überprüfen, ob der Inhalt für die Verwendung des Container programms entschlüsselt wird, werfen wir einen Blick auf den spezifischen Container auf dem Node:

```sh
// login to node and enable bash process with new tty
# docker exec -it <CONTAINER_ID> bash
root@pod-with-secret:/# ls /tmp/secrets/
password  username
root@pod-with-secret:/# cat /tmp/secrets/password
Pa$$w0rd!
root@pod-with-secret:/# cat /tmp/secrets/username
amy
```

### Ein Geheimnis löschen

Geheimnis, wie andere Ressourcen, kann durch den Unterbefehl `delete` gelöscht werden. Beide Methoden, Löschen nach Konfigurationsdatei oder Löschen nach Ressourcenname sind bearbeitbar:

```sh
# kubectl delete -f secret-test.json
secret "secret-test" deleted
```

### Wie es funktioniert…

Um das Risiko zu verringern, den Inhalt der Geheimnisse auszulessen, speichert das Kubernetes-System niemals die Daten der Geheimnisse auf der Festplatte. Stattdessen werden Geheimnisse im Arbeitsspeicher gespeichert. Für eine genauere Aussage übergibt(push) der Kubernetes API-Server das secret an den Node, auf dem der geforderte Container läuft. Der Node speichert die Daten in `tmpfs`, die geflasht(gelöscht) werden, wenn der Container zerstört wird.

Versuchen Sie es selbst und überprüfen Sie den Node, mit dem Container mit den secretes auf dem  er läuft:

```sh
// check the disk
df -h --type=tmpfs
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           920M     0  920M   0% /dev/shm
tmpfs           920M   17M  903M   2% /run
tmpfs           920M     0  920M   0% /sys/fs/cgroup
tmpfs           184M     0  184M   0% /run/user/2007
tmpfs           920M  8.0K  920M   1% /var/lib/kubelet/pods/2edd4eb4-b39e-11e5-9663-0200e755981f/volumes/kubernetes.io~secret/secret-volume
```

Außerdem schlage ich vor, dass Sie vermeiden, ein großes Geheimnis oder viele kleine Geheimnisse zu schaffen. Da Geheimnisse in der Erinnerung an Knoten gehalten werden, kann die Verringerung der Gesamtgröße der Geheimnisse helfen, Ressourcen zu sparen und gute Leistung zu halten.

### Es gibt mehr…

In den vorherigen Abschnitten wird das Geheimnis im default service account konfiguriert. Das Dienstkonto kann Prozesse in Containern in verbindung mit dem API-Server anbieten. Sie könnten eine andere Authentifizierung haben, indem Sie verschiedene Dienstkonten erstellen.

Mal sehen, wie viele Service-Konten wir derzeit haben:

```sh
$ kubectl get serviceaccounts
NAME          SECRETS   AGE
default       0         18d

```

Kubernetes wird ein Standard-Service-Konto erstellen. Mal sehen, wie wir unsere eigenen erstellen können:

```sh
# example of service account creation
$ cat serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test-account

# create service account named test-account
$ kubectl create -f serviceaccount.yaml
serviceaccount "test-account" created
```

Nach der Erstellung, lasst uns die Nodes von `kubectl` auflisten:

```sh
$ kubectl get serviceaccounts
NAME           SECRETS   AGE
default        0         18d
test-account   0         37s

```

Wir können sehen, es gibt ein neues Dienstkonto namens `test-account` in der jestzt Liste.

Jedes Dienstkonto könnte sein eigenes API-Token, Image (pull) secrets und mount bare Geheimnisse haben.

Ebenso konnten wir das Dienstkonto mit `kubectl` löschen:

```sh
$ kubectl delete serviceaccount test-account
serviceaccount "test-account" deleted
```

Auf der anderen Seite kann die Docker-Authentifizierung auch als geheime Daten zum Ziehen(pull) von Images gespeichert werden. Wir werden die Verwendung in der Arbeit mit dem privaten Docker Registry Rezept in [Einrichten einer Continuous Delivery Pipeline](../kubernetes-cd-pipline)  diskutieren.
