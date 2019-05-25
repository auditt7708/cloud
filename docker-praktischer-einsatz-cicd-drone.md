Wie erwähnt auf der Drone-Website (https://drone.io/), Drone ist ein gehosteter Continuous Integration Service. Es ermöglicht Ihnen, bequem zu konfigurieren Projekte automatisch zu bauen, zu testen und zu implementieren, wie Sie Änderungen an Ihrem Code vornehmen. Sie bieten eine Open-Source-Version ihrer Plattform, die Sie in Ihrer Umgebung oder auf Wolke hosten können. Ab sofort unterstützen sie Sprachen wie C / C ++, Dart, Go, Haskell, Groovy, Java, Node.js, PHP, Python, Ruby und Scala. Mit Drone können Sie Ihre Anwendung auf Plattformen wie Heroku, Dotcloud, Google App Engine und S3 bereitstellen. Sie können auch SSH (rsync) Ihren Code zu einem Remote-Server für die Bereitstellung.

Für dieses Rezept, verwenden wir das gleiche Beispiel, das wir in den früheren Rezepten verwendet haben.

### Fertig werden

1. Melden Sie sich bei Drone an (https://drone.io/).

2. Klicken Sie auf Neues Projekt und richten Sie das Repository ein. In unserem Fall werden wir das gleiche Repository von GitHub auswählen, das wir im vorherigen Rezept (https://github.com/nkhare/flask-example) verwendet haben:
![flask-example](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_06.jpg)

3. Einmal ausgewählt, werden Sie aufgefordert, die Programmiersprache für das ausgewählte Repository auszuwählen. Ich habe in diesem Fall Python ausgewählt.

4. Es wird Sie dann auffordern, das Build-Skript einzurichten. Für dieses Rezept werden wir folgendes setzen und speichern:
```
pip install -r requirements.txt --use-mirrors
cd wsgi
py.test

```

### Wie es geht…

1. Auslösen eines manuellen Builds durch Klicken auf Build Now, wie im folgenden Screenshot gezeigt:
![droneio-1](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_07.jpg)

### Wie es funktioniert…

Der Build-Prozess startet einen neuen Container, kloniert das Quellcode-Repository und führt die Befehle aus, die wir im Befehlsbefehl (im Laufe der Testfälle) in ihm angegeben haben.

### Es gibt mehr…
* Sobald der Build abgeschlossen ist, können Sie sich die Konsolenausgabe anschauen.

* Drone fügt auch einen Webhook in GitHub hinzu; Wenn Sie das nächste Mal Änderungen im Repository vornehmen, wird ein Build ausgelöst.

* Drone unterstützt auch Continuous Deployment in verschiedenen Cloud-Umgebungen, wie wir in der früheren Rezeptur gesehen haben. Um das einzurichten, gehen Sie auf die Registerkarte "Einstellungen", wählen Sie "Bereitstellung" und wählen Sie "Neue Bereitstellung hinzufügen". Wählen Sie Ihren Cloud-Provider aus und richten Sie ihn ein:
![drone-2](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_08.jpg)

### Siehe auch

* Die Drone-Dokumentation unter http://docs.drone.io/

* Die Schritte zum Konfigurieren einer selbst gehosteten Drone-Umgebung, die sich in der Alpha-Bühne ab sofort befindet, unter https://github.com/drone/drone