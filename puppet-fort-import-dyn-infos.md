---
title: puppet-fort-import-dyn-infos
description: 
published: true
date: 2021-06-09T15:49:26.212Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:49:20.877Z
---

# Puppet für fortgeschrittene:  Import Dynaischer Informationen

Auch wenn sich einige Systemadministratoren gern aus dem Rest des Büros mit Stapeln alter Drucker abwischen, müssen wir alle von Zeit zu Zeit uns mit anderen Abteilungen austauschen.
Zum Beispiel können Sie Daten in Ihre Puppet Manifests einfügen, die von einer externen Quelle abgeleitet werden.
Die generierende Funktion ist dafür ideal. Funktionen werden auf der Maschine ausgeführt, die den Katalog kompiliert (der Master für zentrale Bereitstellungen); Ein Beispiel wie das hier gezeigte wird nur in einer Master losen Konfiguration funktionieren.

## Fertig werden

Gehen Sie folgendermaßen vor, um das Beispiel vorzubereiten:

1.Erstellen Sie das `` script mit folgenden Inhalt:

```ruby
#!/usr/bin/env ruby
puts "This runs on the master if you are centralized"
```

2.MAchen Sie das Script ausführbar.
`$ sudo chmod a+x /usr/local/bin/message.rb`

## Wie es geht

Dieses Beispiel ruft das externe Skript auf, das wir zuvor erstellt haben und bekommt seine Ausgabe:

1.Erstellen Sie ein `message.pp` manifest mit folgendem inhalt:

```ruby
$message = generate('/usr/local/bin/message.rb')
notify { $message: }
```

2.Puppet run:

```ruby
$ puppet apply message.pp
...
Notice: /Stage[main]/Main/Notify[This runs on the master if you are centralized
]/message: defined 'message' as 'This runs on the master if you are centralized
```

## Wie es funktioniert

Die `generate` Funktion führt das angegebene Skript oder Programm aus und gibt das Ergebnis in diesem Fall eine fröhliche Nachricht von Ruby zurück.

Das ist nicht furchtbar nützlich, aber man bekommt eine Idee wie es funktioniert. Alles, was ein Skript tun kann, drucken, abrufen oder berechnen, zum Beispiel die Ergebnisse einer Datenbank-Abfrage, können in Ihr Manifest mit generieren gebracht werden. Sie können natürlich auch Standard-UNIX-Dienstprogramme wie Katze und grep ausführen.

## Es gibt mehr

Wenn Sie Argumente an die ausführbare Datei übergeben müssen, fügen Sie sie als zusätzliche Argumente zum Funktionsaufruf hinzu:

`$message = generate('/bin/cat', '/etc/motd')`

Puppet wird versuchen, Sie vor schädlichen Shell-Anrufen zu schützen, indem Sie die Zeichen beschränken, die Sie in einem Aufruf verwenden können, so dass zum Beispiel Shell-Pipes und Umleitung nicht erlaubt sind. Die einfachste und sicherste Sache es zu tun ist, alle Ihre Logik in ein Skript zu setzen und dann das Skript zu nennen.