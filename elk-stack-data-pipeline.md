---
title: elk-stack-data-pipeline
description: 
published: true
date: 2021-06-09T15:18:53.741Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:18:48.957Z
---

Eine typische ELK-Stack-Datenpipeline sieht so aus:

![elk-stack-data-pipeline](https://www.packtpub.com/graphics/9781787288546/graphics/_01_01.jpg)

In einer typischen ELK Stack-Datenpipeline werden Protokolle von mehreren Anwendungsservern über Logstash-Shipper zu einem zentralen Logstash-Indexer ausgeliefert. 
Der Logstash-Indexer gibt Daten an einen Elasticsearch-Cluster aus, der von Kibana abgefragt wird, um große Visualisierungen anzuzeigen und Dashboards über die Protokolldaten zu bauen.