---
title: hive
description: 
published: true
date: 2021-06-09T15:24:49.911Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:24:44.517Z
---

Hive erweitert Hadoop um Data-Warehouse-Funktionalitäten, namentlich die Anfragesprache HiveQL und Indizes. 
HiveQL ist eine auf SQL basierende Abfragesprache und ermöglicht dem Entwickler somit die Verwendung einer SQL99-ähnlichen Syntax.
Seit Hive 2.0 wird Hybrid Procedural SQL On Hadoop (HPL/SQL) unterstützt, welches Ausführung von PL/SQL und vielen weiteren SQL-Dialekten unterstützt. 
Außerdem werden durch Verwendung des ORC-Tabellenformats, durch LLAP und vielen weiteren Optimierungen neben Batch-Anwendung zunehmend auch komplexe interaktive Abfragen unterstützt. 

Diese Optimierungen entstammen der Stinger-Initiative, welche auch eine Unterstützung von SQL:2011 Analytics vorsieht.
Erweiterungen wie HiveMall bieten in-database Analytics für komplexe Machine-Learning-Anwendungen.
Transaktionalität wird ebenfalls durch das ORC-Tabellenformat unterstützt. Es gibt die Möglichkeit,
traditionelle Indexe wie den B-Tree-Index und den Bitmap-Index zu definieren.
Für Data-Warehouse-Szenarien wird allerdings empfohlen, nicht diese zu nutzen, sondern das ORC-Format mit Unterstützung von Komprimierung,
Bloom-Filtern und Storage-Indexen.
Dies ermöglicht wesentlich performantere Abfragen, sofern die Daten sortiert sind.
Moderne Datenbank-Appliances wie Oracle Exadata unterstützen diese Optimierungsmöglichkeiten und empfehlen ebenfalls,
auf traditionelle Indexe aus Performance-Gründen zu verzichten.

Hive unterstützt die Ausführung von Abfragesprachen durch sogenannte „Engines“. 
MapReduce (MR) gilt als veraltet und sollte nicht mehr verwendet werden (seit 2.0 als „deprecated“ gekennzeichnet). 
Stattdessen wird TEZ empfohlen. Alternativ wird Spark als Engine angeboten. 
Beide basieren auf Optimierungsverfahren durch gerichtete azyklische Graphen.

LLAP bietet einen transparenten in-memory cache der auf interaktive Big Data Warehouse Anwendungen ausgerichtet ist.

Im Sommer 2008 stellte Facebook, der ursprüngliche Entwickler von Hive, das Projekt der Open-Source-Gemeinde zur Verfügung.
Die von Facebook verwendete Hadoop-Datenbank gehört mit etwas mehr als 100 Petabyte (Stand: August 2012) zu den größten der Welt.
Dieses Warehouse wuchs bis 2014 auf 300 PB an. 