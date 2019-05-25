AWS OpsWorks ist ein umfassendes AWS EC2 und Application Deployment Framework, das auf Chef basiert (http://chef.io/). Es ist einfach, das Chef Rezept und EC2 Instanz mit der OpsWorks UI zu assoziieren.
Fertig werden

Um Ihren Chef Rezepte hochzuladen und zu pflegen, empfiehlt es sich, ein GitHub (http://github.com) Konto vorzubereiten. Nach dem Erstellen eines Kontos auf GitHub erstellen Sie ein Repository `my-opsworks-recipes` für OpsWorks Rezepte.

Nur so weißt du, ein freier Benutzer auf GitHub kann nur ein öffentliches Repository erstellen.
![github-opsworks-recipes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_11.jpg)
Git-Repository erstellen

Nach dem Erstellen des `my-opsworks-recipes` können Sie auf das Git-Repository über `http://github.com/<your Benutzername>/my-opsworks-recipes.git` zugreifen.

Nutzen wir die AWS CloudWatchLogs als Beispiel-Einsatz, um ein Rezept in Ihr Repository zu legen, wie folgt:

```
//Download CloudWatchLogs Cookbooks
$ curl -L -O https://s3.amazonaws.com/aws-cloudwatch/downloads/CloudWatchLogs-Cookbooks.zip
//unzip
$ unzip CloudWatchLogs-Cookbooks.zip 
//clone your GitHub repository
$ git clone https://github.com/hidetosaito/my-opsworks-recipes.git
//copy CloudWatchLogs Cookbooks into your Git repository
$ mv CloudWatchLogs-Cookbooks/logs my-opsworks-recipes/
$ cd my-opsworks-recipes/
//add recipes to Git
$ git add logs
$ git commit -a -m "initial import"
[master (root-commit) 1d9c16d] initial import
 5 files changed, 59 insertions(+)
 create mode 100755 logs/attributes/default.rb
 create mode 100644 logs/metadata.rb
 create mode 100755 logs/recipes/config.rb
 create mode 100755 logs/recipes/install.rb
 create mode 100755 logs/templates/default/cwlogs.cfg.erb
//push to GitHub.com
$ git push
Username for 'https://github.com': hidetosaito
Password for 'https://hidetosaito@github.com': 
Counting objects: 12, done.

```

### Wie es geht…

Rufen Sie die AWS-Webkonsole auf und navigieren Sie zu OpsWorks. Dann erstellen Sie zuerst einen OpsWorks Stack und eine OpsWorks Ebene.
Der OpsWorks Stack

Der OpsWorks-Stack ist der Container des OpsWorks-Frameworks. Der OpsWorks-Stack kann eine VPC verknüpfen. Sie können Ihre eigene VPC oder die Standard-VPC verwenden. Beachten Sie, dass aus Kompatibilitätsgründen Chef `11.10` wählen, um das `CloudWatchLogs` Rezept zu verwenden und nicht zu vergessen, die benutzerdefinierten Chef Kochbücher zu aktivieren und Ihr GitHub Repository wie folgt anzugeben:

![Creating-OpsWorks-stack](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_12.jpg)

### Die OpsWorks-Schicht

Innerhalb des OpsWorks-Stacks können Sie eine oder mehrere OpsWorks-Ebenen haben. Eine Schicht kann einen oder viele Chef Rezepte verknüpfen. Lassen Sie uns eine benutzerdefinierte Ebene erstellen und mit dem `CloudWatchLogs` Rezept assoziieren:

1. Rufen Sie OpsWorks UI auf, um eine benutzerdefinierte Ebene zu erstellen und legen Sie den Layernamen wie folgt ein:
![Creating-the-OpsWorks-layer](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_13.jpg)
Creating the OpsWorks layer

2. Dann öffnen Sie die Rezept-Seite, wie im folgenden Screenshot gezeigt:
![Recipes-settings-page](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_14.jpg)

3. Fügen Sie dann die `logs::config` hinzu und `logs::install` von Rezepten, um ein Lifecycle-Ereignis einzurichten:
![Associate-recipes](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_15.jpg)

### Anpassen der IAM-Rolle

Um ein Protokoll an den `CloudWatchLogs` Dienst zu senden, müssen Sie der IAM-Rolle die Berechtigung erteilen. Rufen Sie die AWS IAM-Konsole auf und wählen Sie `aws-opsworks-ec2-role` Rolle.

Die Rolle `aws-opsworks-ec2` Rolle wird standardmäßig mit dem OpsWorks-Stack erstellt. Wenn Sie eine andere Rolle verwenden, müssten Sie die OpsWorks Stack-Einstellung ändern, um Ihre Rolle zu wählen.

![new-role](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_16.jpg)

Fügen Sie dann die `CloudWatchLogsFullAccess`-Richtlinie hinzu, wie im folgenden Screenshot gezeigt:

![attach-policy](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_17.jpg)

Fügen Sie dann die CloudWatchLogsFullAccess-Richtlinie hinzu, wie im folgenden Screenshot gezeigt:

![aws-instances](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_18.jpg)

Nach wenigen Minuten ist Ihr Instanzzustand online, was bedeutet, dass die Einführung einer EC2-Instanz und die Installation des `CloudWatchLogs`-Agenten abgeschlossen ist:
![aws-my-test-layer](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_19.jpg)

Jetzt können Sie einige Logs auf der AWS CloudWatchLogs Konsole sehen, wie im folgenden Screenshot gezeigt:

![aws-stack-log](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_20.jpg)

### Wie es funktioniert…

Sobald die OpsWorks-Instanz gestartet ist, wird sie auf die zugehörige OpsWorks-Ebene verweisen, um Chef-Rezepte im jeweiligen Lifecycle-Event auszuführen, wie folgt:

|Lifecycle event|Timing|
| :---: | :---:|
|Setup|Nach dem Beenden des Bootens|
|Configure|Beim Betreten oder Verlassen des Online-Zustandes, assoziieren oder disassociating eine Elastische IP, Befestigung oder Ablösung von Elastic Load Balancer|
|Deploy|Bereitstellen der Anwendung (nicht benutzerdefinierte Ebene)|
|Undeploy|Beim Löschen einer Anwendung (nicht benutzerdefinierte Ebene)|
|Shutdown|Vor dem Herunterfahren einer Instanz|

Wiederum hat der OpsWorks-Stack eine oder mehrere OpsWorks-Ebenen. Darüber hinaus kann jede Schicht eine oder mehrere benutzerdefinierte Chef Rezepte zuordnen. Daher sollten Sie die Ebene als Anwendungsrolle definieren, wie z.B Frontend, Backend, Datenspeicher und so weiter.

![opsworks-layer](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_06_21.jpg)

Für das Kubernetes-Setup sollte es wie folgt definiert werden:

*      Die Kubernetes Meisterschicht
*      Die Kubernetes-Knotenschicht
*      Die etcd Schicht

Diese Chef-Rezepte werden im nächsten Abschnitt beschrieben.

### Siehe auch

In diesem Rezept haben wir den OpsWorks Service eingeführt, der Ihren Stack und Layer definieren kann. In diesem Rezept haben wir das CloudWatchLogs Chef Rezept als Beispiel verwendet. Allerdings kann Kubernetes auch automatisiert werden, um den Agenten über das OpsWorks Chef Rezept zu installieren. Es wird auch in den folgenden Rezepten dieses Kapitels beschrieben: