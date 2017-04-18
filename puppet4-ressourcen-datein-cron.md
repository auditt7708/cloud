Wenn du viele Server hast, die denselben Cron Job ausführen, ist es gewöhnlich eine gute Idee, sie nicht alle zur gleichen Zeit auzuführen. 
Wenn alle Aufträge auf einen gemeinsamen Server zugreifen (z. B. beim Ausführen von Backups), kann es zu kommen, dass zuviel auf diesen Server geladen wird, und selbst wenn sich dass nicht ergibt, werden alle Server gleichzeitig beschäftigt sein, was die Fähigkeit beeinflussen kann, andere Dienst verfügbar zu halten.

Wie üblich kann Puppet helfen; Dieses Mal, mit der `inline_template` Funktion, um eine eindeutige Zeit für jeden Job zu berechnen.

### Wie es geht...

Hier ist ein beispiel, wie man Puppet Zeitpläne für den gleichen Job zu einem anderen Zeitpunkt für jede Maschine haben kann:

1. Ändern Sie Ihre `site.pp` Datei wie folgt:
```
node 'cookbook' {
  cron { 'run-backup':
    ensure  => present,
    command => '/usr/local/bin/backup',
    hour    => inline_template('<%= @hostname.sum % 24 %>'),
    minute  => '00',
  }
}
```

2. Puppet run:
```
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413730771'
Notice: /Stage[main]/Main/Node[cookbook]/Cron[run-backup]/ensure: created
Notice: Finished catalog run in 0.11 seconds
```

3. Führen Sie `crontab´ aus, um zu sehen, wie der Job konfiguriert wurde:
```
[root@cookbook ~]# crontab -l
# HEADER: This file was autogenerated at Sun Oct 19 10:59:32 -0400 2014 by puppet.
# HEADER: While it can still be managed manually, it is definitely not recommended.
# HEADER: Note particularly that the comments starting with 'Puppet Name' should
# HEADER: not be deleted, as doing so could cause duplicate cron jobs.
# Puppet Name: run-backup
0 15 * * * /usr/local/bin/backup
```

### Wie es funktioniert...

Wir wollen die Stunde die der Cron-Jobs läuft über alle unsere Knoten verteilen. Wir wählen etwas, das über alle Maschinen einzigartig ist und es in eine Zahl umwandelt. Auf diese Weise wird der Wert über die Knoten verteilt und wird sich nicht pro Knoten ändern.

Wir können die Umwandlung mit Rubys `sum` methode durchführen, die einen numerischen Wert aus einer Zeichenkette berechnet, die für die Maschine eindeutig ist (in diesem Fall reicht der Hostname des Rechners). Die Summenfunktion erzeugt eine große Ganzzahl (im Fall des Strings `cookbook` ist die Summe 855), und wir wollen Werte für Stunden zwischen 0 und 23, also verwenden wir Rubys `%` (modulo) Operator, um das Ergebnis auf diesen Bereich zu beschränken . 
Wir sollten eine vernünftig gute (wenn auch nicht statistisch einheitliche) Verteilung der Werte erhalten, abhängig von Ihren Hostnamen. Eine weitere Möglichkeit ist hier, die Funktion `fqdn_rand()` zu verwenden, die in ähnlicher Weise funktioniert wie unser Beispiel.

Wenn alle deine Maschinen den gleichen Namen haben (dass passiert), benutze nicht diesen Trick! In diesem Fall können Sie einen anderen String verwenden, der für die Maschine eindeutig ist, z. B. `ipaddress` oder `fqdn`.

### Es gibt mehr...

Wenn Sie mehrere Cron-Jobs pro Maschine haben und Sie eine bestimmte Anzahl von Stunden auseinander ausführen möchten, fügen Sie diese Nummer der `hostname.sum` Ressource hinzu, bevor Sie das Modul ausführen. Nehmen wir an, wir wollen den Job `dump_database` zu irgendeinem beliebigen Zeitpunkt und den `run_backup` Job eine Stunde später ausführen, dies kann mit dem folgenden Code-Snippet erfolgen:

```
cron { 'dump-database':
  ensure  => present,
  command => '/usr/local/bin/dump_database',
  hour    => inline_template('<%= @hostname.sum % 24 %>'),
  minute  => '00',
}

cron { 'run-backup':
  ensure  => present,
  command => '/usr/local/bin/backup',
  hour    => inline_template('<%= ( @hostname.sum + 1) % 24 %>'),
  minute  => '00',
}
```

Die beiden Jobs werden am Ende mit verschiedenen `hour` werten für jede Maschine auf der Puppet läuft starten, aber `run_backup` wird immer eine Stunde nach `dump_database` anlaufen.

Die meisten Cron-Implementierungen haben Verzeichnisse für stündliche, tägliche, wöchentliche und monatliche Aufgaben. 
Die Verzeichnisse `/etc/cron.hourly`, `/etc/cron.daily`, `/etc/cron.weekly` und `/etc/cron.monthly` existieren auf unseren Debian- und Enterprise Linux-Rechnern. 
Diese Verzeichnisse enthalten ausführbare Dateien, die auf dem referenzierten Zeitplan (stündlich, täglich, wöchentlich oder monatlich) ausgeführt werden. 
Ich finde es besser, alle Jobs in diesen Ordnern wie ihr Name beschreibt abzulegen und die Jobs als Dateizugriff zu verteilen. 
Ein Admin der nach deinem Skript sucht, kann es mit `grep` in diesen Verzeichnissen finden. Um den gleichen Trick hier zu benutzen, würden wir eine Cron-Aufgabe in `/etc/cron.hourly` Kopieren und dann überprüfen, dass die Stunde die richtige Stunde für die Aufgabe ist, um laufen zu können. Gehen Sie folgendermaßen vor, um die Cron-Jobs mit den Cron-Verzeichnissen zu erstellen:

1. Zuerst erstellen Sie eine `cron` Klasse in den `modules/cron/init.pp`:
```
class cron {
  file { '/etc/cron.hourly/run-backup':
    content => template('cron/run-backup'),
    mode    => 0755,
  }
}
```

2. Füge die `cron` Klasse in deinem Node in der Datei `site.pp` ein:
```
node cookbook {
  include cron
}
```

3. Erstellen Sie eine Vorlage, um alle Cron-Tasks zu erstellen:
```
#!/bin/bash

runhour=<%= @hostname.sum%24 %>
hour=$(date +%H)
if [ "$runhour" -ne "$hour" ]; then
  exit 0
fi

echo run-backup
```

4. Dann, machen einen Puppet run:
```
[root@cookbook ~]# puppet agent -t
Info: Caching catalog for cookbook.example.com
Info: Applying configuration version '1413732254'
Notice: /Stage[main]/Cron/File[/etc/cron.hourly/run-backup]/ensure: defined content as '{md5}5e50a7b586ce774df23301ee72904dda'
Notice: Finished catalog run in 0.11 seconds
```

5. Vergewissern Sie sich, dass das Skript denselben Wert hat, den wir vorher berechnet haben, `15`:
```
#!/bin/bash

runhour=15
hour=$(date +%H)
if [ "$runhour" -ne "$hour" ]; then
  exit 0
fi

echo run-backup
```
Jetzt wird dieser Job jede Stunde laufen, aber nur, wenn die Stunde, die von `$(date +%H)` zurückgegeben wird, gleich `15` ist den Rest des Skripts ausführen. 
Erstellen ihrer Cron-Jobs als Datei in einer großen Organisation macht es einfacher für Ihre Kollegen, sie zu finden da hier jeder Admin zuerst nachsieht. 
Wenn Sie eine sehr große Anzahl von Maschinen haben, kann es vorteilhaft sein, eine weitere zufällige Wartezeit am Anfang Ihres Jobs hinzuzufügen. 
Du musst die Zeile vor dem Echo-Run-Backup ändern und folgendes hinzufügen:

```
MAXWAIT=600
sleep $((RANDOM%MAXWAIT))
```

Hier wird der Job Maximal `600` Sekunden schlafen, aber es wird jedes Mal, wenn es läuft, eine andere anzahlt von Sekunden schlafen (vorausgesetzt, Ihr Zufallszahlengenerator funktioniert). Diese Art des zufälligen Wartens ist nützlich, wenn Sie Tausende von Maschinen haben, alle haben die gleiche Aufgabe und Sie müssen die Aufgaben so viel wie möglich verteilen.

