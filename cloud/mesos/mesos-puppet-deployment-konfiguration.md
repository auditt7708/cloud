---
title: mesos-puppet-deployment-konfiguration
description: 
published: true
date: 2021-06-09T15:38:59.264Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:38:54.100Z
---

# Mesos Deployment mit Puppet

Dieser Teil wird in erster Linie abdecken, wie man einen Mesos-Cluster mit dem Puppet-Konfigurationsmanagement-Tool mit den ZooKeeper- und Mesos-Modulen in den folgenden Repositories einsetzen kann:

* [Pupppet Mesos](https://github.com/deric/puppet-mesos)

* [Puppet ZooKeeper](https://github.com/deric/puppet-zookeeper)

Puppet ist ein Open-Source-Konfigurationsmanagement-Tool, das auf Windows, Linux und Mac OS läuft. Puppet Labs wurde von Luke Kanies gegründet, der 2005 die Puppe produzierte. Es ist in Ruby geschrieben und als freie Software unter der GNU General Public License (GPL) bis Version 2.7.0 und Apache License 2.0 veröffentlicht. Damit können Systemadministratoren die Standardaufgaben automatisieren, die sie regelmäßig ausführen müssen. Weitere Informationen über Puppet finden Sie unter folgender Adresse:

* [Puppet Open Source](https://puppetlabs.com/puppet/puppet-open-source)

Der Code wird mit dem Profil- und Rollenmuster organisiert und die Knotendaten werden mit Hiera gespeichert.
Hiera ist ein Puppet-Tool, um eine Schlüssel / Wert-Suche der Konfigurationsdaten durchzuführen.
Es erlaubt eine hierarchische Konfiguration von Daten in Puppet, die mit nativem Puppencode schwer zu erreichen ist.
Außerdem wirkt es als Trennzeichen von Konfigurationsdaten und Code.

Am Ende dieses Moduls haben Sie einen hochverfügbaren Mesos-Cluster mit drei Meistern und drei Slaves.
Daneben werden Marathon und Chronos auch in gleicher Weise eingesetzt.

Wir können mehrere Puppet-Module kombinieren, um Mesos und ZooKeeper zu verwalten. Führen wir die folgenden Schritte aus:

1.Erstellen Sie zunächst eine Puppetfile mit folgendem Inhalt:

```sh
forge 'http://forge.puppetlabs.com'
mod 'apt',
  :git => 'git://github.com/puppetlabs/puppetlabs-apt.git', :ref => '1.7.0'

mod 'concat',
  :git => 'https://github.com/puppetlabs/puppetlabs-concat', :ref => '1.1.2'

mod 'datacat',
  :git => 'https://github.com/richardc/puppet-datacat', :ref => '0.6.1'

mod 'java',
  :git => 'https://github.com/puppetlabs/puppetlabs-java', :ref => '1.2.0'

mod 'mesos',
  :git => 'https://github.com/deric/puppet-mesos', :ref => 'v0.5.2'

mod 'stdlib',
  :git => 'https://github.com/puppetlabs/puppetlabs-stdlib', :ref => '4.5.1'

mod 'zookeeper',
  :git => 'https://github.com/deric/puppet-zookeeper', :ref => 'v0.3.5'
```

Jetzt können wir die Profile und Rollen Muster für beide Mesos Meister und Sklaven schreiben. Auf den Master-Maschinen wird es auch die Verwaltung von ZooKeeper, Marathon und Chronos beinhalten.

2.Erstellen Sie für die Master die folgende Rolle:

```ruby
class role::mesos::master {
  include profile::zookeeper
  include profile::mesos::master

  # Mesos frameworks
  include profile::mesos::master::chronos
  include profile::mesos::master::marathon
}
```

3.Als nächstes erstellen Sie die folgende Rolle für die Slaves:

```ruby
class role::mesos::slave {
  include profile::mesos::slave
}
```

4.Erstellen Sie das folgende Profil für ZooKeeper:

```ruby
class profile::zookeeper {
  include ::java
  class { '::zookeeper':
    require => Class['java'],
  }
}
```

5.Erstellen Sie das folgende Profil für Mesos-Meister:

```ruby
class profile::mesos::master {
  class { '::mesos':
    repo => 'mesosphere',
  }

  class { '::mesos::master':
    env_var => {
      'MESOS_LOG_DIR' => '/var/log/mesos',
    },
    require => Class['profile::zookeeper'],
  }
}
```

6.Als nächstes erstellen Sie das folgende Profil für Mesos-Slaves:

```ruby
class profile::mesos::slave {
  class { '::mesos':
    repo => 'mesosphere',
  }
  class { '::mesos::slave':
    env_var => {
      'MESOS_LOG_DIR' => '/var/log/mesos',
    },
  }
}
```

Dies sind die grundlegenden Dinge, die wir brauchen, um einen Mesos-Cluster zu starten. Um Chronos und Marathon zu verwalten, müssen auch die folgenden Profile aufgenommen werden.

7.Erstellen Sie ein Profil für Chronos, wie folgt:

```ruby
class profile::mesos::master::chronos {
  package { 'chronos':
    ensure  => '2.3.2-0.1.20150207000917.debian77',
    require => Class['profile::mesos::master'],
  }

  service { 'chronos':
    ensure  => running,
    enable  => true,
    require => Package['chronos'],
  }
}
```

8.Erstellen Sie nun ein Profil für Marathon über den folgenden Code:

```ruby
class profile::mesos::master::marathon {
  package { 'marathon':
    ensure  => '0.7.6-1.0',
    require => Class['profile::mesos::master'],
  }

  service { 'marathon':
    ensure  => running,
    enable  => true,
    require => Package['marathon'],
  }
}

```

Bisher enthalten die Rollen und Profile keine Informationen über die Maschinen, die wir für die Einrichtung des Clusters verwenden werden. Diese Informationen werden mit Hiera kommen. Die Hiera-Daten für den Master würden etwas ähnliches aussehen:

```ruby
---
classes:
  - role::mesos::master

mesos::master::options:
  quorum: '2'
mesos::zookeeper: 'zk://master1:2181,master2:2181,master3:2181/mesos'
zookeeper::id: 1
zookeeper::servers: ['master1:2888:3888', 'master2:2888:3888', 'master3:2888:3888']
```

Bei der Einrichtung eines hochverfügbaren Clusters werden die Master-Rechner Master 1, Master 2 bzw. Master 3 genannt.

9.Hiera-Daten für Slave würde etwas ähnliches wie folgt aussehen:

```ruby
---
classes:
  - role::mesos::slave

mesos::slave::checkpoint: true
mesos::zookeeper: 'zk://master1:2181,master2:2181,master3:2181/mesos'
```

Jetzt können wir einen Puppenlauf auf jedem der Maschinen einrichten, um Mesos, ZooKeeper, Chronos und Marathon zu installieren und zu konfigurieren.

Die Installation des Moduls ist wie bei jedem Puppet-Modul wie folgt:

`$ puppet module install deric-mesos`

Nach erfolgreicher Ausführung können wir erwarten, dass das Mesos Paket installiert wird und der `mesos-master` Service im Cluster konfiguriert wird.