---
title: puppet4-basics
description: 
published: true
date: 2021-06-09T15:57:00.060Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:56:54.834Z
---

# Benutzen der Puppet community version

Orginal Qelle zum Thema [style_guide](htt../puppet//docs.puppetlabs.c../puppet/guid../puppet/style_guide.html)

Wie wird es nun umgesetzt...

In diesem Kapitel werde ich mit einigen wichtigen Beispielen wie dein Code style compliant wird.


# Vertiefung

Stell sicher, das du in deiner manifests Datei nur zwei Leerzeichen benutzt  (keine tabs), wie folgt:

```
service {'httpd':
  ensure  => running,
}
```

* [False](../puppet/puppet4-basics-false)
* [Qouting](../puppet/puppet4-basics-qouting)
* [Variablen](../puppet/puppet4-basics-variablen)
* [Parameter](../puppet/puppet4-basics-parameter)
* [Symlinks](../puppet/puppet4-basics-symlinks)
* [manifests Erstellen](../puppet/puppet4-basics-manitests)
* [Überprüfen deiner manifests mit Puppet-lint](../puppet/puppet4-basics-lint)
* [Puppet4 Module erstellen](puppet4-basics-modules)
* [Puppet4 Standard zur Benennung einhalten](../puppet/puppet4-standart-bezeichnung)
* [Puppet4 Einsetzen von Templates](../puppet/puppet4-templates)
* [Puppet4 irritieren über mehrere Items](../puppet/puppet4-basics-irritieren-multi-items)
* [Puppet4 IF anweisung einsetzen](../puppet/puppet4-if)
* [Puppet4 Reguläre Ausdrücke in IF Anweisungen einsetzen](../puppet/puppet4-if-regex)
* [Puppet4 Verwenden von Selektoren und Case-Anweisungen](../puppet/puppet-selektoren-case)
* [Puppet4 den in Operator verwenden](../puppet/puppet4-basics-in-operator)
* [Puppet4 Verwenden von regulären Ausdrucksersetzungen](../puppet/puppet4-basics-regex-substitutions)
* [Puppet4 Arbeiten mit dem future Parser](../puppet/puppet4-basics-future-parser)
