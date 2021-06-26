---
title: packer
description: 
published: true
date: 2021-06-09T15:43:54.976Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:43:49.691Z
---

# Packer

## Einführung in Packer

Willkommen in der Welt von Packer! In diesem Einführungsleitfaden erfahren Sie, was Packer ist, warum es existiert, welche Vorteile es bietet und wie Sie damit beginnen können. Wenn Sie mit Packer bereits vertraut sind, enthält die Dokumentation mehr Informationen zu allen verfügbaren Funktionen.

## Was ist Packer?

Packer ist ein Open Source-Tool zum Erstellen identischer Computer-Images für mehrere Plattformen aus einer einzigen Quellkonfiguration.
Der Packer ist leicht, läuft auf jedem großen Betriebssystem und ist hochperformant, da er Maschinen-Images für mehrere Plattformen parallel erstellt.
Packer ersetzt nicht die Konfigurationsverwaltung wie Chef oder Puppet.
Beim Erstellen von Images kann Packer Tools wie Chef oder Puppet verwenden, um Software auf dem Image zu installieren.

Ein Maschinenabbild ist eine einzelne statische Einheit, die ein vorkonfiguriertes Betriebssystem und installierte Software enthält, mit der schnell neue laufende Maschinen erstellt werden können.
Maschinenbildformate ändern sich für jede Plattform.
Beispiele hierfür sind AMIs für EC2- , VMDK/VMX-Dateien für VMware, OVF-Exporte für VirtualBox usw.

## Anwendungsfälle

Inzwischen sollten Sie wissen, was Packer macht und welche Vorteile die Image-Erstellung bietet. In diesem Abschnitt listen wir einige Anwendungsfälle für Packer auf. Beachten Sie, dass dies keinesfalls eine erschöpfende Liste darstellt. Es gibt definitiv Anwendungsfälle für Packer, die hier nicht aufgeführt sind. Diese Liste soll Ihnen nur eine Vorstellung davon vermitteln, wie Packer Ihre Prozesse verbessern kann.

## Kontinuierliche Lieferung

Der Packer ist leicht, tragbar und wird über die Befehlszeile gesteuert. Dies macht es zum idealen Werkzeug, um mitten in Ihre kontinuierliche Lieferpipeline zu gelangen. Mit dem Packer können bei jeder Änderung an Chef / Puppet neue Maschinenimages für mehrere Plattformen erstellt werden.

Als Teil dieser Pipeline können die neu erstellten Images gestartet und getestet werden, um zu überprüfen, ob die Infrastrukturänderungen funktionieren. Wenn die Tests erfolgreich sind, können Sie sicher sein, dass das Image bei der Bereitstellung funktioniert. Dies bringt ein neues Maß an Stabilität und Testbarkeit für Infrastrukturänderungen.

## Dev/Prod-Parität

Packer hilft dabei, Entwicklung, Staging und Produktion so ähnlich wie möglich zu gestalten.
Mit dem Packer können Images für mehrere Plattformen gleichzeitig generiert werden.
Wenn Sie also AWS für die Produktion und VMware (möglicherweise mit Vagrant) für die Entwicklung verwenden, können Sie sowohl einen AMI- als auch einen VMware-Computer mit Packer gleichzeitig aus derselben Vorlage generieren.

Mischen Sie dies mit dem oben genannten Anwendungsfall für die kontinuierliche Bereitstellung. Sie haben ein ziemlich schlankes System für konsistente Arbeitsumgebungen von der Entwicklung bis zur Produktion.

## Appliance/Demo-Erstellung

Da Packer parallel konsistente Images für mehrere Plattformen erstellt, ist er ideal für die Erstellung von Appliances und Einwegproduktdemos.
Wenn sich Ihre Software ändert, können Sie Appliances automatisch mit der vorinstallierten Software erstellen.
Potentielle Benutzer können dann mit Ihrer Software beginnen, indem Sie sie in der Umgebung ihrer Wahl bereitstellen.

Software mit komplexen Anforderungen zusammenzustellen, war noch nie so einfach. Oder erfreulich, wenn Sie mich fragen.

## Boot Kommandos

```s
<bs> - Backspace
<del> - Delete
<enter> and <return> - Simulates an actual "enter" or "return" keypress.
<esc> - Simulates pressing the escape key.
<tab> - Simulates pressing the tab key.
<f1> - <f12> - Simulates pressing a function key.
<up> <down> <left> <right> - Simulates pressing an arrow key.
<spacebar> - Simulates pressing the spacebar.
<insert> - Simulates pressing the insert key.
<home> <end> - Simulates pressing the home and end keys.
<pageUp> <pageDown> - Simulates pressing the page up and page down keys.
<leftAlt> <rightAlt> - Simulates pressing the alt key.
<leftCtrl> <rightCtrl> - Simulates pressing the ctrl key.
<leftShift> <rightShift> - Simulates pressing the shift key.
<leftAltOn> <rightAltOn> - Simulates pressing and holding the alt key.
<leftCtrlOn> <rightCtrlOn> - Simulates pressing and holding the ctrl key.
<leftShiftOn> <rightShiftOn> - Simulates pressing and holding the shift key.
<leftAltOff> <rightAltOff> - Simulates releasing a held alt key.
<leftCtrlOff> <rightCtrlOff> - Simulates releasing a held ctrl key.
<leftShiftOff> <rightShiftOff> - Simulates releasing a held shift key.
<wait> <wait5> <wait10> - Adds a 1, 5 or 10 second pause before sending any additional keys. This is useful if you have to generally wait for the UI to update before typing more.

```

## Builders

### Docker

### File

### QEMU

### OpenStack

### VirtualBox

## Beispiele Comunity Frameworks

* [drbd-centos7-ansible und Packer](https://github.com/woltere/drbd-centos7-ansible)
* [Packker Builds boxcutter](https://github.com/boxcutter)
* [Debian and Ubuntu virtual machine images for Vagrant, VirtualBox and QEMU](https://github.com/tylert/packer-build)
* [Racker is an opinionated Ruby DSL for generating Packer templates](https://github.com/aspring/racker)
* [A Ruby model that lets you build Packer configurations in Ruby](https://github.com/ianchesal/packer-config)

## Dokumentation

* [Packer Templats](https://github.com/travis-ci/packer-templates)
* [server-vm-images-ansible-and-packer](https://www.jeffgeerling.com/blog/server-vm-images-ansible-and-packer)
* [packer-centos-7](https://github.com/geerlingguy/packer-centos-7)
