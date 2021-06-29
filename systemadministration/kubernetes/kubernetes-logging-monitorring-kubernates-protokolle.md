---
title: kubernetes-logging-monitorring-kubernates-protokolle
description: 
published: true
date: 2021-06-09T15:34:45.856Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:34:37.365Z
---

Kubernetes kommt mit drei Daemon-Prozessen auf Master: API Server, Scheduler und Controller Manager. Unter dem `/var/log` Ordner befinden sich drei entsprechende Log-Dateien, die die Protokolle dieser Prozesse aufzeichnen:

|Deamon auf Master|Log Datei| Beschreibung|
| :---: | :---: | :---: |
|API server|`apiserver.log`| Logs für API aufrufe.|
|Scheduler|`k8s-scheduler.log`|Protokolle von Scheduler-Daten für alle Container, die Ereignisse planen|
|Controller manager|`controller-manager.log`|Logs für die Darstellung von Ereignissen oder Fragen im Zusammenhang mit dem Controller Manager|

Auf Nodes haben wir einen `kubelet` Prozess, um Container-Operationen zu behandeln und dem Master zu melden:

|Deamon auf Master|Log Datei| Beschreibung|
| :---: | :---: | :---: |
|`kubelet`|` kubelet.log `|Logs für alle Probleme im Container|

Bei beiden Mastern und Nodes gibt es eine weitere Protokolldatei mit dem Namen `kube-proxy.log`, um alle Probleme mit der Netzwerkverbindung aufzuzeichnen.

### Fertig werden

Wir werden die Log-Sammlungsplattform ELK verwenden, die im vorigen Abschnitt eingeführt wurde, um Kubernetes-Logs als zentrale Log-Plattform zu sammeln. Für die Einstellung von ELK möchten wir Ihnen vorschlagen, den Abschnitt "Anwendungsprotokolle sammeln" erneut zu überprüfen. Bevor wir mit dem Sammeln der Kubernetes-Protokolle beginnen, ist die Kenntnis der Datenstruktur in den Protokollen wichtig. Die vorherigen Protokolle haben das Format:

`<Log level> <date> <timestamp> <indicator> <source file>: <line number>] <logs>`

Das folgende ist ein Beispiel:
```
E0328 00:46:50.870875    3189 reflector.go:227] pkg/proxy/config/api.go:60: Failed to watch *api.Endpoints: too old resource version: 45128 (45135)
```

Durch das Überschrift-Zeichen der Zeilen in der Protokolldatei können wir die Log-Schwere dieser Zeile kennen:

*     D: DEBUG 
*     I: INFO 
*     W: WARN
*     E: ERROR
*     F: FATAL

### Wie es geht…

Wir verwenden den `grok` Filter immer noch in der `logstash` Einstellung, wie im vorherigen Abschnitt beschrieben, aber wir müssen vielleicht unser benutzerdefiniertes Muster für das `<log level> <date>` Muster schreiben, das am Anfang der Protokollzeile aufgeführt ist. Wir erstellen eine Musterdatei unter dem aktuellen Verzeichnis:

```
// list custom patterns
# cat ./patterns/k8s
LOGLEVEL    [DEFIW]
DATE        [0-9]{4}
K8SLOGLEVEL %{LOGLEVEL:level}%{DATE}
``` 
Die vorherige Einstellung wird verwendet, um das E0328-Muster in level=E und DATE=0328 aufzuteilen. Das folgende ist ein Beispiel dafür, wie man `k8s-apiserver.log` in den ElasticSearch-Cluster senden kann :
```
// list config file for k8s-apiserver.log in logstash
# cat apiserver.conf
input {
  file {
    path => "/var/log/k8s-apiserver.log"
  }
}

filter {
  grok {
    patterns_dir => ["./patterns"]
    match => { "message" => "%{K8SLOGLEVEL} %{TIME}    %{NUMBER} %{PROG:program}:%{POSINT:line}] %{GREEDYDATA:message}" }
  }
}

output {
  elasticsearch {
    hosts => ["_ES_IP_:_ES_PORT_"]
    index => "k8s-apiserver"
  }

  stdout { codec => rubydebug }
}

```
Für die Eingabe verwenden wir das Datei-Plugin (https://www.elastic.co/guide/de/logstash/current/plugins-inputs-file.html), das den Pfad des `k8s-apiserver.logs` hinzufügt. Wir werden `patterns_dir` in `grok `verwenden, um die Definition unserer benutzerdefinierten Muster `K8SLOGLEVEL `zu spezifizieren. Die Konfiguration des Hosts im Ausgabe-`elasticsearch`-Bereich sollte auf Ihre Elasticsearch IP und Portnummer angegeben werden. Das folgende ist ein Beispielausgang:
```
// start logstash with config apiserver.conf
# bin/logstash -f apiserver.conf
Settings: Default pipeline workers: 1
Pipeline main started
{
       "message" => [
        [0] "E0403 15:55:24.706498    2979 errors.go:62] apiserver received an error that is not an unversioned.Status: too old resource version: 47419 (47437)",
        [1] "apiserver received an error that is not an unversioned.Status: too old resource version: 47419 (47437)"
    ],
 "@timestamp" => 2016-04-03T15:55:25.709Z,
         "level" => "E",
          "host" => "kube-master1",
       "program" => "errors.go",
          "path" => "/var/log/k8s-apiserver.log",
          "line" => "62",
      "@version" => "1"
}
{
       "message" => [
        [0] "E0403 15:55:24.706784    2979 errors.go:62] apiserver received an error that is not an unversioned.Status: too old resource version: 47419 (47437)",
        [1] "apiserver received an error that is not an unversioned.Status: too old resource version: 47419 (47437)"
    ],
    "@timestamp" => 2016-04-03T15:55:25.711Z,
         "level" => "E",
          "host" => "kube-master1",
       "program" => "errors.go",
          "path" => "/var/log/k8s-apiserver.log",
          "line" => "62",
      "@version" => "1"
}
```
Es zeigt den aktuellen Host, den Log-Pfad, Log-Level, das ausgelöste Programm und das gesamte Log. 
Die anderen Protokolle sind alle im selben Format, also ist es einfach, die Einstellungen zu replizieren. Geben Sie einfach verschiedene Indizes von `k8s-apiserver` an die anderen an. Dann bist du frei, die Logs über Kibana zu durchsuchen oder die anderen Werkzeuge mit Elasticsearch zu integrieren, um Benachrichtigungen zu erhalten oder so weiter.

