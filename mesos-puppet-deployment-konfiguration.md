Dieser Teil wird in erster Linie abdecken, wie man einen Mesos-Cluster mit dem Puppet-Konfigurationsmanagement-Tool mit den ZooKeeper- und Mesos-Modulen in den folgenden Repositories einsetzen kann:

* https://github.com/deric/puppet-mesos
* https://github.com/deric/puppet-zookeeper

Puppet ist ein Open-Source-Konfigurationsmanagement-Tool, das auf Windows, Linux und Mac OS läuft. Puppet Labs wurde von Luke Kanies gegründet, der 2005 die Puppe produzierte. Es ist in Ruby geschrieben und als freie Software unter der GNU General Public License (GPL) bis Version 2.7.0 und Apache License 2.0 veröffentlicht. Damit können Systemadministratoren die Standardaufgaben automatisieren, die sie regelmäßig ausführen müssen. Weitere Informationen über Puppet finden Sie unter folgender Adresse:

* https://puppetlabs.com/puppet/puppet-open-source

Der Code wird mit dem Profil- und Rollenmuster organisiert und die Knotendaten werden mit Hiera gespeichert. Hiera ist ein Puppet-Tool, um eine Schlüssel / Wert-Suche der Konfigurationsdaten durchzuführen. Es erlaubt eine hierarchische Konfiguration von Daten in Puppet, die mit nativem Puppencode schwer zu erreichen ist. Außerdem wirkt es als Trennzeichen von Konfigurationsdaten und Code.

Am Ende dieses Moduls haben Sie einen hochverfügbaren Mesos-Cluster mit drei Meistern und drei Slaves. Daneben werden Marathon und Chronos auch in gleicher Weise eingesetzt.

Wir können mehrere Puppet-Module kombinieren, um Mesos und ZooKeeper zu verwalten. Führen wir die folgenden Schritte aus:

1. Erstellen Sie zunächst eine Puppetfile mit folgendem Inhalt:
```
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

2. Erstellen Sie für die Master die folgende Rolle:
```
class role::mesos::master {
  include profile::zookeeper
  include profile::mesos::master

  # Mesos frameworks
  include profile::mesos::master::chronos
  include profile::mesos::master::marathon
}
```

3. Als nächstes erstellen Sie die folgende Rolle für die Slaves:
```
class role::mesos::slave {
  include profile::mesos::slave
}
```



* [packethub](https://www.packtpub.com/mapt/book/big_data_and_business_intelligence/9781785886249/5/ch05lvl1sec48/deploying-and-configuring-mesos-cluster-using-puppet)