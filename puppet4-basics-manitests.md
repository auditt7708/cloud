Wenn du schon einen Puppencode hast (bekannt als Puppet manifest), kannst du diesen Abschnitt überspringen und weiter zum nächsten gehen. 
Wenn nicht, werden wir sehen, wie man ein einfaches Manifest erstellt und anwendet.

Wenn nicht schon Puppet Installiert ist, hier werde ich nachfolgend basierend auf der  [Puppet 4 Gem Installation](../puppet4-gem-install) .
Es sollte aber auch jede andere Puppet Installation gehen wenn es sich um Puppet handelt
Hier ein Listing für ihre Linux Distribution 

* [Puppet 4 Installation mit Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-puppet-4-on-ubuntu-16-04)
* [Puppet 4 Installation mit Debian 8]()
* [Puppet 4 Installation mit CentOS 7](http://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-install-puppet-4-x-on-centos-7-rhel-7.html)
* [Puppet 4 PuppetDB Installation ](https://docs.puppet.com/puppetdb/4.4/install_via_module.html)
* [Puppet 4 Agent Installation ](https://docs.puppet.com/puppet/4.9/install_linux.html)
* [Puppet 4 Server Installation  ](https://docs.puppet.com/puppetserver/2.7/install_from_packages.html)

Nach erfolgreicher Installation kann man im Home Verzeichnis des Benutzer mit 

`mkdir -p .puppet/manifests`

das Erster Verzeichnis erstellen den ersten Code für Puppet.

Mit `cd .puppet/manifests` wechsen wir ins Verzeichnis und erstellen dort die Datei `site.pp` mit folgendem Inhalt.
```
  node default {
    file { '/tmp/hello':
      content => "Hello, world!\n",
    }
  }
```

Testen Sie Ihr Manifest mit dem Befehl `puppet apply`. 
Dies wird Puppet anweisen, das Manifest zu lesen, es mit dem Zustand der Maschine zu vergleichen und notwendige Änderungen an diesem Zustand vorzunehmen:
```
~/.puppet/manifests$ puppet apply site.pp
Notice: Compiled catalog for cookbook in environment production in 0.14 seconds
Notice: /Stage[main]/Main/Node[default]/File[/tmp/hello]/ensure: defined content as '{md5}7463444435575e17c4431bbcb00c0898b'
Notice: Finished catalog run in 0.04 seconds
```

Um zu sehen, ob Puppet tut was wir erwartet haben (erstellen Sie die Datei `/tmp/hallo` mit dem `Hallo, Welt!` Inhalt), führen Sie den folgenden Befehl aus:
```
#~/puppet/manifests$ cat /tmp/hello
Hello, world!
#~/puppet/manifests$

```