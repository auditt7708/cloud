Wenn Sie eine Puppe ändern müssen, ändern Sie eine bestimmte Einstellung in einer Konfigurationsdatei, es ist üblich, einfach die gesamte Datei mit Puppet einzusetzen. Das ist aber nicht immer möglich; Vor allem, wenn es eine Datei ist, die mehrere verschiedene Teile Ihres Puppet Manifestes möglicherweise ändern müssen.

Was wäre sinnvoll, ist ein einfaches Rezept, um eine Zeile zu einer Konfigurationsdatei hinzuzufügen, wenn es nicht bereits vorhanden ist, z. B. Hinzufügen eines Modulnamens zu / etc / modules, um dem Kernel zu sagen, dieses Modul beim Booten zu laden. Es gibt mehrere Möglichkeiten, dies zu tun, die einfachste ist, den file_line-Typ zu verwenden, der vom puppetlabs-stdlib-Modul bereitgestellt wird. In diesem Beispiel installieren wir das stdlib-Modul und verwenden diesen Typ, um eine Zeile an eine Textdatei anzuhängen.

### Fertig werden

Installiere das `puppetlabs-stdlib` Modul mit Puppe:
```
t@mylaptop ~ $ puppet module install puppetlabs-stdlib
Notice: Preparing to install into /home/thomas/.puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/home/thomas/.puppet/modules
└── puppetlabs-stdlib (v4.5.1)
```

Dies installiert das Modul aus der Schmiede in das Puppenverzeichnis meines Benutzers. Um in das Systemverzeichnis zu installieren, führen Sie den Befehl als root aus oder verwenden Sie `sudo`. Für diesen Zweck werden wir weiterhin als eigener Benutzer arbeiten.

### Wie es geht...

Mit dem file_line Ressourcentyp können wir sicherstellen, dass eine Zeile existiert oder in einer Konfigurationsdatei nicht vorhanden ist. Mit file_line können wir schnell Änderungen an Dateien vornehmen, ohne die gesamte Datei zu kontrollieren.

1. Erstellen Sie einen manifesten Namen online.app, der file_line auf einer Datei in / tmp verwendet:
```
  file {'/tmp/cookbook':
    ensure => 'file',
  }
  file_line {'cookbook-hello':
    path    => '/tmp/cookbook',
    line    => 'Hello World!',
    require => File['/tmp/cookbook'],
  }
```

2. Run Puppe gelten auf der oneline.pp manifest:
```
t@mylaptop ~/.puppet/manifests $ puppet apply oneline.pp 
Notice: Compiled catalog for mylaptop in environment production in 0.39 seconds
Notice: /Stage[main]/Main/File[/tmp/cookbook]/ensure: created
Notice: /Stage[main]/Main/File_line[cookbook-hello]/ensure: created
Notice: Finished catalog run in 0.02 seconds

```

3. Vergewissern Sie sich, dass `/tmp/cookbook` die Zeile enthält, die wir definiert haben:
```
t@mylaptop ~/.puppet/manifests $ cat /tmp/cookbook
Hello World!
```

### Wie es funktioniert…

Wir haben das `puppetlabs-stdlib` Modul in den Standard-Modulpfad für Puppet eingebaut. Wenn also die `üuppet apply` ist, wusste Puppet, wo die Definition der `file_line` Typs zu finden war. Puppet hat dann die `/tmp/cookbook` datei erstellt, wenn sie nicht existiert. Die Linie `Hello World!` Wurde in der Datei nicht gefunden, also hat Puppet die Zeile zur Datei hinzugefügt.

### Es gibt mehr…

Wir können mehr Instanzen von `file_line` definieren und weitere Zeilen zur Datei hinzufügen; Wir können mehrere Ressourcen ändern, die eine einzelne Datei ändern.

Ändern Sie die Datei `oneline.pp` und fügen Sie eine weitere Datei `file_line` hinzu:
```
  file {'/tmp/cookbook':
    ensure => 'file',
  }
  file_line {'cookbook-hello':
    path    => '/tmp/cookbook',
    line    => 'Hello World!',
    require => File['/tmp/cookbook'],
  }
  file_line {'cookbook-goodbye':
    path    => '/tmp/cookbook',
    line    => 'So long, and thanks for all the fish.',
    require => File['/tmp/cookbook'],
  }
```

Jetzt das Manifest erneut anwenden und überprüfen, ob die neue Zeile an die Datei angehängt ist:
```
t@mylaptop ~/.puppet/manifests $ puppet apply oneline.pp 
Notice: Compiled catalog for mylaptop in environment production in 0.36 seconds
Notice: /Stage[main]/Main/File_line[cookbook-goodbye]/ensure: created
Notice: Finished catalog run in 0.02 seconds
t@mylaptop ~/.puppet/manifests $ cat /tmp/cookbook 
Hello World!
So long, and thanks for all the fish.
```

Der `file_line` Typ unterstützt auch Musterabstimmung und Zeilenentfernung, wie wir Ihnen im folgenden Beispiel zeigen werden:
```
  file {'/tmp/cookbook':
    ensure => 'file',
  }
  file_line {'cookbook-remove':
    ensure  => 'absent',
    path    => '/tmp/cookbook',
    line    => 'Hello World!',
    require => File['/tmp/cookbook'],
  }
  file_line {'cookbook-match':
    path    => '/tmp/cookbook',
    line    => 'Oh freddled gruntbuggly, thanks for all the fish.',
    match   => 'fish.$',
    require => File['/tmp/cookbook'],
  }
```

Überprüfe den Inhalt von `/tmp/cookbook` vor deinem Puppet run:
```
t@mylaptop ~/.puppet/manifests $ cat /tmp/cookbook 
Hello World!
So long, and thanks for all the fish.
```

Wenden Sie das aktualisierte Manifest an:
```
t@mylaptop ~/.puppet/manifests $ puppet apply oneline.pp 
Notice: Compiled catalog for mylaptop in environment production in 0.30 seconds
Notice: /Stage[main]/Main/File_line[cookbook-match]/ensure: created
Notice: /Stage[main]/Main/File_line[cookbook-remove]/ensure: removed
Notice: Finished catalog run in 0.02 seconds
```

Vergewissern Sie sich, dass die Zeile entfernt wurde und die Abschiedslinie ersetzt wurde:
```
t@mylaptop ~/.puppet/manifests $ cat /tmp/cookbook 
Oh freddled gruntbuggly, thanks for all the fish.
```

Das Bearbeiten von Dateien mit file_line funktioniert gut, wenn die Datei unstrukturiert ist. Strukturierte Dateien können ähnliche Zeilen in verschiedenen Abschnitten haben, die unterschiedliche Bedeutungen haben. Im nächsten Abschnitt zeigen wir Ihnen, wie Sie mit einer bestimmten strukturierten Datei umgehen können, eine Datei mit INI-Syntax.

