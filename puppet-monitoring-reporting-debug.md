Es kann sehr hilfreich sein, wenn Sie Probleme debuggen, wenn Sie Informationen an einem bestimmten Punkt im Manifest ausdrucken können. Dies ist ein guter Weg zu sagen, zum Beispiel, wenn eine Variable nicht definiert ist oder einen unerwarteten Wert hat. Manchmal ist es sinnvoll, nur zu wissen, dass ein bestimmtes Stück Code ausgeführt wurde. Mit der Benachrichtigung von Puppet können Sie solche Nachrichten ausdrucken.

### Wie es geht...

Definieren Sie eine `notify` ressource in Ihrem Manifest an der Stelle, die Sie untersuchen möchten:
`notify { 'Got this far!': }`

### Wie es funktioniert...

Wenn diese Ressource angewendet wird, druckt Puppet die Nachricht aus:
`notice: Got this far!`

### Es gibt mehr...

Zusätzlich zu einfachen Meldungen können wir Variablen innerhalb unserer `notify` ausgeben. Darüber hinaus können wir die `notify` aufrufe so behandeln wie andere Ressourcen, die sie benötigen oder von anderen Ressourcen benötigt werden.

### Ausgeben von Variablenwerten

Sie können sich auf Variablen in der Nachricht beziehen:
`notify { "operatingsystem is ${::operatingsystem}": }`

Puppet interpoliert die Werte im Ausdruck:
`Notice: operatingsystem is Fedora`

Der doppelte Doppelpunkt (`::`) vor der Tatsache Name sagt Puppet, dass dies eine Variable in Top-Bereich (zugänglich für alle Klassen) und nicht lokal für die Klasse. Für mehr darüber, wie Puppet Handle variablen Bereich, siehe die Puppet Labs Artikel:

Http://docs.puppetlabs.com/guides/scope_and_puppet.html

### Ressourcenbestellung(Resource ordering)

Puppe kompiliert Ihre Manifeste in einen Katalog; Die Reihenfolge, in der Ressourcen auf dem Client (Node) ausgeführt werden, ist möglicherweise nicht die gleiche wie die Reihenfolge der Ressourcen in Ihren Quelldateien. Wenn Sie eine `notify` ressource für das Debuggen verwenden, sollten Sie die Ressourcenverkettung verwenden, um sicherzustellen, dass die `notify resource` vor oder nach Ihrer fehlgeschlagenen Ressource ausgeführt wird.

Wenn zum Beispiel der exec `failing exec` fehlgeschlagen ist, können Sie eine `notify resource` kette, um direkt vor der fehlgeschlagenen exec-Ressource zu laufen, wie hier gezeigt:
```
notify{"failed exec on ${hostname}": }->
exec {'failing exec':
  command   => "/bin/grep ${hostname} /etc/hosts",
logoutput => true,
}
```

Wenn Sie die Ressource nicht ketten oder einen Metaparameter wie `before` oder `require`, gibt es keine Garantie, dass Ihre `notify` anweisung in der anderen Ressourcen ausgeführt wird, die Sie am Debuggen interessiert hat. 
Weitere Informationen zur Ressourcenbestellung finden Sie unter https://docs.puppetlabs.com/puppet/latest/reference/lang_relationships.html.

Zum Beispiel, um Ihre `notify resource` laufen nach `'failing exec'` in der vorherigen Code-Snippet, verwenden Sie:
```
notify { 'Resource X has been applied':
  require => Exec['failing exec'],
}
```

Beachten Sie jedoch, dass in diesem Fall die `notify resource` nicht ausgeführt wird, da die Ausführung fehlgeschlagen ist. Wenn eine Ressource fehlschlägt, werden alle Ressourcen, die von dieser Ressource abhängen, übersprungen:
```
notify {'failed exec failed': 
  require => Exec['failing exec']
}
```

Wenn wir Puppet laufen, sehen wir, dass die `notify resource` übersprungen wird:
```
t@mylaptop ~/puppet/manifests $ puppet apply fail.pp
...
Error: /bin/grepmylaptop /etc/hosts returned 1 instead of one of [0]
Error: /Stage[main]/Main/Exec[failing exec]/returns: change from notrun to 0 failed: /bin/grepmylaptop /etc/hosts returned 1 instead of one of [0]
Notice: /Stage[main]/Main/Notify[failed exec failed]: Dependency Exec[failing exec] has failures: true
Warning: /Stage[main]/Main/Notify[failed exec failed]: Skipping because of failed dependencies
Notice: Finished catalog run in 0.06 seconds
```