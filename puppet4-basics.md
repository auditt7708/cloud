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
