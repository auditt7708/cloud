---
title: strace
description: 
published: true
date: 2021-06-09T16:07:04.158Z
tags: 
editor: markdown
dateCreated: 2021-06-09T16:06:58.545Z
---

# strace

startet programm und gibt dessen Systemaufrufe auf dem Bildschirm aus

`strace programm`

startet programm und gibt dessen Systemaufrufe auf dem Bildschirm aus mit dem user mustermann

`strace -u mustermann programm`

Ausgabe in prog.log Logdatei

`strace -o prog.log programm`

verfolgt auch Kindprozesse

`strace -f -o prog.log programm`

verfolge die Aufrufe des laufenden Prozesses mit Prozess-ID pid

`strace -p pid`

gibt nur Systemaufrufe aus, die das Dateimanagement betreffen

`strace -e trace=open,close,read,write`

Quellen:

* [mit-strace-prufen-was-ein-programm-so-treibt](http://www.effinger.org/blog/2010/05/08/mit-strace-prufen-was-ein-programm-so-treibt/)
* [strace](https://strace.io/)