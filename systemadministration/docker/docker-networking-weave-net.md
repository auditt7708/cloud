---
title: docker-networking-weave-net
description: 
published: true
date: 2021-06-09T15:12:33.365Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:12:28.160Z
---

# Docker und weave net

Weave Net (Weave for short) ist eine Drittanbieter-Netzwerklösung für Docker. Früher gab es den Nutzern zusätzliche Netzwerkfunktionalität außerhalb von dem, was Docker nativ angeboten hat. Zum Beispiel lieferte Weave Overlay-Netzwerke und WeaveDNS, bevor Docker begann, benutzerdefinierte Overlay-Netzwerke und eingebettete DNS zu unterstützen. Doch mit den neueren Releases hat Docker begonnen, Feature-Parität aus einer Netzwerkperspektive mit Weave zu gewinnen. Das heißt, Weave hat noch viel zu bieten und ist ein interessantes Beispiel dafür, wie ein Drittanbieter-Tool mit Docker interagieren kann, um Container-Netzwerke bereitzustellen. In diesem Kapitel gehen wir durch die Grundlagen der Installation und Konfiguration von Weave, um mit Docker zu arbeiten und einige der Weaves-Funktionalität aus einer Netzwerkperspektive zu beschreiben. Während wir einige Zeit damit verbringen werden, einige der Eigenschaften von Weave zu demonstrieren, ist dies nicht beabsichtigt, ein How-to-Guide für die gesamte Weave-Lösung zu sein. Es gibt viele Eigenschaften von Weave, die in diesem Kapitel nicht behandelt werden. Ich empfehle Ihnen, überprüfen Sie ihre Website für die meisten up-to-date Informationen über Funktionen und Funktionalität (https://www.weave.works/).

## Übersicht

* [Installation und Konfiguration von Weave](../docker-networking-weave-net-install-konfiguration)
* [Umgang mit Weave-verbundenen containern](../docker-networking-weave-net-benutzen)
* [Verstehen von Weave IPAM](../docker-networking-weave-net-ipam)
* [Arbeiten mit WeaveDNS](../docker-networking-weave-net-dns)
* [Weave und Sicherheit](../docker-networking-weave-net-sicherheit)
* [Benutzen des Weave network plugins](docker-networking-weave-net-plugins)
