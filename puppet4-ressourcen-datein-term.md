So weit, sahen wir, was die Marionette tun kann, und die Ordnung, dass es Dinge macht, aber nicht, wenn es sie tut. Eine Möglichkeit, dies zu kontrollieren, ist, den `schedule` Metaparameter zu verwenden. Wenn Sie die Anzahl der Zeiten, in denen eine Ressource innerhalb eines bestimmten Zeitraums angewendet wird, begrenzen, kann der `schedule` helfen. Beispielsweise:
```
exec { "/usr/bin/apt-get update":
    schedule => daily,
}
```

Die wichtigste Sache, um über `schedule` zu verstehen ist, dass es nur stoppen kann eine Ressource angewendet werden. Es garantiert nicht, dass die Ressource mit einer bestimmten Frequenz angewendet wird. Zum Beispiel hat die `exec` Ressource, die in dem vorherigen Code-Snippet gezeigt wird, `schedule => daily`, aber dies stellt nur eine obere Grenze für die Anzahl von Malen dar, die die `exec` Ressource pro Tag ausführen kann. Es wird nicht mehr als einmal am Tag angewendet. Wenn du überhaupt keine Puppe betreibst, wird die Ressource überhaupt nicht angewendet. Die Verwendung des Stundenplans ist beispielsweise auf einer Maschine sinnlos, die für die Ausführung des Agenten alle 4 Stunden konfiguriert ist (über die `runinterval` Konfigurationseinstellung).

Das heißt, der `schedule` wird am besten verwendet, um die Ressourcen vom Laufen zu beschränken, wenn sie nicht oder nicht müssen; Zum Beispiel möchten Sie vielleicht sicherstellen, dass `apt-get update` nicht mehr als einmal pro Stunde ausgeführt wird. Es gibt einige eingebaute Zeitpläne für Sie zu verwenden:

* hourly

* daily

* weekly

* monthly

* never 

Allerdings können Sie diese ändern und erstellen Sie Ihre eigenen benutzerdefinierten `schedule`, mit der Zeitplan Ressource. Wir werden sehen, wie dies im folgenden Beispiel zu tun ist. Nehmen wir an, wir wollen sicherstellen, dass eine `exec` Ressource, die einen Wartungsauftrag darstellt, nicht während der Sprechstunden laufen wird, wenn sie die Produktion beeinträchtigen könnte.

### Wie es geht...

In diesem Beispiel erstellen wir eine benutzerdefinierte `schedule` ressource und weisen diese der Ressource zu:

1. Ändern Sie Ihre `site.pp` Datei wie folgt:
```
schedule { 'outside-office-hours':
  period => daily,
  range  => ['17:00-23:59','00:00-09:00'],
  repeat => 1,
}
node 'cookbook' {
  notify { 'Doing some maintenance':
    schedule => 'outside-office-hours',
  }
}
```

2. Laufpuppe ausführen Was du sehen wirst, hängt von der Tageszeit ab. Wenn es derzeit außerhalb der Öffnungszeiten ist, die Sie definiert haben, wird Puppet die Ressource wie folgt anwenden:
```
[root@cookbook ~]# date
Fri Jan  2 23:59:01 PST 2015
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413734477'
Notice: Doing some maintenance
Notice: /Stage[main]/Main/Node[cookbook]/Notify[Doing some maintenance]/message: defined 'message' as 'Doing some maintenance'
Notice: Finished catalog run in 0.07 seconds
```

3. Wenn die Zeit innerhalb der Sprechstunden ist, wird die Puppe nichts tun:
```
[root@cookbook ~]# date
Fri Jan  2 09:59:01 PST 2015
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413734289'
Notice: Finished catalog run in 0.09 seconds
```

### Wie es funktioniert...

Ein Zeitplan besteht aus drei Bits:
* Der Zeitraum (stündlich, täglich, wöchentlich oder monatlich)

* Der Bereich (standardmäßig auf den ganzen Zeitraum, kann aber ein kleinerer Teil davon sein)

* Die Wiederholungszählung (wie oft die Ressource darf innerhalb des Bereichs angewendet werden, die Voreinstellung ist 1 oder einmal pro Periode)

Unser kundenspezifischer Zeitplan, der `outside-office-hours` genannt wird, liefert diese drei Parameter:
```
schedule { 'outside-office-hours':
  period => daily,
  range  => ['17:00-23:59','00:00-09:00'],
  repeat => 1,
}
```

Die `period`(Periode) ist `daily`(täglich), und der `range`(Bereich) ist definiert als ein Array von zwei Zeitintervallen:
```
17:00-23:59
00:00-09:00
```

Der `schedule`, der mit `outside-office-hours` benannt ist, steht nun für uns zur Verfügung, um mit jeder Ressource zu arbeiten, so als ob es in Puppe wie die `daily`(Tages) oder `hourly`(Stunden) Pläne eingebaut wurde. In unserem Beispiel vergeben wir diesen Zeitplan der `exec`-Ressource mit dem `schedule`-Metaparameter:
```
notify { 'Doing some maintenance':
  schedule => 'outside-office-hours',
}
```

Ohne diesen `schedule` würde die Ressource jedes Mal angewendet, wenn die Puppe läuft. Mit ihm wird die Puppe die folgenden Parameter überprüfen, um zu entscheiden, ob die Ressource angewendet werden soll oder nicht:

* Ob die Zeit im zulässigen Bereich liegt

* Ob die Ressource bereits in dieser Periode die maximal zulässige Anzahl der Zeiten durchgeführt hat

Zum Beispiel, betrachten wir, was passiert, wenn die Puppe um 4 Uhr, 5 Uhr und 6 Uhr an einem bestimmten Tag läuft:

* 4 Uhr .: Es ist außerhalb der erlaubten Zeitspanne, so dass Puppe nichts tun wird

* 5 Uhr .: Es ist innerhalb der erlaubten Zeitspanne, und die Ressource wurde noch nicht in diesem Zeitraum ausgeführt, so wird Puppet die Ressource anwenden

* 6 Uhr .: Es ist innerhalb der erlaubten Zeitspanne, aber die Ressource wurde bereits die maximale Anzahl von Zeiten in diesem Zeitraum ausgeführt, so Puppet wird nichts tun

Und so weiter bis zum nächsten Tag.

### Es gibt mehr...

Der `repeat`(Wiederholungs) parameter regelt, wie oft die Ressource bei den anderen Einschränkungen des Zeitplans angewendet wird. Zum Beispiel, um eine Ressource nicht mehr als sechs Mal pro Stunde anzuwenden, verwenden Sie einen Zeitplan wie folgt:
```
period => hourly,
repeat => 6,
```

Denken Sie daran, dass dies nicht garantieren, dass der Job sechs Mal pro Stunde läuft. Es setzt einfach eine obere Grenze; Egal wie oft Puppe läuft oder sonst etwas passiert, wird der Job nicht laufen, wenn es schon sechsmal in dieser Stunde gelaufen ist. Wenn die Puppe nur einmal am Tag läuft, wird der Job nur einmal ausgeführt. So `schedule`(Zeitplan) ist am besten verwendet, um sicherzustellen, dass Dinge nicht zu bestimmten Zeiten passieren (oder nicht überschreiten eine gegebene Frequenz).