Vor Docker 1.2 gab es eine Option zum Neustart des Containers. Mit der Freigabe von Docker 1.2 wurde es mit dem Befehl `run` mit Flags hinzugefügt, um die Neustartrichtlinie anzugeben. Mit dieser Richtlinie können wir Container konfigurieren, um beim Booten zu starten. Diese Option ist auch sehr nützlich, wenn ein Container versehentlich stirbt.

### Fertig werden

Vergewissern Sie sich, dass der Docker-Daemon auf dem Host läuft und Sie können über den Docker-Client eine Verbindung herstellen.

### Wie es geht…

Sie können die Neustartrichtlinie mit der folgenden Syntax festlegen:

`$ docker run --restart=POLICY [ OPTIONS ]  IMAGE[:TAG]  [COMMAND]  [ARG...] `

Hier ist ein Beispiel für einen Befehl:
`$ docker run --restart=always -d -i -t fedora /bin/bash`

Es gibt drei Neustart-Richtlinien zur Auswahl:

* no: Dies startet den Container nicht, wenn er stirbt

* on-failure: Hiermit wird der Container neu gestartet, wenn er mit einem Nullpunktausgang fehlschlägt

* always: Das startet immer den Container, ohne sich um den Returncode zu kümmern

### Es gibt mehr…

Sie können auch eine optionale Neustartzählung mit der `on-failure`-Richtlinie wie folgt eingeben:

`$ Docker run --restart = on-failure: 3 -d -i -t fedora /bin/bash
`
Der vorherige Befehl startet den Behälter nur dreimal, wenn ein Fehler auftritt.

