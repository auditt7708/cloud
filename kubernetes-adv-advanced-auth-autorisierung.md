---
title: kubernetes-adv-advanced-auth-autorisierung
description: 
published: true
date: 2021-06-09T15:29:00.524Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:28:55.180Z
---

Um ein fortgeschritteneres Management nutzen zu können, können wir dem Kubernetes-System Berechtigungsregeln hinzufügen. In unserem Cluster konnten zwei Berechtigungstypen generiert werden: Einer ist zwischen den Maschinen. Nodes, die eine Authentifizierung haben, können sich mit dem steuernden Nodes in Verbindung setzen. Zum Beispiel kann der Master, der die Zertifizierung mit dem etcd-Server besitzt, Daten in etcd speichern. Die andere Berechtigungsregel befindet sich im Kubernetes-Master. Benutzer können die Berechtigung zur Überprüfung und Erstellung der Ressourcen erhalten. Das Anwenden von Authentifizierung und Autorisierung ist eine sichere Lösung, um zu verhindern, dass Ihre Daten oder Ihr Status von anderen aufgerufen werden.

### Fertig werden

Bevor Sie mit dem Konfigurieren Ihres Clusters mit einigen Berechtigungen beginnen, müssen Sie bitte Ihren Cluster installieren. Dennoch stoppen Sie jeden Service im System. Sie werden später mit der Authentifizierung aktiviert.

#### Wie es geht…

In diesem Rezept haben wir eine Diskussion über Authentifizierung und Autorisierung. Für die Authentifizierung, von etcd und die Kubernetes-Server muss die Identitätsprüfung zuvor erfolgreich sein, bevor sie auf die Anfragen zu reagieren. Auf der anderen Seite beschränkt die Autorisierung die Benutzer durch verschiedene Ressourcenzugriffsberechtigungen. Alle diese Kontakte basieren auf der API-Verbindung. Spätere Abschnitte zeigen Ihnen, wie Sie die Konfiguration abschließen und der Authentifizierung folgen können.

### Aktivieren der Authentifizierung für einen API-Aufruf

Es gibt mehrere Methoden, um die nicht authentifizierte Kommunikation im Kubernetes-System zu blockieren. Wir werden grundlegende Authentifizierungsmechanismen einführen. Es ist einfacher, es auf nicht nur die Kubernetes Master, sondern etcd Server zu setzen.

#### Grundlegende Authentifizierung von etcd

Zuerst wollen wir versuchen, API-Anfragen auf den etcd-Host zu senden. Sie werden feststellen, dass jeder auf die Daten standardmäßig zugreifen kann:

```
// Create a key-value pair in etcd
# curl -X PUT -d value="Happy coding" http://localhost:4001/v2/keys/message
{"action":"set","node":{"key":"/message","value":"Happy coding","modifiedIndex":4,"createdIndex":4}}
// Check the value you just push
# curl http://localhost:4001/v2/keys/message
{"action":"get","node":{"key":"/message","value":"Happy coding","modifiedIndex":4,"createdIndex":4}}
// Remove the value
# curl -X DELETE http://localhost:4001/v2/keys/message
{"action":"delete","node":{"key":"/message","modifiedIndex":5,"createdIndex":4},"prevNode":{"key":"/message","value":"Happy coding","modifiedIndex":4,"createdIndex":4}}
```

Ohne Authentifizierung können weder Lese- noch Schreibfunktionen geschützt werden. Der Weg, um die grundlegende Authentifizierung von etcd zu ermöglichen, ist auch durch die RESTful API. Das Verfahren ist wie folgt:

* Fügen Sie ein Kennwort für das Admin-Konto `root` hinzu 
* Grundlegende Authentifizierung aktivieren 
* Beenden Sie sowohl Lese- als auch Schreibberechtigungen des Gastkontos 

Stellen Sie sicher, dass der etcd-Dienst ausgeführt wird. Wir übernehmen die vorherigen Logiken in folgende Befehle:

```
// Send the API request for setup root account
# curl -X PUT -d "{\"user\":\"root\",\"password\":\"<YOUR_ETCD_PASSWD>\",\"roles\":[\"root\"]}" http://localhost:4001/v2/auth/users/root
{"user":"root","roles":["root"]}
// Enable authentication 
# curl -X PUT http://localhost:4001/v2/auth/enable
// Encode "USERACCOUNT:PASSWORD" string in base64 format, and record in a value
# AUTHSTR=$(echo -n "root:<YOUR_ETCD_PASSWD>" | base64)
// Remove all permission of guest account. Since we already enable authentication, use the authenticated root.
# curl -H "Authorization: Basic $AUTHSTR" -X PUT -d "{\"role\":\"guest\",\"revoke\":{\"kv\":{\"read\":[\"*\"],\"write\":[\"*\"]}}}" http://localhost:4001/v2/auth/roles/guest
{"role":"guest","permissions":{"kv":{"read":[],"write":[]}}}

```

Nun, für die Validierung, versuchen, alles in etcd durch die API zu überprüfen:
```
# curl http://localhost:4001/v2/keys
{"message":"Insufficient credentials"}
```

Da wir für diesen API-Aufruf keine Identität angegeben haben, gilt er als Antrag eines Gastes. Keine Berechtigung für das Anzeigen von Daten.

Für den langfristigen Gebrauch würden wir Benutzerprofile von etcd in die Konfiguration des Kubernetes-Masters setzen. Überprüfen Sie Ihre Konfigurationsdatei des Kubernetes API Servers. Im RHEL-Server ist die Datei` /etc/kubernetes/apiserver`; Oder für den anderen Linux-Server, nur die für den Service, `/etc/init.d/kubernetes-master`. Sie finden ein Flag für den etcd Server namens `--etcd-server`. Basierend auf den vorherigen Einstellungen ist der Wert, den wir angehängt haben, eine einfache URL mit einem Port. Es könnte `http://ETCD_ELB_URL:80` sein. Fügen Sie einen Account root und sein Kennwort in einem Klartextformat dem Wert hinzu, der der Berechtigungsheader für die HTTP-Anforderung ist. Der neue Wert für flag -etcd-server würde` http://root:YOUR_ETCD_PASSWD@ETCD_ELB_URL:80` heißen. Danach wird Ihr Kubernetes API-Server-Daemon mit einem Authentifizierungs-fähigen etcd-Endpunkt gut funktionieren.

### Grundlegende Authentifizierung des Kubernetes-Meisters

Bevor wir die Authentifizierung im Kubernetes-Master einrichten, lasst uns den Endpunkt des Masters zuerst überprüfen:
`# curl https://K8S_MASTER_HOST_IP:SECURED_PORT --insecure`

oder

```
# curl http://K8S_MASTER_ELB_URL:80
{
  "paths": [
    "/api",
    "/api/v1",
    "/apis",
    "/apis/extensions",
    "/apis/extensions/v1beta1",
    "/healthz",
    "/healthz/ping",
    "/logs/",
    "/metrics",
    "/resetMetrics",
    "/swagger-ui/",
    "/swaggerapi/",
    "/ui/",
    "/version"
  ]
}
```

Wir wollen nicht, dass die vorherige Nachricht allen verfügbar ist, oder? Gleich wie der etcd-Host kann der Kubernetes-Master die grundlegende Authentifizierung als Sicherheitsmechanismus anwenden. In diesem Abschnitt werden wir die Berechtigung des API-Servers einschränken. Abweichend von etcd wird die Information der Authentifizierung in einer Datei definiert:

```
// Create a file for basic authentication with content: PASSWORD,USERNAME,UID
# cat /root/k8s-bafile
<APISERVER_BA_PASSWORD>,<APISERVER_BA_USERACCOUNT>,1
```

Dann müssen wir diese Datei in der Konfigurationsdatei angeben. Je nach deinem Daemon-Management-Tool könnte sich die Konfigurationsdatei unter `/etc/init.d/kubernetes-master` oder `/etc/kubernetes/apiserver` befinden. Eine neue Flag namens `--basic-auth-file` sollte der Konfigurationsdatei hinzugefügt werden:

* Für die Datei `kubernetes-master`, anfügen flag `--basic-auth-file` nach dem Befehl `kube-apiserver` oder dem Befehl `hyperkube apiserver`. Der Wert für dieses Tag sollte der vollständige Pfad der grundlegenden Authentifizierungsdatei sein. Zum Beispiel, `--basic-auth-file=/root/k8s-bafile`.

`* Für die Datei `apiserver`, fügen Sie das Tag der Variablen` KUBE_API_ARGS` hinzu. Zum Beispiel `KUBE_API_ARGS=--basic-auth-file=/root/k8s-bafile`.

Am wichtigsten ist, dass der Benutzer, der die Dienste von Kubernetes startet, entweder root oder kubelet ist, die Berechtigung hat, auf die Datei zuzugreifen, die Sie an dem Tag angehängt haben. Nachdem Sie das neue Tag hinzugefügt haben, ist es notwendig, den Dienst neu zu starten, damit die Authentifizierung wirksam wird. Als nächstes ist es gut für dich, den `Curl`-Befehl am Anfang dieses Abschnitts zu versuchen. Es wird ` Unauthorized `zurückgegeben, ohne den Benutzernamen und das Passwort zu geben.

Unsere Nodes kommunizieren mit dem API-Server über den unsicheren Port `8080`. Obwohl wir keine Rolle für die Autorisierung der Berechtigung angeben mussten, sollten Sie sich bewusst sein, die Firewall des Masters zu konfigurieren, die nur den Knoten erlaubt, durch den Port `8080 `zu gehen. Auf AWS gibt es eine Sicherheits Gruppe die für diesen Teil helfen.

Es gibt noch einige Methoden für die Authentifizierung des Kubernetes-Masters. Bitte überprüfen Sie die offizielle Website auf andere Ideen (http://kubernetes.io/docs/admin/authentication/).

#### Benutzung der Benutzerberechtigung verwenden

Wir können auch andere Benutzerberechtigungen für den API-Server-Daemon des Kubernetes-Masters hinzufügen. Für die Benutzerberechtigung sind drei Flags erforderlich. Sie sind wie folgt:

* `--autorisierungsmodus=ABAC`: Der Wert ABAC ist die Abkürzung für Attribute-Based Access Control. Wenn Sie diesen Modus aktivieren, können wir benutzerdefinierte Benutzerberechtigungen einrichten.

* `--token-auth-file=<FULL_PATH_OF_YOUR_TOKEN_FILE>`: Dies ist die Datei, mit der wir die qualifizierten Benutzer für den API-Zugang bekannt geben. Es ist möglich, mehr Konten und Tokenpaare bereitzustellen.

* `--autorisierung-policy-file=<FULL_PATH_OF_YOUR_POLICY_FILE>`: Wir benötigen diese Richtliniendatei, um getrennte Regeln für verschiedene Benutzer zu generieren.

Diese speziellen Tags werden nach dem Befehl `kube-apiserver` oder `hyperkube apiserver` angehängt. Sie können sich auf folgendes Beispiel beziehen:
```
// The daemon configuration file of Kubernetes master for init.d service 
# cat /etc/init.d/kubernetes-master
(above lines are ignored)
:
# Start daemon.
    echo $"Starting apiserver: "
    daemon $apiserver_prog \
    --service-cluster-ip-range=${CLUSTER_IP_RANGE} \
    --insecure-port=8080 \
    --secure-port=6443 \
    --authorization-mode=ABAC \
    --token-auth-file=/root/k8s-tokenfile \
    --authorization-policy-file=/root/k8s-policyfile \
    --address=0.0.0.0 \
    --etcd-servers=${ETCD_SERVERS} \
    --cluster-name=${CLUSTER_NAME} \
    > ${logfile}-apiserver.log 2>&1 &
:
(below lines are ignored)
```
oder
```
// The kubernetes apiserver's configuration file for systemd service in RHEL
# cat /etc/kubernetes/apiserver
(above lines are ignored)
:
KUBE_API_ARGS="--authorization-mode=ABAC --token-auth-file=/root/k8s-tokenfile --authorization-policy-file=/root/k8s-policyfile"
```
Sie müssen noch die Datei für das Konto und die Datei für die Richtlinie konfigurieren. Um die Verwendung der benutzerdefinierten Benutzerberechtigung zu demonstrieren, zeigt Ihnen der folgende Inhalt von Dateien, wie Sie ein Admin-Konto mit vollem Zugriff und einem schreibgeschützten Konto erstellen können:

```
# cat /root/k8s-tokenfile
k8s2016,admin,1
happy123,amy,2
```

Das Format der Benutzerdefinition ähnelt der grundlegenden Authentifizierungsdatei, die wir vorher erwähnt haben. Jede Zeile hat diese Elemente in Folgender reienfolge: Token, Benutzername und UID. Anders als admin, erstellen wir ein anderes Benutzerkonto namens `amy`, das nur Leseberechtigung bekommet:

```
# cat /root/k8s-policyfile
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "admin", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user": "amy", "namespace": "*", "resource": "*", "readonly": true}}
```
Für die policy datei ist jede Zeile eine policy im JSON-Format. Jede policy sollte den Benutzer angeben, der seiner Regel zugehört. Die erste Richtlinie für admin erlaubt die Steuerberechtigung für jede Namespace-, Ressourcen- und API-Gruppe. 
Der Schlüssel `apiGroup `gibt verschiedene API-Kategorien an. Beispielsweise ist der Ressourcenauftrag in der `extensions` API-Gruppe definiert. Um auf den `job` zuzugreifen, sollte der `extensions` typ in `apiGroup` aufgenommen werden. Die zweite Richtlinie wird mit schreibgeschützter Berechtigung definiert, dh die Rolle `amy `kann nur Ressourcen anzeigen, aber keine Aktionen erstellen, entfernen und bearbeiten.

Später starten Sie alle Dämonen des Kubernetes-Masters neu, nachdem Sie beide Konfigurationsdateien und Servicedateien bereit gemacht haben:

```
// For init.d service management
# service kubernetes-master restart
// Or, you can restart the individually with dependency
# systemctl stop kube-scheduler
# systemctl stop kube-controller-manager
# systemctl stop kube-apiserver
# systemctl start kube-apiserver
# systemctl start kube-controller-manager
# systemctl start kube-scheduler
```
