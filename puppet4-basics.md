# Benutzen der Puppet community version

Orginal Qelle zum Thema [style_guide](http://docs.puppetlabs.com/guides/style_guide.html)

Wie wird es nun umgesetzt...

In diesem Kapitel werde ich mit einigen wichtigen Beispielen wie dein Code style compliant wird.


# Vertiefung

Stell sicher, das du in deiner manifests Datei nur zwei Leerzeichen benutzt  (keine tabs), wie folgt:

```
service {'httpd':
  ensure  => running,
}
```

* [False](../puppet4-basics-false)
* [Qouting](../puppet4-basics-qouting)
* [Variablen](../puppet4-basics-variablen)
* [Parameter](../puppet4-basics-parameter)
* [Symlinks](../puppet4-basics-symlinks)
* [manifests Erstellen](../puppet4-basics-manitests)
* [Überprüfen deiner manifests mit Puppet-lint](../puppet4-basics-lint)
* [Puppet4 Module erstellen](puppet4-basics-modules)
* [Puppet4 Standard zur Benennung einhalten](../puppet4-standart-bezeichnung)
* [Puppet4 Einsetzen von Templates](../puppet4-templates)
* [Puppet4 irritieren über mehrere Items](../puppet4-basics-irritieren-multi-items)
* [Puppet4 IF anweisung einsetzen](../puppet4-if)
* [Puppet4 Reguläre Ausdrücke in IF Anweisungen einsetzen](../puppet4-if-regex)
* [Puppet4 Verwenden von Selektoren und Case-Anweisungen](../puppet-selektoren-case)
* [Puppet4 den in Operator verwenden](../puppet4-basics-in-operator)
* [Puppet4 Verwenden von regulären Ausdrucksersetzungen](../puppet4-basics-regex-substitutions)
* [Puppet4 Arbeiten mit dem future Parser](../puppet4-basics-future-parser)
