# Puppet für fortgeschrittene: ini Datein

INI-Dateien werden in vielen Systemen verwendet, Puppet verwendet INI-Syntax für die Datei puppet.conf.
Das `puppetlabs-inifile` Modul erstellt zwei Typen, `ini_setting` und `ini_subsetting`, mit denen INI-Style-Dateien editiert werden können.

## Fertig werden

Installiere das Modul wie folgt aus der Schmiede:

```s
t@mylaptop ~ $ puppet module install puppetlabs-inifile
Notice: Preparing to install into /home/tuphill/.puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/home/tuphill/.puppet/modules
└── puppetlabs-inifile (v1.1.3)
```

## Wie es geht

In diesem Beispiel erstellen wir eine Datei `/tmp/server.conf` und stellen sicher, dass die Einstellung `server_true` in dieser Datei gesetzt ist:

1.Erstellen Sie ein `initest.pp` manifest mit folgendem Inhalt:

```ruby
  ini_setting {'server_true':
    path    => '/tmp/server.conf',
    section => 'main',
    setting => 'server',
    value   => 'true',
  }
```

2.Wenden Sie das Manifest an:

```s
t@mylaptop ~/.puppet/manifests $ puppet apply initest.pp
Notice: Compiled catalog for burnaby in environment production in 0.14 seconds
Notice: /Stage[main]/Main/Ini_setting[server_true]/ensure: created
Notice: Finished catalog run in 0.02 seconds
```

3.Überprüfen Sie den Inhalt der Datei `/tmp/server.conf`:

```s
t@mylaptop ~/.puppet/manifests $ cat /tmp/server.conf

[main]
server = true
```

## Wie es funktioniert

Das `inifile` Modul definiert zwei Typen, `ini_setting` und `ini_subsetting`. Unser Manifest definiert eine `Ini_setting` Ressource, die eine server = true Einstellung im Hauptteil der `ini` Datei erzeugt. In unserem Fall war die Datei nicht vorhanden, so dass Puppet die Datei erstellt, dann den `main` abschnitt erstellt und schließlich die Einstellung zum `main` abschnitt hinzugefügt hat.

## Es gibt mehr

Mit `Ini_subsetting` können Sie mehrere Einstellungen zu einer Einstellung hinzufügen. Zum Beispiel hat unsere `server.conf` Datei eine Server-Zeile, wir könnten jeden Node einen eigenen Hostnamen an eine Server-Zeile anhängen.
Fügen Sie am Ende der Datei `initest.pp` Folgendes hinzu:

```ruby
  ini_subsetting {'server_name':
    path    => '/tmp/server.conf',
    section => 'main',
    setting => 'server_host',
    subsetting => "$hostname",
  }
```

wenden Sie das manifest an:

```s
t@mylaptop ~/.puppet/manifests $ puppet apply initest.pp
Notice: Compiled catalog for mylaptop in environment production in 0.34 seconds
Notice: /Stage[main]/Main/Ini_subsetting[server_name]/ensure: created
Notice: Finished catalog run in 0.02 seconds
t@mylaptop ~/.puppet/manifests $ cat /tmp/server.conf
[main]
server = true
server_host = mylaptop

```

Ändern Sie nun vorübergehend Ihren Hostnamen und wiederholen Sie die Ausführung von puppet:

```s
t@mylaptop ~/.puppet/manifests $ sudo hostname inihost
t@mylaptop ~/.puppet/manifests $ puppet apply initest.pp
Notice: Compiled catalog for inihost in environment production in 0.43 seconds
Notice: /Stage[main]/Main/Ini_subsetting[server_name]/ensure: created
Notice: Finished catalog run in 0.02 seconds
t@mylaptop ~/.puppet/manifests $ cat /tmp/server.conf
[main]
server = true
server_host = mylaptop inihost
```

### Tip

Bei der Arbeit mit INI-Syntax-Dateien, mit dem `inifile` Modul ist eine ausgezeichnete Wahl.

Wenn sich Ihre Konfigurationsdateien nicht in der INI-Syntax befinden, kann ein anderes Tool, Augeas, verwendet werden. Im folgenden Abschnitt verwenden wir `augeas`, um Dateien zu ändern.