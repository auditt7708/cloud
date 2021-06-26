---
title: puppet-fort-files-packages-3nd-repos
description: 
published: true
date: 2021-06-09T15:48:00.943Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:47:54.669Z
---

# Puppet für fortgeschrittene: 3nd Repositorys

Am häufigsten werden Sie , Pakete von der Hauptverteilung Repo installieren wollen, so dass es eine einfache Paket-Ressource wird:
`package { 'exim4': ensure => installed }`

Manchmal braucht man ein Paket, das nur in einem Drittanbieter-Repository gefunden wird (z. B. ein Ubuntu-PPA), oder es könnte sein, dass du eine neuere Version eines Pakets benötigst als das, was von der Distribution zur Verfügung steht ein so genanter Dritter anbieter.

Auf einer manuell verwalteten Maschine würden Sie dies normalerweise tun, indem Sie die Repo-Quell-Konfiguration zu `/etc/apt/sources.list.d` (und ggf. gpg-Schlüssel für das Repo) hinzufügen, bevor Sie das Paket installieren. Wir können diesen Prozess einfach mit der Puppet automatisieren.

## Wie es geht

In diesem Beispiel verwenden wir das beliebte Percona APT Repo (Percona ist ein MySQL Beratungsunternehmen, das ihre eigene, spezialisierte Version von MySQL pflegt und veröffentlicht, weitere Informationen finden Sie unter [percona](http://www.percona.com/software/repositories).

1.Erstellen Sie die Datei `module/admin/manifests/percona_repo.pp` mit folgendem Inhalt:

```ruby
# Install Percona APT repo
class admin::percona_repo {
  exec { 'add-percona-apt-key':
    unless  => '/usr/bin/apt-key list |grep percona',
    command => '/usr/bin/gpg --keyserver hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && /usr/bin/gpg -a --export CD2EFD2A | apt-key add -',
    notify  => Exec['percona-apt-update'],
  }

  exec { 'percona-apt-update':
    command     => '/usr/bin/apt-get update',
    require     => [File['/etc/apt/sources.list.d/percona.list'],
File['/etc/apt/preferences.d/00percona.pref']],
    refreshonly => true,
  }

  file { '/etc/apt/sources.list.d/percona.list':
    content => 'deb http://repo.percona.com/apt wheezy main',
    notify  => Exec['percona-apt-update'],
  }

  file { '/etc/apt/preferences.d/00percona.pref':
    content => "Package: *\nPin: release o=Percona
    Development Team\nPin-Priority: 1001",
    notify  => Exec['percona-apt-update'],
  }
}
```

2.Ändern Sie Ihre `site.pp` Datei wie folgt:

```ruby
node 'cookbook' {
  include admin::percona_repo

  package { 'percona-server-server-5.5':
    ensure  => installed,
    require => Class['admin::percona_repo'],
  }
}
```

3.Run Puppet:

```ruby
root@cookbook-deb:~# puppet agent -t
Info: Caching catalog for cookbook-deb
Notice: /Stage[main]/Admin::Percona_repo/Exec[add-percona-apt-key]/returns: executed successfully
Info: /Stage[main]/Admin::Percona_repo/Exec[add-percona-apt-key]: Scheduling refresh of Exec[percona-apt-update]
Notice: /Stage[main]/Admin::Percona_repo/File[/etc/apt/sources.list.d/percona.list]/ensure: defined content as '{md5}b8d479374497255804ffbf0a7bcdf6c2'
Info: /Stage[main]/Admin::Percona_repo/File[/etc/apt/sources.list.d/percona.list]: Scheduling refresh of Exec[percona-apt-update]
Notice: /Stage[main]/Admin::Percona_repo/File[/etc/apt/preferences.d/00percona.pref]/ensure: defined content as '{md5}1d8ca6c1e752308a9bd3018713e2d1ad'
Info: /Stage[main]/Admin::Percona_repo/File[/etc/apt/preferences.d/00percona.pref]: Scheduling refresh of Exec[percona-apt-update]
Notice: /Stage[main]/Admin::Percona_repo/Exec[percona-apt-update]: Triggered 'refresh' from 3 events

```

## Wie es funktioniert

Um jedes Percona-Paket zu installieren, müssen wir zunächst die Repository-Konfiguration auf dem Rechner installiert haben. Aus diesem Grund benötigt das `percona-server-server-5.5` Paket (Perconas Version des Standard-MySQL-Servers) die `admin::percona_repo` Klasse:

```ruby
package { 'percona-server-server-5.5':
  ensure  => installed,
  require => Class['admin::percona_repo'],
}
```

Also, was macht die `admin::percona_repo` Klasse? Es:

* Installiert die Percona APT schlüssel , mit der die Pakete signiert sind

* Konfiguriert die Percona repo URL als Datei in `/etc/apt/sources.list.d`

* Führt `apt-get update`, um die Repo-Metadaten abzurufen

* Fügt eine APT pin Konfiguration in `/etc/apt/preferences.d` hinzu

Zuerst installieren wir den APT-Schlüssel:

```ruby
exec { 'add-percona-apt-key':
  unless  => '/usr/bin/apt-key list |grep percona',
  command => '/usr/bin/gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && /usr/bin/gpg -a --export CD2EFD2A | apt-key add -',
  notify  => Exec['percona-apt-update'],
}
```

Wenn der `unless` Parameter die Ausgabe der `apt-key list` überprüft, um sicherzustellen, dass der Percona-Schlüssel noch nicht installiert ist, müssen wir in diesem Fall nichts tun. Angenommen, es ist nicht, der `command` läuft:

`/usr/bin/gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && /usr/bin/gpg -a --export CD2EFD2A | apt-key add -`

Dieser Befehl ruft den Schlüssel vom GnuPG-Keyserver ab, exportiert ihn im ASCII-Format und leitet diesen in den Befehl `apt-key add`, der ihn zum Systemschlüssel(system keyring) hinzufügt. Sie können ein ähnliches Muster für die meisten Drittanbieter-Repos verwenden, die einen APT-Signierungsschlüssel(signing key) erfordern.

Nachdem wir den Schlüssel installiert haben, fügen wir die Repokonfiguration hinzu:

```ruby
file { '/etc/apt/sources.list.d/percona.list':
  content => 'deb http://repo.percona.com/apt wheezy main',
  notify  => Exec['percona-apt-update'],
}
```

Führen Sie dann `apt-get update` aus, um den APT-Cache des Systems mit den Metadaten aus dem neuen Repo zu aktualisieren:

```ruby
exec { 'percona-apt-update':
  command     => '/usr/bin/apt-get update',
  require     => [File['/etc/apt/sources.list.d/percona.list'], File['/etc/apt/preferences.d/00percona.pref']],
  refreshonly => true,
}
```

Schließlich konfigurieren wir die APT-Pin-Priorität für das Repo:

```ruby
file { '/etc/apt/preferences.d/00percona.pref':
  content => "Package: *\nPin: release o=Percona Development Team\nPin-Priority: 1001",
  notify  => Exec['percona-apt-update'],
}
```

Dadurch wird sichergestellt, dass Pakete, die aus dem Percona Repo installiert sind, niemals von Paketen aus einem anderem Repository ersetzt werden (z.B die Haupt-Ubuntu-Distribution). Andernfalls könnten Sie mit defekten Abhängigkeiten enden und können die Percona-Pakete nicht automatisch installieren.

## Es gibt mehr

Das APT-Paket-Framework ist spezifisch für die Debian- und Ubuntu-Systeme. Es gibt ein forge Modul für die Verwaltung von [apt](https://forge.puppetlabs.com/puppetlabs/apt). Wenn Sie auf einem Red Hat- oder CentOS-basierten System sind, können Sie die `yumrepo` Ressourcen verwenden, um RPM-Repositories direkt zu verwalten:

* [yumrepo](Http://docs.puppetlabs.com/references/latest/type.html#yumrepo)