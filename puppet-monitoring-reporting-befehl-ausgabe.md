Wenn Sie die `exec` Ressourcen verwenden, um Befehle auf dem Knoten auszuführen, gibt Ihnen die Puppet eine Fehlermeldung wie die folgende, wenn ein Befehl einen Nicht-Null-Exit-Status zurückgibt:
```
Notice: /Stage[main]/Main/Exec[/bin/cat /tmp/missing]/returns: /bin/cat: /tmp/missing: No such file or directory
Error: /bin/cat /tmp/missing returned 1 instead of one of [0]
Error: /Stage[main]/Main/Exec[/bin/cat /tmp/missing]/returns: change from notrun to 0 failed: /bin/cat /tmp/missing returned 1 instead of one of [0]
```

Wie Sie sehen können, berichtet Puppet nicht nur, dass der Befehl fehlgeschlagen ist, sondern zeigt seine Ausgabe:
`/bin/cat: /tmp/missing: No such file or directory`

Dies ist nützlich, um herauszufinden, warum der Befehl nicht funktioniert hat, aber manchmal ist der Befehl tatsächlich gelingt (da er einen Null-Exit-Status zurückgibt), aber immer noch nicht was wir wollten. In diesem Fall, wie können Sie die Befehlsausgabe sehen? Sie können das Attribut `logoutput` verwenden.

### Wie es geht...

Gehen Sie folgendermaßen vor, um die Befehlsausgabe zu protokollieren:

1. Definiere eine `exec` Ressource mit dem `logoutput` Parameter, wie im folgenden Code-Snippet gezeigt:
```
exec { 'exec with output':
  command   => '/bin/cat /etc/hostname',
logoutput => true,
}
```

2. Puppet run: 
```
t@mylaptop ~/puppet/manifests $ puppet apply exec.pp
Notice: Compiled catalog for mylaptop in environment production in 0.46 seconds
Notice: /Stage[main]/Main/Exec[exec with outout]/returns: mylaptop
Notice: /Stage[main]/Main/Exec[exec with outout]/returns: executed successfully
Notice: Finished catalog run in 0.06 seconds
```

3. Wie Sie sehen können, obwohl der Befehl erfolgreich ist, druckt Puppet die Ausgabe:

`mylaptop`

### Wie es funktioniert...

Das `logoutput` Attribut hat drei mögliche Einstellungen:
* False: Das gibt niemals die Befehlsausgaben aus

* On_failure: Dies gibt nur die Ausgabe aus, wenn der Befehl fehlschlägt (die Standardeinstellung)

* True: Dies gibt immer die Ausgabe aus, ob der Befehl erfolgreich ist oder fehlschlägt

### Es gibt mehr...

Sie können den Standardwert des Logoutput festlegen, um die Befehlsausgabe für alle Exec-Ressourcen immer anzuzeigen, indem Sie in Ihrer `site.pp` Datei Folgendes definieren:
```
Exec {
logoutput => true,
```

### Hinweis:
**Resource Defaults**: Was ist diese `Exec` Syntax? Es sieht aus wie eine exec Ressource, aber es ist nicht. Wenn Sie `Exec` mit einem Großen E verwenden, legen Sie den Ressourcenvorgang für exec fest. Sie können die Ressource-Standard für jede Ressource festlegen, indem Sie den ersten Buchstaben des Ressourcentyps aktivieren. Überall, wo Puppet diese Ressource innerhalb des aktuellen Bereichs oder eines verschachtelten Subkops sieht, wird es die von Ihnen definierten Vorgaben anwenden.

Wenn Sie die Befehlsausgabe niemals sehen wollen, ob es gelingt oder fehlschlägt, verwenden Sie:
`logoutput => false,`

Mehr information auf https://docs.puppetlabs.com/references/latest/type.html#exec.