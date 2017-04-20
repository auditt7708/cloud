In der vorangegangenen anleitung sahen wir ein Beispiel dafür, wie Docker zum Testen in einer lokalen Dev- und QA-Umgebung verwendet werden kann. Schauen wir uns ein end-to-end Beispiel an, um zu sehen, wie Docker jetzt in der CI/CD-Umgebung verwendet wird. In diesem Rezept sehen wir, wie wir Shippable (http://www.shippable.com/) nutzen können, um CI/CD auszuführen und auf der OpenShift-Umgebung von Red Hat (https://openshift.redhat.com) zu implementieren.

Shippable ist eine SaaS-Plattform, mit der Sie ganz einfach Continuous Integration/Deployment zu Ihrem GitHub und Bitbucket (Git) Repositories hinzufügen können, die komplett auf Docker aufbauen ist. 
Shippable nutzt Baustellen, die Docker-basierte Container sind, um Workloads auszuführen. Shippable unterstützt viele Sprachen wie Ruby, Python, Node.js, Java, Scala, PHP, Go und Clojure. 
Die build minions sind Ubuntu 12.04 LTS und Ubuntu 14.04. Sie haben auch Unterstützung hinzugefügt, um benutzerdefinierte Images von Docker Hub als Minions zu verwenden. 
Benutzbares CI benötigt Informationen über das Projekt und baut Anweisungen in einer `yml` Datei namens `shippable.yml`, die Sie in Ihrem Quellcode-Repo zur Verfügung stellen müssen. Die `yml` Datei enthält die folgenden Anweisungen:

* `build_image`: Dies ist ein Docker-Bild zu verwenden, um zu bauen

* `language`: Hier wird die Programmiersprache angezeigt
* `versions` : Sie können verschiedene Versionen der Sprache angeben, um in einer einzigen Build-Anweisung getestet zu werden.

* before_install : Dies sind die Anweisungen vor dem Ausführen des Builds
* script : Dies ist ein Binär/Skript, um den Test auszuführen
* after_success : Das sind Anweisungen, nachdem der Build gelingt; Dies wird verwendet, um den Einsatz auf PaaS wie Heroku, Amazon Elastic Beanstalk, AWS OpsWorks, Google App Engine, Red Hat OpenShift und andere durchzuführen.

Red Hat's OpenShift ist eine PaaS-Plattform für Ihre Bewerbung. Derzeit nutzt es nicht-Docker-basierte Container-Technologie, um die Anwendung zu hosten, aber die nächste Version von OpenShift (https://github.com/openshift/origin) wird auf Kubernetes und Docker gebaut. Das sagt uns das Tempo, in dem Docker in der Unternehmenswelt verabschiedet wird. Wir werden sehen, wie man OpenShift v3 später in diesem Kapitel einrichtet.

Für dieses Rezept verwenden wir den gleichen Beispielcode, den wir in der vorherigen Rezeptur verwendet haben, um zuerst auf Shippable zu testen und dann auf OpenShift einzusetzen.

### Fertig werden
1. Erstellen Sie ein Konto auf Shippable (https://www.shippable.com/).

2. Gabel die Flasche Beispiel aus https://github.com/openshift/flask-example.

3. Erstellen Sie eine App auf OpenShift für das gegabelte Repository mit den folgenden Schritten:

3. 1. Erstellen Sie ein Konto (https://www.openshift.com/app/account/new) auf OpenShift und melden Sie sich an.
