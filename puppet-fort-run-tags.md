Eine häufige Anforderung ist, eine bestimmte Gruppe von Ressourcen vor anderen Gruppen anzuwenden (zum Beispiel einer Paket-Repository oder eine benutzerdefinierte Ruby-Version zu installieren), oder nach der anderen (zum Beispiel der Bereitstellung eine Anwendung, sobald ihre Abhängigkeiten installiert sind). Puppet der Laufstufe Funktion ermöglicht es Ihnen, dies zu tun.

Standardmäßig werden alle Ressourcen in Ihrem Manifest in einer einzigen Stufe genannt angewandt main. Wenn Sie eine Ressource müssen vor allen anderen angewendet werden, können Sie es zu einem neuen Fahrstufe zuweisen, bevor kommen angegeben wird main. In ähnlicher Weise könnten Sie einen Lauf Stufe definieren , die nach kommt main. In der Tat können Sie so viele Laufstufen definieren , wie Sie Puppet benötigen und erklären , welche Reihenfolge sie in angewendet werden.

In diesem Beispiel werden wir Stufen verwenden Sie eine Klasse, um sicherzustellen, angewendet erste und eine andere letzte.

### Wie es geht…

Hier sind die Schritte , um ein Beispiel für die Verwendung Lauf zu erstellen stages:

1. Erstellen Sie die Datei `modules/admin/manifests/stages.pp` mit folgendem Inhalt:
```
  class admin::stages {
    stage { 'first': before => Stage['main'] }
    stage { 'last': require => Stage['main'] }
    class me_first {
      notify { 'This will be done first': }
    }
    class me_last {
      notify { 'This will be done last': }
    }
    class { 'me_first':
      stage => 'first',
    }
    class { 'me_last':
      stage => 'last',
    }
  }
```

2. Ändern Sie bitte Ihre site.ppDatei wie folgt:
```
  node 'Kochbuch' {
    Klasse { 'first_class':}
    Klasse { 'second_class':}
    Admin umfassen :: Stufen
  }
```

3. Puppet run:
```
root@cookbook:~# puppet agent -t
Info: Applying configuration version '1411019225'
Notice: This will be done first
Notice: Second Class
Notice: First Class
Notice: This will be done last
Notice: Finished catalog run in 0.43 seconds
```
Wie es funktioniert…

Lassen Sie sich diesen Code im Detail untersuchen , um zu sehen , was passiert. Zuerst erklären wir die Laufphasen firstund last, wie folgt:

```
  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }
```

Für die `first` Stage, haben wir festgelegt , dass es vor kommen sollte `main`. Das heißt, jede Ressource markiert in der als `first` in dem vor jeder Ressource angewandt Stufe `main` stage (die Standard - stage).

Die `last` Stage erfordert die `main` stage, so dass keine Ressource in der `last` stage kann in der bis nach jeder Ressource angewandt wird `main` stage.

Wir erklären dann einige Klassen, die wir später in diesem Lauf stages zuordnen werden:

```
  class me_first {
    notify { 'This will be done first': }
  }
  class me_last {
    notify { 'This will be done last': }
  }
```

Wir können es jetzt setzen alle zusammen und umfassen diese Klassen auf dem Knoten, die Laufstufen für jede Angabe, wie wir dies tun:

```
  class { 'me_first': stage => 'first',
  }
  class { 'me_last': stage => 'last',
  }
```

Beachten Sie, dass in den `class` Erklärungen für `me_first` und `me_last` wir mussten nicht angeben , dass sie einen nehmen `stage` Parameter. Der `stage` Parameter ist ein weiterer metaparameter, was bedeutet , kann es ohne explizit deklariert werden müssen zu jeder Klasse oder Ressource angewandt werden. Wenn wir liefen `puppet agent` auf unserem Puppet Node, teilen die von der `me_first` Klasse vor der benachrichtigt angewandt wurde von `first_class` und `second_class`. Die benachrichtigt `me_last` wurde nach der angelegten mainBühne, so dass es nach dem beide benachrichtigt kommt von `first_class` und second_class. Wenn Sie laufen `puppet agent` mehrere Male, werden Sie sehen, dass die benachrichtigt aus `first_class` und `second_class` nicht immer in der gleichen Reihenfolge erscheinen , aber die me_firstKlasse wird immer an erster Stelle und die `me_last` Klasse wird immer zuletzt kommen.