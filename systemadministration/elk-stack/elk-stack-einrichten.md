---
title: elk-stack-einrichten
description: 
published: true
date: 2021-06-09T15:19:00.461Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:18:55.436Z
---

Für die Ausführung von ELK Stack ist eine Java-Laufzeit erforderlich. Die neueste Version von Java wird für die Installation empfohlen. Zum Zeitpunkt des Schreibens dieses Artikels ist die Mindestanforderung Java 7. Sie können die offizielle Oracle-Distribution oder eine Open-Source-Distribution wie OpenJDK verwenden.

Sie können die Java-Installation überprüfen, indem Sie den folgenden Befehl in Ihrer Shell ausführen:
```
> java -version
java version "1.8.0_40"
Java(TM) SE Runtime Environment (build 1.8.0_40-b26)
Java HotSpot(TM) 64-Bit Server VM (build 25.40-b25, mixed mode)

```
Wenn Sie die Java-Installation in Ihrem System überprüft haben, können wir mit der ELK-Installation fortfahren.


## [Elasticsearch](../elasticsearch)
[Einrichtung für ELK Stack](../elk-konfiguration)

### [Ubuntu 16.04 ](../ubuntu1604)
Quellen: 
* [etup-elk-stack-ubuntu-16-04](http://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/setup-elk-stack-ubuntu-16-04.html)
* [setup-elk-stack-ubuntu-16](http://linoxide.com/ubuntu-how-to/setup-elk-stack-ubuntu-16/)
* []()

## [Logstash](../elk-stack-logstash)
* [Input Dataset](../elk-stack-logstsh-input-dataset)

## [Kibana](../elk-stackkibana)
* [Visualisierung mit Kibana version 4](../elk-stack-kibana4-visualisierung)
* [Visualisierung mit Kibana version 5](../elk-stack-kibana5-visualisierung)


|Upgrade Von|Upgrade Nach | Supported Upgrade Type | 
| --- | --- | --- |
|3.x |5.x|[Neue Installation](https://www.elastic.co/guide/en/kibana/current/upgrade-new-install.html)||
|4.0 or 4.1| 5.x | [Standart upgrade & reindex](https://www.elastic.co/guide/en/kibana/current/upgrade-standard-reindex.html) |
|4.x >= 4.2| 5.x | [Standard upgrade](https://www.elastic.co/guide/en/kibana/current/upgrade-standard.html)| 
|5.0.0 vor GA| 5.x | [Standart upgrade & reindex](https://www.elastic.co/guide/en/kibana/current/upgrade-standard-reindex.html) |
|5.x|5.y|[Standard upgrade](https://www.elastic.co/guide/en/kibana/current/upgrade-standard.html ) wenn y > x|
