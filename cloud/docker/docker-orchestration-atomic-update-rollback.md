---
title: docker-orchestration-atomic-update-rollback
description: 
published: true
date: 2021-06-09T15:13:10.609Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:13:05.507Z
---

# Docker orchestration atomic update und rollback

Um auf die neueste Version zu gelangen oder auf die ältere Version von Project Atomic zurückzukehren, verwenden wir den `atomic host` Befehl, der intern rpm-ostree anruft.

## Fertig werden

Starten und melden sich beim Atomic-Host an.

## Wie es geht…

1. Nach dem Booten führen Sie den folgenden Befehl aus:
`$ atomic host status`

Sie sehen Details über eine Bereitstellung, die jetzt verwendet wird.
`sudo atomic host status`

Zum upgraden , wird folgender Befehl benutzt:
`sudo atomic host upgrade`

2.Dies ändert und/oder fügt neue Pakete hinzu. Nach dem Upgrade müssen wir das System neu starten, um das neue Update zu verwenden(in neueren Versionen könnte es auch ohne Neustart gehen.!). Lass uns neu starten und das Ergebnis sehen:

`atomic host status`

Wie wir sehen können, wird das System nun mit dem neuen Update gestartet. Das `*`, das am Anfang der ersten Zeile steht, gibt den aktiven Build an.

3.Um zurückzusetzen, führen Sie den folgenden Befehl aus:

`$ sudo atomic host rollback`

Wir müssen wieder neu starten, wenn wir ältere Buils verwenden wollen.

## Wie es funktioniert…

Für Updates verbindet sich der Atomic-Host mit dem Remote-Repository, das das neuere Build hostet, das vom nächsten Neustart heruntergeladen und verwendet wird, bis der Benutzer ein Upgrade oder Rolls zurückführt. Im Fall Rollback älteren Build auf dem System nach dem Neustart verwendet.

## Siehe auch

* Die Dokumentation Project Atomic Website, die unter http://www.projectatomic.io/docs/os-updates/ gefunden werden kann
