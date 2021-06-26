---
title: docker-arbeiten-images-supermin
description: 
published: true
date: 2021-06-09T15:06:48.525Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:06:43.392Z
---

# Docker arbeiten mit Images: Superadmin

Früher in diesem Kapitel benutzten wir die `FROM`-Anweisung, um das Basisimage zu starten.
Das Image, das wir erstellen, kann das Basisimage werden, um eine andere Anwendung zu veröffentlichen und so weiter. Von Anfang an bis zu dieser Kette werden wir ein Basisimage von der zugrunde liegenden Linux-Distribution haben, die wir wie Fedora, Ubuntu, CentOS und so weiter nutzen wollen.

Um ein solches Basisbild zu erstellen, müssen wir ein verteilungsspezifisches Basissystem in einem Verzeichnis installieren, das dann als Image auf Docker importiert werden kann. Mit chroot-Dienstprogramm können wir ein Verzeichnis als Root-Dateisystem benutzen und dann alle notwendigen Dateien hinein Kopieren, bevor es als Docker-Image importiert wird. Supermin und Debootstrap sind die Art von Werkzeugen, die uns helfen können, den vorherigen Prozess zu erleichtern.

Supermin ist ein Werkzeug, um Supermin Geräte zu bauen. Das sind winzige Geräte, die sich sofort in die Hand nehmen. Früher wurde dieses Programm febootstrap genannt.

## Fertig werden

Installiere Supermin auf dem System, wo Sie das Basisbild erstellen möchten. Sie können Supermin auf Fedora mit dem folgenden Befehl installieren:
`$ yum install supermin`

### Wie es geht…

1.Verwenden Sie die `prepare` modus-Installation `bash`, `coreutils` und die zugehörigen Abhängigkeiten in einem Verzeichnis.
`$ supermin --prepare -o OUTPUTDIR PACKAGE [PACKAGE ...]`

Hier ist ein Beispiel mit der vorherigen Syntax:
`$ supermin --prepare bash coreutils -o f21_base`

2.Erstellen Sie nun mit dem `Build`-Modus eine Chroot-Umgebung für das Basisbild:
`$ supermin --build -o OUTPUTDIR -f chroot|ext2 INPUT [INPUT ...]`
Hier ist ein Beispiel mit der vorherigen Syntax:
`$ supermin --build --format chroot f21_base -o f21_image`

3.Wenn wir auf dem Ausgabeverzeichnis arbeiten, sehen wir einen Verzeichnisbaum ähnlich einem Linux-Root-Dateisystem:

```sh
ls f21_image/
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

4.Jetzt können wir das Verzeichnis als Docker-Bild mit folgendem Befehl exportieren:

```sh
$ tar -C f21_image/ -c . | docker import - nkhare/f21_base
d6db8b798dee30ad9c84480ef7497222f063936a398ecf639e60599eed7f6560

5. Schauen Sie sich die `docker images` an. Du solltest ein neues Bild mit `nkhare/f21_base` als den Namen haben.

### Wie es funktioniert…

Supermins hat zwei Modi, `prepare` und `build`.
Mit dem `prepare` modus platziert es einfach alle angeforderten Pakete mit ihren Abhängigkeiten in ein Verzeichnis, ohne die Host-OS-spezifischen Dateien zu kopieren.

Mit dem `Build`-Modus wird die zuvor erstellte Supermin Appliance aus dem Vorbereitungsmodus in eine voll ausgeblasenen und bootfähigen Appliance mit allen notwendigen Dateien konvertiert. Dieser Schritt kopiert die benötigten Dateien / Binärdateien vom Host-Rechner in das Appliance-Verzeichnis, so dass die Pakete auf den Host-Rechnern installiert sein müssen, die Sie in der Appliance verwenden möchten.

Der `Build`-Modus hat zwei Ausgabeformate, chroot und ext2. Mit dem chroot-Format wird der Verzeichnisbaum in das Verzeichnis geschrieben und mit dem ext2-Format wird ein Disk-Image erstellt. Wir exportierten das Verzeichnis, das über das Chroot-Format erstellt wurde, um das Docker-Image zu erstellen.

### Es gibt mehr…

Supermin ist nicht spezifisch für Fedora und sollte an jeder Linux-Distribution arbeiten.
