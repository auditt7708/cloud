---
title: monitoring
description: 
published: true
date: 2021-06-15T07:20:46.884Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:40:20.766Z
---

# Monitoring

## SAR

SAR system CPU I/O statistiken 3 mal mit einem 1 sec interval

`sar -b 1 3`

## iostst

IO Geräte statistiken

`iostat -p sda`

## mpstst

Processor statistiken

Alle Infos

`mpstat -A`

Cpu ode cores

`mpstat -P ALL`

## vmstat

Virtual memory statistiken

Alle 2 sec 10 mal

`vmstat 2 10`

## Basic resource monitoring

* [Icinga2](../icinga2)

### Quellen

* [monitoring-das-maechtigste-werkzeug](https://www.informatik-aktuell.de/entwicklung/methoden/monitoring-das-maechtigste-werkzeug-fuer-cloud-microservices-und-business.html)

* [cachethq The open source status page system](https://cachethq.io/)

* [ubuntu-server-with-prometheus](https://www.howtoforge.com/tutorial/monitor-ubuntu-server-with-prometheus/)

* [prometheus](../prometheus)