#  Docker installion für Benutzer

Für die Benutzerfreundlichkeit können wir einem Nicht-Root-Benutzer erlauben, Docker zu verwalten, indem er sie zu einer Docker-Gruppe hinzufügt.

## Fertig werden

1. Erstellen Sie die Docker-Gruppe, wenn es nicht schon da ist:
`$ sudo group add docker`

2. Erstellen Sie den Benutzer, dem Sie die Berechtigung zur Verwaltung von Docker geben möchten:
`$ useradd dockertest`

## Wie es geht…

Führen Sie den folgenden Befehl aus, damit der neu erstellte Benutzer Docker verwalten kann:

`$ Sudo gpasswd - ein dockertest docker`

## Wie es funktioniert…

Der vorherige Befehl fügt der Docker-Gruppe einen Benutzer hinzu. Der hinzugefügte Benutzer kann somit alle Docker-Operationen durchführen. Dies kann das Sicherheitsrisiko sein. Besuchen Sie [Docker Sicherheit](../docker-sicherheit) für weitere Details.
