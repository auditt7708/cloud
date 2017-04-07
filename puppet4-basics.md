# Benutzen der Puppet community version

Orginal Qelle zum Thema [style_guide](http://docs.puppetlabs.com/guides/style_guide.html)

Wie wird es nun umgesetzt...

In diesem Kapitel werde ich mit einigen wichtigen Beispielen wie dein Code style compliant wird.


Vertiefung

Stell sicher, das du in deiner manifests Datei nur zwei Leerzeichen benutzt  (keine tabs), wie folgt:

```
service {'httpd':
  ensure  => running,
}
```

# Quoting

Stelle sicher das du immer folgendes Quouting deiner resource names benutzt: 

```
package { 'exim4'
```

und nicht

```
package { exim4:
```

Der String enthält variable Referenzen wie: `"${::fqdn}"`
Der String enthält Zeichen-Escape-Sequenzen wie: `"\n"`

Betrachten Sie den folgenden Code:
```
file { '/etc/motd':
  content => "Welcome to ${::fqdn}\n"
}
```

Hier wurde beides kombiniert der `fqdn` teil ist der Bezeichner das Dollerzeichen sagt aus , dass es sich um eine Variable handelt.

Die Deppelten Doppelpunke sorgen dafür, dass Puppet die variablen refarens sowie die escape sequens auch umsetzt Puppet würde andernfalls es Ignorieren oder einen Fehler melden.

Alle nicht parameter werte die nicht einem Reservierten Word bei Puppet entsprechen müssen in einfache Ausrufungszeichen geschrieben werden.

Zum Beispiel mit nicht Resavierten Wörtern
```
name => 'Max Mustermann',
mode => '0700',
owner => 'deploy',

```

Hier noch ein Beispiel mit Resavierten Wörtern:
```
ensure => installed,
enable => true,
ensure => running,
```

# False
Es gibt nur eine Sache in Puppet den wert False hat nähmlich `false` ohne irgendwelche weiteren Zeichen.
Aus `"false"` machet Puppet `true`.
Und aus `"true"` macht Puppet `true`.

Hier ein beispiel :
```
if "false" {
  notify { 'True': }
}
if 'false' {
  notify { 'Also true': }
}
if false {
  notify { 'Not true': }
}
```

Wenn dieser Code durch Puppe ausgeführt wird, werden die ersten beiden Meldungen ausgelöst. 
Die endgültige Benachrichtigung wird nicht ausgelöst; Es ist die einzige, die falsch auswertet, da `notify` nur bei einem positivem Ergebnis auslöst wird .

# Variablen
Variablen müssen immer in geschweiften klammern sein z.b. '${PHP7ENV}.conf'

Beispiel für eine Server Quelle : 

```
source => "puppet:///modules/webserver/${brand}.conf",
```

Puppet`s Parser muss immer unterscheiden können was ein charachter ist und was ein teil einer Variablen ist die geschweiften klammern machen es für den Parser eindeutig

# Parameter
Jede Zeile bei der defenierung der Parameter sollte mit einen Komma enden. 

Beispiel : 
```
service { 'memcached':
  ensure => running,
  enable => true,
}
```

Es vereinfacht die Spätere Erweiterung der definieren der Parameter da die ja in der Praxis immer zahlreicher werden. 

Wenn Sie eine Ressource mit einem einzigen Parameter deklarieren, machen Sie die Deklaration alle auf einer Zeile und ohne komma, wie im folgenden Snippet gezeigt:

`package { 'puppet': ensure => installed }`

Gibt es mehr als einen Parameter dann gibt man  jedem Parameter seine eigene Zeile:

```
package { 'rake':
  ensure   => installed,
  provider => gem,
  require  => Package['rubygems'],
}
```

Um den Code einfacher lesbar zu machen, benutzen Sie die Parameterpfeile in Übereinstimmung mit dem längsten Parameter wie folgt ein:

```
file { "/var/www/${app}/shared/config/rvmrc":
  owner   => 'deploy',
  group   => 'deploy',
  content => template('rails/rvmrc.erb'),
  require => File["/var/www/${app}/shared/config"],
}
```

# Symlinks
Bei der Deklaration von Dateiressourcen, die Symlinks sind, verwenden Sie `ensure => link` und legen Sie das Zielattribut wie folgt fest:


```
file { '/etc/php5/cli/php.ini':
  ensure => link,
  target => '/etc/php.ini',
}
```

# manifest Erstellen

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

# Überprüfen deiner manifests mit Puppet-lint

