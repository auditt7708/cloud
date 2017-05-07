Es ist praktisch zu wissen, wie das Bild, das wir verwenden, erstellt wurde. Der `docker history`-Befehl hilft uns, alle Zwischenschichten zu finden.

### Fertig werden

Kopieren oder importieren Sie ein Docker-Bild.

### Wie es geht…

1. Um die Geschichte des Images zu betrachten, betrachte die folgende Syntax:
`$ docker history [ OPTIONS ] IMAGE`

Hier ist ein Beispiel mit der vorherigen Syntax:
`$ docker history nkhare/fedora:httpd`

### Wie es funktioniert…

Mit den Metadaten eines Images kann Docker erkennen, wie ein Bild erstellt wird. Mit dem `history` befehl wird es die Metadaten rekursiv betrachten, um zum Ursprung zu gelangen.

### Es gibt mehr…

Schauen Sie sich die Commit-Nachricht einer Ebene an, die angewendet wurden:
```
$ docker inspect --format='{{.Comment}}' nkhare/fedora:httpd
Fedora with HTTPD package 
```

Derzeit gibt es keinen direkten Weg, um die Commit-Nachricht für jede Schicht mit einem einzigen Befehl zu betrachten, aber wir können den `inspect` befehl, den wir früher gesehen haben, für jede Ebene verwenden.

