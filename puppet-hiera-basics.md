Hiera ist ein Informations-Repository für Puppet. 
Mit Hiera können Sie eine hierarchische Kategorisierung von Daten über Ihre Knoten, die außerhalb Ihrer Manifeste beibehalten wird, haben. 
Dies ist sehr nützlich für den Austausch von Code und deployments .

### Fertig werden

Hiera sollte bereits als Abhängigkeit von deinem Puppet Master installiert worden sein. Wenn es noch nicht ist, installieren Sie es mit Puppet:

```
root@puppet:~# puppet resource package hiera ensure=installed
package { 'hiera':
  ensure => '1.3.4-1puppetlabs1',
}

```
Wie es geht...

1. Hiera wird aus einer yaml Datei, `/etc/puppet/hiera.yaml` konfiguriert. Erstellen Sie die Datei und fügen Sie die folgenden Code als eine minimale Konfiguration hinzu:

```
---
:hierarchy:
  - common
:backends:
  - yaml
:yaml:
  :datadir: '/etc/puppet/hieradata'
```

2. Erstellen Sie die Datei `common.yaml`, die in der Hierarchie referenziert wird:


```
root@puppet:/etc/puppet# mkdir hieradata
root@puppet:/etc/puppet# vim hieradata/common.yaml
---
message: 'Default Message'
```

3. Bearbeiten Sie die Datei `site.pp` und fügen Sie eine Benachrichtigungsressource hinzu, die auf dem Hiera Wert basiert:


```
node default {
  $message = hiera('message','unknown')
  notify {"Message is $message":}
}

```

4. Wenden Sie das Manifest auf einen Test Node an:

```
t@ckbk:~$ sudo puppet agent -t
Info: Retrieving pluginfacts
Info: Retrieving plugin
...
Info: Caching catalog for cookbook-test
Info: Applying configuration version '1410504848'
Notice: Message is Default Message
Notice: /Stage[main]/Main/Node[default]/Notify[Message is Default Message]/message: defined 'message' as 'Message is Default Message'
Notice: Finished catalog run in 0.06 seconds
```

#### Wie es funktioniert...

Hiera verwendet eine Hierarchie, um durch einen Satz von Yaml-Dateien zu suchen, um die entsprechenden Werte zu finden. Wir haben diese Hierarchie in `hiera.yaml` mit dem einzigen Eintrag für `common.yaml` definiert. 
Wir haben die `hiera` Funktion in `site.pp` verwendet, um den Wert für die Nachricht zu verfolgen und diesen Wert in der Variablen `$message` zu speichern. 
Die für die Definition der Hierarchie verwendeten Werte können beliebige Fakten sein, die über das System definiert sind. Eine gemeinsame Hierarchie wird dargestellt als_:

```
:hierarchy:
  - hosts/%{hostname}
  - os/%{operatingsystem}
  - network/%{network_eth0}
  - common
```

### Es gibt mehr...

Hiera kann für die automatische Parametrierung mit parametrisierten Klassen verwendet werden. Zum Beispiel, wenn Sie eine Klasse namens `cookbook::example` mit einem Parameter namens `publisher` haben, können Sie die folgenden in einer Hiera yaml Datei, um automatisch diesen Parameter:

`cookbook::example::publisher: 'PacktPub'`

Eine andere häufig verwendete fact ist die `environment`, die Sie auf die `environment` des Client Nodes unter Verwendung von `%{environment}` verweisen können, wie in der folgenden Hierarchie gezeigt:

```
:hierarchy:
hosts/%{hostname}
os/%{operatingsystem}
environment/%{environment}
common
```

### Tip
Eine gute Faustregel ist, die Hierarchie auf 8 Ebenen oder weniger zu begrenzen. Denken Sie daran, dass jedes Mal, wenn ein Parameter mit Hiera durchsucht wird, alle Ebenen durchsucht werden, bis eine Übereinstimmung gefunden wird.



Die Standard-Hiera-Funktion gibt die erste Übereinstimmung an den Suchschlüssel zurück, Sie können auch `hiera_array` und `hiera_hash` verwenden, um alle in Hiera gespeicherten Werte zu durchsuchen und zurückzugeben.

Hiera kann auch von der Befehlszeile aus wie in der folgenden Befehlszeile angezeigt werden (beachten Sie, dass derzeit die Kommandozeile Hiera Dienstprogramm verwendet `/etc/hiera.yaml` als Konfigurationsdatei, während der Puppet Master verwendet `/etc/puppet/hiera.yaml`) Aufrechtzuerhalten.

```
root@puppet:/etc/puppet# rm /etc/hiera.yaml 
root@puppet:/etc/puppet# ln -s /etc/puppet/hiera.yaml /etc/
root@puppet:/etc/puppet# hiera message
Default Message
```

Für weitere informationen [Puppet Hira](https://docs.puppetlabs.com/hiera/1/)