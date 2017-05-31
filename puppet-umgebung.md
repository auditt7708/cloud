Umgebungen in Puppet sind Verzeichnisse, die verschiedene Versionen Ihrer Puppet manifests halten. 
Umgebungen vor der Puppet Version 3.6 waren keine Standardkonfiguration für Puppet. 
In neueren Versionen von Puppet sind Umgebungen standardmäßig konfiguriert.

Immer wenn ein Nodes eine Verbindung zu einem Puppet Server (Alt. Master) herstellt, informiert er den Puppet Server seiner Umgebung. Standardmäßig berichten alle Nodes an die Umgebung `production`. 
Dies führt dazu, dass der Puppet Server in die Produktionsumgebung in die manifests Datei schaut. 
Sie können eine alternative Umgebung mit dem Parameter `--environment` angeben, wenn Sie den Puppet agenten ausführen oder indem Sie die Umgebung `= newenvironment` in `/etc/puppet/puppet.conf` im Abschnitt `[agent]` einstellen.

### Fertig werden

Setzen Sie die `enviromnent` Funktion Ihrer Installation, indem Sie eine Zeile zum Abschnitt `[main]` von `/etc/puppet/puppet.conf` wie folgt hinzufügen:

```
[main]
...
environmentpath=/etc/puppet/environments
```

Wie es geht...

Die Schritte sind wie folgt:

1. Erstellen Sie ein Produktionsverzeichnis unter `/etc/puppet/environments`, das sowohl ein Modul als auch ein manifests Verzeichnis enthält. 
Dann erstellen Sie eine `site.pp`, die eine Datei in `/tmp` wie folgt erstellt:
```
root@puppet:~# cd /etc/puppet/environments/
root@puppet:/etc/puppet/environments# mkdir -p production/{manifests,modules}
root@puppet:/etc/puppet/environments# vim production/manifests/site.pp
node default {
  file {'/tmp/production':
    content => "Hello World!\nThis is production\n",
  }
}
```

2. Führen Sie den  Puppent Agent auf dem Master aus , um es zu verbinden und zu überprüfen, dass der code Produktion geliefert wurde:
```
root@puppet:~# puppet agent -vt
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for puppet
Info: Applying configuration version '1410415538'
Notice: /Stage[main]/Main/Node[default]/File[/tmp/production]/ensure: defined content as '{md5}f7ad9261670b9da33a67a5126933044c'
Notice: Finished catalog run in 0.04 seconds
# cat /tmp/production
Hello World!
This is production
```

3. Konfiguriere eine andere Umgebung `devel`. Einrichten ein neues manifests für die `devel` Umgebung :
```
root@puppet:/etc/puppet/environments# mkdir -p devel/{manifests,modules}
root@puppet:/etc/puppet/environments# vim devel/manifests/site.pp
node default {
  file {'/tmp/devel':
    content => "Good-bye! Development\n",
  }
}
```

4. Wenden Sie die neue Umgebung an, indem Sie den Parameter `--environment devel ` mit dem Puppen-Agent mit folgendem Befehl ausführen:
```root@puppet:/etc/puppet/environments# puppet agent -vt --environment devel
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for puppet
Info: Applying configuration version '1410415890'
Notice: /Stage[main]/Main/Node[default]/File[/tmp/devel]/ensure: defined content as '{md5}b6313bb89bc1b7d97eae5aa94588eb68'
Notice: Finished catalog run in 0.04 seconds
root@puppet:/etc/puppet/environments# cat /tmp/devel
Good-bye! Development

```


### Tip
Wenn Sie Apache2 neu starten müssen, um Ihre neue Umgebung zu aktivieren, hängt dies von Ihrer Version von Puppet ab  und dem Parameter `environment_timeout` von der  'puppet.conf`.

Es gibt mehr...

Jede Umgebung kann einen eigenen Modulpfad haben, wenn Sie eine `environment.conf` Datei im Umgebungsverzeichnis erstellen. 
Weitere Informationen zu Umgebungen finden Sie auf der Website der Puppet Labs unter https://docs.puppetlabs.com/puppet/latest/reference/environments.html.

