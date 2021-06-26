---
title: jaeger
description: 
published: true
date: 2021-06-09T15:26:23.367Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:26:18.156Z
---

# jaeger

Monitorring und fehlerbehebung von transcations in komplexen systemen

## jaeger Konfigiration Basics

Heir der aufruf via docker.
```s
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.13
```

|Port|Protocol|Kompunente| Funktion|
| :--: | :---: | :---: | :---: |
|5775|UDP|agent||
|6831|UDP|agent||
|6832|UDP|agent||
|5778|HTTP|agent||
|16686|HTTP|query||
|14268|HTTP|collector||
|14250|HTTP|collector||
|9411|HTTP|collector||



**Quelle**

* [jaeger Homepage](https://www.jaegertracing.io/)
* [Getting started](https://www.jaegertracing.io/docs/1.8/getting-started/)
* [jaeger github](https://github.com/jaegertracing/jaeger)