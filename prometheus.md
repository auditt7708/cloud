# Installation von  Prometheus auf Ubuntu 18.04 LTS

Prometheus ist ein kostenloses Open-Source-Software-Ökosystem,
mit dem Messdaten aus unseren Anwendungen erfasst und in einer Datenbank gespeichert werden können,
insbesondere in einer auf Zeitreihen basierenden Datenbank. 
Es ist ein sehr leistungsfähiges Überwachungssystem,
das sich für dynamische Umgebungen eignet. Prometheus ist in Go geschrieben und verwendet die Abfragesprache für die Datenverarbeitung.
Prometheus bietet Metriken für CPU, Arbeitsspeicher, Festplattennutzung, E/A, Netzwerkstatistik, MySQL-Server und Nginx.

## Prometheus Eigenschaften

Prometheus Hauptmerkmale:

* ein mehrdimensionales Datenmodell mit Zeitreihendaten, die durch Metriknamen und Schlüssel / Wert-Paare identifiziert werden
* PromQL, eine flexible Abfragesprache , um diese Dimensionalität zu nutzen
* keine Abhängigkeit von verteilter Speicherung; einzelne Server-Knoten sind autonom
* Die Zeitserienerfassung erfolgt über ein Pull-Modell über HTTP
* Push-Zeitreihen werden über ein zwischengeschaltetes Gateway unterstützt
* Ziele werden über Service Discovery oder statische Konfiguration ermittelt
* Unterstützung für mehrere Grafik- und Dashboard-Modi

`api_http_requests_total{method="POST", handler="/messages"}`

Dies ist die gleiche Schreibweise, die OpenTSDB verwendet.

### Prometheus abfragen mit PromQL

Datentypen für Ausdruckssprache:

* **Sofortvektor** - eine Reihe von Zeitreihen, die einen einzelnen Abtastwert für jede Zeitreihe enthalten und alle den gleichen Zeitstempel haben
* **Entfernungsvektor** - eine Reihe von Zeitreihen eine Reihe von Datenpunkten über die Zeit für jede Zeitreihe enthält ,
* **Skalar** - ein einfacher numerischer Fließkommawert
* **String** - ein einfacher Stringwert; derzeit nicht verwendet

Literale

String-Literale

```s
"this is a string"
'these are unescaped: \n \\ \t'
`these are not unescaped: \n ' " \t`
```

Float Literale



Zeitreihen-Selektoren
Sofortige Vektor-Selektoren

`http_requests_total`

`http_requests_total{job="prometheus",group="canary"}`

* **=:** Wählen Sie Beschriftungen aus, die der angegebenen Zeichenfolge genau entsprechen.
* **!=:** Wählen Sie Beschriftungen aus, die der angegebenen Zeichenfolge nicht entsprechen.
* **=~:** Wählen Sie Beschriftungen aus, die mit der angegebenen Zeichenfolge (oder Teilzeichenfolge) übereinstimmen.
* **!~:** Wählen Sie Beschriftungen aus, die der angegebenen Zeichenfolge (oder Teilzeichenfolge) nicht entsprechen.

Bereichsvektor-Selektoren

* **s** - Sekunden
* **m** - Protokoll
* **h** - Std
* **d** - Tage
* **w** - Wochen
* **y** - Jahre

`http_requests_total{job="prometheus"}[5m]`


## Komponenten

* der **Prometheus- Hauptserver**, der Zeitreihendaten speichert und speichert
* Client-Bibliotheken zur Instrumentierung von Anwendungscode
* ein **Push-Gateway** zur Unterstützung kurzlebiger Jobs
* Spezial- Exports für Dienste wie HAProxy, StatsD, Graphit, usw.
* ein **Alertmanager** , der Alerts behandelt
* verschiedene unterstützungstools

### Prometheus Server

### Prometheus Push-Gatewa

### Prometheus Alertmanager

#### Prometheus Alertmanager pagerduty

#### Prometheus Alertmanager Email

## Quellen

* [monitor-ubuntu-server-with-prometheus](https://www.howtoforge.com/tutorial/monitor-ubuntu-server-with-prometheus/)