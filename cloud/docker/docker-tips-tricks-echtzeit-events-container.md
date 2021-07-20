---
title: docker-tips-tricks-echtzeit-events-container
description: 
published: true
date: 2021-06-09T15:17:13.693Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:17:06.848Z
---

Da wir viele Container in der Produktiven Umgebung laufen werden, wird es hilfreich sein, wenn wir die Echtzeit-Container-Events für Monitoring und Debugging-Zwecke ansehen können. Docker-Container können Ereignisse melden, wie zB create, destroy, die, export, kill, oom, pause, restart, start, stop, und unpause. In diesem Rezept sehen wir, wie Sie die Ereignisprotokollierung aktivieren und dann Filter verwenden, um bestimmte Ereignistypen, Images oder Container auszuwählen.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und dass Sie sich über den Docker-Client eine Verbindung herstellen können.

### Wie es geht…

1. Starten Sie die Docker-Ereignisprotokollierung mit dem folgenden Befehl:
`$ docker events`

2. Von der anderen terminal,nehmen Sie einige Container/Imaegs in  Betrieb und Sie sehen ein Ergebnis ähnlich dem folgenden ergebnis auf dem ersten Terminal:
`docker events`

Nachdem die Eventsammlung gestartet wurde, habe ich einen Container erstellt, um einfach etwas zu erzeugen. Wie Sie aus der vorherigen ausgabe sehen können, wurde ein Container erstellt, gestartet und gelöscht.

### Wie es funktioniert…

Mit Docker-events startet Docker verschiedene Events.

### Es gibt mehr…

Sie können die `--since` oder `--until` Option mit Docker Events verwenden, um Ergebnisse für einen ausgewählten Zeitstempel einzuschränken:
```
  --since=""         Show all events created since timestamp 
  --until=""         Stream events until this timestamp 
```

Betrachten Sie das folgende Beispiel:

`$ docker events --since '2015-01-01'`

>* Mit Filtern können wir das Ereignisprotokoll auf der Grundlage von Events, Container und Image weiter einschränken:
>
>> * Um nur das Startereignis aufzulisten, verwenden Sie den folgenden Befehl:
>> `	$ docker events --filter 'event=start'`
>>
>> * Um die Ereignisse nur aus dem Bild CentOS aufzurufen, verwenden Sie den folgenden Befehl:
>> `	$ docker events --filter 'image=docker.io/centos:centos7'`
>>
>> * Um Ereignisse aus dem bestimmten Container aufzulisten, verwenden Sie den folgenden Befehl:
>>  `	docker events --filter 'container=b3619441cb444b87b4d79a8c30616ca70da4b5aa8fdc5d8a48d23a2082052174'`
>> 
>

### Siehe auch

*      Die Dokumentation auf der Docker-Website https://docs.docker.com/reference/commandline/cli/#events
