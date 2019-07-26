# Docker Orchestration und atomi, cockpit

Cockpit (http://cockpit-project.org/) ist ein Server-Manager, der es einfach macht, Ihre GNU/Linux-Server über einen Webbrowser zu verwalten. Es kann auch verwendet werden, um den Project Atomic Host zu verwalten. Mehr als ein Host kann über eine Cockpit-Instanz verwaltet werden. Cockpit kommt nicht standardmäßig mit dem neuesten Project Atomic, und Sie müssen es als **Super Privileged Container (SPC)** starten. SPCs sind speziell gebaute Container, die mit Sicherheit ausgeschaltet laufen (`--privileged`); Sie schalten ein oder mehrere Namespaces oder "Volume Mounts in" Teile des Host OS in den Container. Weitere Informationen über SPC finden Sie unter https://developerblog.redhat.com/2014/11/06/introducing-a-super-privileged-container-concept/ und https://www.youtube.com/watch?v=EJIeGnHtIYg.

Da Cockpit als SPC läuft, kann es auf die Ressourcen zugreifen, die für die Verwaltung des Atomic-Hosts im Container benötigt werden.
Fertig werden

Richten Sie den Project Atomic Host ein und melden Sie sich dazu an.

## Wie es geht…

1.Führen Sie den folgenden Befehl aus, um den Cockpit-Container zu starten:

`[fedora@atomichost ~]$ sudo atomic run stefwalter/cockpit-ws`

2.Öffnen Sie den Browser (`http://<VM IP>:9090`) und melden Sie sich mit dem Standard Benutzer/Passwort fedora/atomic an. Einmal angemeldet, können Sie den aktuellen Host auswählen, der verwaltet werden soll. Sie sehen einen Bildschirm wie hier gezeigt:
![cockpit-docker-atmic](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_08_14.jpg)

### Wie es funktioniert…

Hier haben wir den `atomic` Befehl anstelle des docker `Befehls` verwendet, um den Container zu starten. Schauen wir uns die Cockpit Dockerfile an (https://github.com/fedora-cloud/Fedora-Dockerfiles/blob/master/cockpit-ws/Dockerfile), um zu sehen, warum wir das gemacht haben. In der Dockerfile wirst du einige Anweisungen sehen:

```s
LABEL INSTALL /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /container/atomic-install
LABEL UNINSTALL /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /cockpit/atomic-uninstall
LABEL RUN /usr/bin/docker run -d --privileged --pid=host -v /:/host IMAGE /container/atomic-run --local-ssh
```

wir können Metadaten zu Bildern und Containern mit Labels zuordnen. `INSTALL`, `UNINSTALL` und `RUN` sind hier Labels. Der `atomic` Befehl ist ein Befehl, der für das Projekt Atomic spezifisch ist, das dieser Etiketten liest und Operationen ausführt. Da der Container als SPC läuft, braucht es keine Portweiterleitung von Host zu Container. Für weitere Details über den atomaren Befehl, besuchen Sie bitte https://developerblog.redhat.com/2015/04/21/introducing-the-atomic-command/.

## Es gibt mehr…

Sie können fast alle Administratoraufgaben aus der GUI für das jeweilige System ausführen. Hier können Sie Docker-Bilder / Container verwalten. Sie können Operationen wie:

* Image Downloaden

* Starten / Stoppen der Container

Sie können auch andere Maschinen der gleichen Cockpit-Instanz hinzufügen, so dass Sie sie von einem zentralen Standort aus verwalten.
