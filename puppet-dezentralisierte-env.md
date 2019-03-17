# Puppet für fortgeschrittene: dezentralews environment

Puppet ist ein Konfigurationsmanagement-Tool. Sie können die Puppe verwenden, um Konfigurations und deren änderung in einer großen Anzahl von Clientcomputern zu konfigurieren und zu verhindern.
Wenn alle Ihre Client-Computer über einen zentralen Standort leicht erreichbar sind, können Sie sich entscheiden, einen zentralen Puppet Server zu haben, der alle Client-Computer steuert.
Im zentralen Modell wird der Puppet Server Puppet Master genannt.
Wir werden sehen, wie man einen zentralen Puppent Master in wenigen Abschnitten konfiguriert.

Wenn Ihre Clientcomputer weit verteilt sind oder Sie keine Kommunikation zwischen den Clientcomputern und einem zentralen Standort garantieren können, dann kann eine dezentrale Architektur für Ihre Bereitstellung gut geeignet sein.
In den nächsten Abschnitten werden wir sehen, wie man eine dezentrale Puppenarchitektur konfiguriert.

Wie wir gesehen haben, können wir den Puppenbefehl direkt auf eine manifests datei ausführen, um die puppet anzuwenden. Das Problem bei dieser Anordnung ist, dass wir die manifestes auf die Clientcomputer übertragen müssen.

Wir können das Git-Repository verwenden, das wir im vorherigen Abschnitt erstellt haben, um unsere manifests auf jeden neuen Knoten zu übertragen, den wir erstellen.

## Fertig werden

Erstellen Sie einen neuen Test Node, verbinden Sie sich diesen neuen Node, ich benutze `testnode` für dieses Beispiel.
Installiere pupppet auf der Maschine, wie wir es bisher gemacht haben.

## Wie es geht

Erstellen Sie ein `bootstrap.pp` Manifest, das die folgenden Konfigurationsschritte auf unserem neuen Knoten ausführt:

1.Install Git:

```ruby
package {'git':
  ensure => 'installed'
}
```

2.Installiere die `ssh` schlüssel, um auf `git.example.com` im Home-Verzeichnis des Puppet-Benutzers zuzugreifen (/var/lib/puppet/.ssh/id_rsa):

```ruby
File {
  owner => 'puppet',
  group => 'puppet',
}
file {'/var/lib/puppet/.ssh':
  ensure => 'directory',
}
file {'/var/lib/puppet/.ssh/id_rsa':
  content => "
-----BEGIN RSA PRIVATE KEY-----
…
NIjTXmZUlOKefh4MBilqUU3KQG8GBHjzYl2TkFVGLNYGNA0U8VG8SUJq
-----END RSA PRIVATE KEY-----
",
  mode    => 0600,
  require => File['/var/lib/puppet/.ssh']
}
```

3.Laden Sie den `ssh` Host-Schlüssel von `git.example.com` (`/var/lib/puppet/.ssh/known_hosts`):

```ruby
exec {'download git.example.com host key':
  command => 'sudo -u puppet ssh-keyscan git.example.com >> /var/lib/puppet/.ssh/known_hosts',
  path    => '/usr/bin:/usr/sbin:/bin:/sbin',
  unless  => 'grep git.example.com /var/lib/puppet/.ssh/known_hosts',
  require => File['/var/lib/puppet/.ssh'],
}
```

4.Erstellen Sie ein Verzeichnis, das das Git-Repository enthält (`/etc/puppet/cookbook`):

```ruby
file {'/etc/puppet/cookbook':
  ensure => 'directory',
}
```

5.Klonen Sie das Puppen-Repository auf die neue Maschine:

```ruby
exec {'create cookbook':
  command => 'sudo -u puppet git clone git@git.example.com:repos/puppet.git /etc/puppet/cookbook',
  path    => '/usr/bin:/usr/sbin:/bin:/sbin',
  require => [Package['git'],File['/var/lib/puppet/.ssh/id_rsa'],Exec['download git.example.com host key']],
  unless  => 'test -f /etc/puppet/cookbook/.git/config',
}
```

6.Jetzt, wenn wir puppet run auf der neuen Maschine anwenden, wirden die `ssh` Schlüssel für den Puppet-Benutzer installiert.
Der Puppet-User wird dann das Git-Repository in `/etc/puppet/cookbook` klonen:

```s
root@testnode /tmp# puppet apply bootstrap.pp
Notice: Compiled catalog for testnode.example.com in environment production in 0.40 seconds
Notice: /Stage[main]/Main/File[/etc/puppet/cookbook]/ensure: created
Notice: /Stage[main]/Main/File[/var/lib/puppet/.ssh]/ensure: created
Notice: /Stage[main]/Main/Exec[download git.example.com host key]/returns: executed successfully
Notice: /Stage[main]/Main/File[/var/lib/puppet/.ssh/id_rsa]/ensure: defined content as '{md5}da61ce6ccc79bc6937bd98c798bc9fd3'
Notice: /Stage[main]/Main/Exec[create cookbook]/returns: executed successfully
Notice: Finished catalog run in 0.82 seconds
```

### Hinweis

Möglicherweise müssen Sie die `tty` Anforderung von `sudo` deaktivieren.
Kommentieren Sie die Zeile `Defaults requiretty` bei `/etc/sudoers`, wenn Sie diese Zeile haben.

Alternativ können Sie `user => Puppet` innerhalb des `'make cookbook' exec` types setzen.
Achten Sie darauf, dass mit dem Benutzerattribut alle Fehlermeldungen aus dem Befehl verloren gehen.

7.Nun, da Ihr Puppet Code auf dem neuen Node verfügbar ist, können Sie ihn mit puppet apply, indem Sie angeben, dass `/etc/puppet/cookbook/modules` die Module enthalten:

```s
root@testnode ~# puppet apply --modulepath=/etc/puppet/cookbook/modules /etc/puppet/cookbook/manifests/site.pp
Notice: Compiled catalog for testnode.example.com in environment production in 0.12 seconds
Notice: /Stage[main]/Base/File[/etc/motd]/content: content changed '{md5}86d28ff83a8d49d349ba56b5c64b79ee' to '{md5}4c4c3ab7591d940318279d78b9c51d4f'
Notice: Finished catalog run in 0.11 seconds
root@testnode /tmp# cat /etc/motd
testnode.example.com
Managed by puppet 3.6.2

```

## Wie es funktioniert

Zuerst sorgt unser `bootstrap.pp` Manifest dafür, dass Git installiert ist.
Das Manifest fährt dann fort, um sicherzustellen, dass die `ssh` Schlüssel für den Git-Benutzer auf git.example.com im Heimatverzeichnis des Puppet-Benutzers (`/var/lib/puppet` standardmäßig) installiert ist.
Das Manifest stellt dann sicher, dass der Host-Schlüssel für `git.example.com` vom Puppet-Benutzer vertraut wird.
Bei ssh konfiguriert sorgt der Bootstrap dafür, dass `/etc/puppet/cookbook` existiert und ein Verzeichnis ist.

Wir verwenden dann einen exec, um Git das Repository in `/etc/puppet/cookbook` zu klonen. Mit all dem Code an Ort und Stelle, dann rufen wir Puppe bewerben eine letzte Zeit, um den Code aus dem Repository zu implementieren. In einer Produktionseinstellung verteilen Sie das bootstrap.pp manifest auf alle Ihre Knoten, möglicherweise über einen internen Webserver, mit einer Methode ähnlich wie `curl http://puppet/bootstrap.pp> bootstrap.pp && puppet apply bootstrap.pp`

## Es gibt mehr

Nun, da Sie ein zentrales Git-Repository für Ihre Puppet Manifeste haben, können Sie mehrere Kopien davon an verschiedenen Orten ausprobieren und an ihnen arbeiten, bevor Sie Ihre Änderungen begehen. Zum Beispiel, wenn Sie in einem Team arbeiten, kann jedes Mitglied seine eigene lokale Kopie des Repo und synchronisieren Änderungen mit den anderen über den zentralen Server. Sie können auch GitHub als Ihren zentralen Git-Repository-Server verwenden. GitHub bietet kostenlose Git-Repository-Hosting für öffentliche Repositories, und Sie können für GitHub's Premium-Service bezahlen, wenn Sie nicht möchten, dass Ihr Puppet-Code öffentlich zugänglich ist.

Im nächsten Abschnitt werden wir unser Git-Repository sowohl für zentrale als auch dezentrale Puppen-Konfigurationen nutzen.