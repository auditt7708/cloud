EPP Vorlagen sind ein neues Feature in Puppet 3.5 und neueren Versionen. EPP-Vorlagen verwenden eine Syntax ähnlich ERB-Vorlagen, werden aber nicht durch Ruby kompiliert. Es werden zwei neue Funktionen definiert, um EPP-Vorlagen, `epp` und `inline_epp` aufzurufen. Diese Funktionen sind die EPP-Äquivalente der ERB-Funktion `template` bzw. `inline_template`. Der Hauptunterschied zu den EPP-Vorlagen besteht darin, dass die Variable mit der Puppet Notation referenziert wird. `$variable` statt `@variable`.

### Wie es geht...

1. Erstellen Sie eine EPP-Vorlage in `~/puppet/epp-test.epp` mit folgendem Inhalt:
`This is <%= $message %>.`

2. Erstellen Sie ein `epp.pp` Manifest, das die Funktionen `epp` und `inline_epp` verwendet:

```
$message = "the message"
file {'/tmp/epp-test':
  content => epp('/home/thomas/puppet/epp-test.epp')
}
notify {inline_epp('Also prints <%= $message %>'):}
```

3. Wenden Sie das Manifest an, um sicherzustellen, dass Sie den zukünftigen Parser verwenden (der zukünftige Parser ist erforderlich, damit die `epp` und `inline_epp` Funktionen definiert werden):

```
t@mylaptop ~/puppet $ puppet apply epp.pp --parser=future
Notice: Compiled catalog for mylaptop in environment production in 1.03 seconds
Notice: /Stage[main]/Main/File[/tmp/epp-test]/ensure: defined content as '{md5}999ccc2507d79d50fae0775d69b63b8c'
Notice: Also prints the message
```

4. Vergewissern Sie sich, dass die Vorlage wie beabsichtigt funktioniert:

```
t@mylaptop ~/puppet $ cat /tmp/epp-test 
This is the message.
```

### Wie es funktioniert...

Mit dem zukünftigen Parser werden die Funktionen `epp` und `inline_epp` definiert. Der Hauptunterschied zwischen EPP-Vorlagen und ERB-Vorlagen besteht darin, dass Variablen auf die gleiche Weise referenziert werden, wie sie sich innerhalb der Puppet manifestes befinden.

### Es gibt mehr...

Sowohl `epp` als auch `inline_epp` erlauben es, dass Variablen innerhalb des Funktionsaufrufs überschrieben werden. Ein zweiter Parameter für den Funktionsaufruf kann verwendet werden, um Werte für Variablen festzulegen, die im Rahmen des Funktionsaufrufs verwendet werden. Zum Beispiel können wir den Wert von `$message` mit dem folgenden Code überschreiben:

```
file {'/tmp/epp-test':
  content => epp('/home/tuphill/puppet/epp-test.epp',
    { 'message' => "override $message"} )
}
notify {inline_epp('Also prints <%= $message %>',
  { 'message' => "inline override $message"}):}
```

Jetzt, wenn wir Puppet ausführen und die Ausgabe überprüfen, sehen wir, dass der Wert von `$message` überschrieben wurde:
```
t@mylaptop ~/puppet $ puppet apply epp.pp --parser=future
Notice: Compiled catalog for mylaptop.pan.costco.com in environment production in 0.85 seconds
Notice: Also prints inline override the message
Notice: Finished catalog run in 0.05 seconds
t@mylaptop ~/puppet $ cat /tmp/epp-test 
This is override the message.
```