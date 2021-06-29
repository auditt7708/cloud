---
title: docker-arbeiten-images-auto-github-bitbucket
description: 
published: true
date: 2021-06-09T15:05:33.624Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:05:28.412Z
---

# Docker Arbeiten mit Images. Github und bitbucket

Wir haben früher gesehen, wie man die Docker-Images auf Docker Hub gepushed. Docker Hub ermöglicht es uns, automatisierte Bilder aus einem GitHub / Bitbucket-Repository mit seinen Build-Clustern zu erstellen. Das GitHub / Bitbucket-Repository sollte die Dockerfile und den Inhalt enthalten, der zum Kopieren / Hinzufügen in das Bild erforderlich ist. Schauen wir uns ein GitHub-Beispiel in den kommenden Abschnitten an.

## Fertig werden

Sie benötigen ein Konto auf Docker Hub und GitHub. Sie benötigen auch ein GitHub-Repository mit einer entsprechenden Dockerfile auf der obersten Ebene.

## Wie es geht…

1.Melden Sie sich bei [Docker Hub an](https://hub.docker.com/) und klicken Sie auf das grüne Pluszeichen. Füge das Repository-Symbol in der rechten oberen Ecke hinzu und klicke auf Automated Build. Wählen Sie GitHub als Quelle für die automatisierte Erstellung. Wählen Sie dann die Option Public und Private (empfohlen), um eine Verbindung zu GitHub herzustellen. Geben Sie den GitHub-Benutzernamen / Passwort ein, wenn Sie dazu aufgefordert werden. Wählen Sie das GitHub-Repository aus, um automatisiertes Erstellen durchzuführen.

![add-auto-build](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_03_15.jpg)

2.Nach dem Auswählen des GitHub-Repositorys wird es Sie bitten, den Zweig für den automatisierten Build zu wählen. Es wird auch verlangen, dass ein Tag-Name nach dem Bild verwendet wird, das es automatisch erstellt hat. Standardmäßig wird der letzte Tag-Name verwendet. Klicken Sie dann auf die Schaltfläche Speichern und Trigger erstellen, um den automatisierten Buildprozess zu starten. Das ist es!! Ihr Build ist jetzt eingereicht. Sie können auf den Build-Status klicken, um den Status des Builds zu überprüfen.

## Wie es funktioniert…

Wenn wir ein GitHub-Repository für automatisierten Build auswählen, aktiviert GitHub den Docker-Dienst für dieses Repository. Sie können den Abschnitt "Einstellungen" des GitHub-Repositorys für mehr Konfiguration ansehen. Wenn wir irgendwelche Änderungen an diesem GitHub-Repository vornehmen, wie z. B. Commits, wird ein automatisiertes Build mit der Dockerfile ausgelöst, die sich im GitHub-Repository befinden.

![webhooks-services](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_03_16.jpg)

## Es gibt mehr…

Sie können die Details wie Dockerfile, build Details Tags und andere Informationen, indem Sie auf die Ihre Repositorie Abschnitt gehen. Es hat auch die Details, wie man ein pull image durchführt:

![build-details](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_03_17.jpg)

Die Images, die mit dem automatisierten Build-Prozess erstellt werden, können nicht durch den Docker-Push-Befehl gepushed werden.

Sie können die Einstellungen im Bereich Webhooks & Services des Repositorys auf GitHub ändern, um den Docker-Dienst aufzuheben. Dies wird aufhören, die automatisierten Builds zu machen.

## Siehe auch

* Die Schritte zum automatischen Aufbau mit Bitbucket sind fast identisch. Der **Hook** für automatisierte Builds wird unter dem **Hooks**-Abschnitt des Bitbucket-Repository-Einstellungen-Bereichs konfiguriert.

* Die Dokumentation auf der [Docker-Website](https://docs.docker.com/docker-hub/builds/)
