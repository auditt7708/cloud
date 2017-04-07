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

