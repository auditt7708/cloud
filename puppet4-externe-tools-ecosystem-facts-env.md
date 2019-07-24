<<<<<<< HEAD
Ein weiterer praktischer Weg, um Informationen in Puppet und Facter zu bekommen, ist, es mit Umgebungsvariablen zu übergeben. Jede Umgebungsvariable, deren Name mit `FACTER_` beginnt, wird als Tatsache interpretiert. Zum Beispiel, fragen Sie den Wert von hallo mit dem folgenden Befehl:

```
=======
# puppet4-externe-tools-ecosystem-facts-env

Ein weiterer praktischer Weg, um Informationen in Puppet und Facter zu bekommen, ist, es mit Umgebungsvariablen zu übergeben. Jede Umgebungsvariable, deren Name mit `FACTER_` beginnt, wird als Tatsache interpretiert. Zum Beispiel, fragen Sie den Wert von hallo mit dem folgenden Befehl:

```s
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook ~]# facter -p hello
Hello, world
```

Überschreiben Sie nun den Wert mit einer Umgebungsvariablen und fragen Sie noch einmal:
<<<<<<< HEAD
```
=======

```s
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook ~]# FACTER_hello='Howdy!' facter -p hello
Howdy!
```

Es funktioniert genauso gut mit Puppet, also lasst uns ein Beispiel durchlaufen.

<<<<<<< HEAD
#### Wie es geht...

In diesem Beispiel legen wir eine Tatsache fest, die eine Umgebungsvariable verwendet:

1. Halten Sie die Knotendefinition für Kochbuch das gleiche wie unser letztes Beispiel:
```
=======
## Wie es geht

In diesem Beispiel legen wir eine Tatsache fest, die eine Umgebungsvariable verwendet:

1.Halten Sie die Knotendefinition für Kochbuch das gleiche wie unser letztes Beispiel:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
node cookbook {
  notify {"$::hello": }
}
```

<<<<<<< HEAD
2. Führen Sie den folgenden Befehl aus:
```
=======
2.Führen Sie den folgenden Befehl aus:

```pp
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
[root@cookbook ~]# FACTER_hello="Hallo Welt" puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1416212026'
Notice: Hallo Welt
Notice: /Stage[main]/Main/Node[cookbook]/Notify[Hallo Welt]/message: defined 'message' as 'Hallo Welt'
Notice: Finished catalog run in 0.27 seconds
<<<<<<< HEAD
```
=======
```
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
