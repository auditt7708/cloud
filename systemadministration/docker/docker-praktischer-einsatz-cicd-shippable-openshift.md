---
title: docker-praktischer-einsatz-cicd-shippable-openshift
description: 
published: true
date: 2021-06-09T15:15:11.434Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:15:05.620Z
---

# Docker ci/cd mit shippable und openshift

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

## Fertig werden

1.Erstellen Sie ein Konto auf Shippable (https://www.shippable.com/).

2.Gabel die Flasche Beispiel aus https://github.com/openshift/flask-example.

3.Erstellen Sie eine App auf OpenShift für das gegabelte Repository mit den folgenden Schritten:

3.1. Erstellen Sie ein Konto (https://www.openshift.com/app/account/new) auf OpenShift und melden Sie sich an.

3.2. Wählen Sie Python 2.7 Cartridge für die Anwendung.

3.3. Aktualisiere den gewünschten öffentlichen URL-Bereich. Geben Sie im Abschnitt Quellcode die URL unseres gegabelten Repo ein. Für dieses Beispiel habe ich die `blueprint` und `https://github.com/nkhare/flask-example` angegeben:

![openshift-bueprint](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_02.jpg)

3.4. Klicken Sie auf Create Application, um die neue App zu erstellen. Einmal erstellt, sollten Sie in der Lage sein, auf die öffentliche URL zuzugreifen, die wir im vorherigen Schritt erwähnt haben.

Sobald die App erstellt ist, bietet OpenShift eine Möglichkeit, den Quellcode für diese App im Abschnitt "Code ändern" zu verwalten / zu aktualisieren. Da wir die App mit Shippable einsetzen wollen, müssen wir diese Anweisungen nicht befolgen.

4.Klonen Sie das gegabelte Repository auf das lokale System:
`$ git clone git@github.com:nkhare/flask-example.git`

5.Wir verwenden das gleiche Blaupause-Beispiel, das wir früher verwendet haben. Um dies zu tun, folgen Sie diesen Anweisungen:
 5.1. Klonen Sie das flask-Repository:
 5.2. Kopiren das blueprint example:
       `$ cp -Rv flask/examples/blueprintexample/* flask-example/wsgi/`

6.Aktualisieren Sie die `flask-example/wsgi/application`, um das `app`-Modul aus dem blueprintexample-Modul zu importieren. Also, die letzte Zeile in der `blueprintexample` `flask-example/wsgi/application` Anwendungsdatei sieht wie folgt aus
`from blueprintexample import app as application`

7.Fügen Sie die `requirements.txt` Datei mit dem folgenden Inhalt auf der obersten Ebene des Flaschen-Beispiel-Repository hinzu:

```s
flask
pytest
```

8.Fügen Sie die Datei `shippable.yml` mit folgendem Inhalt hinzu:

```s
language: python

python:
  - 2.6
  - 2.7

install:
  - pip install -r requirements.txt

# Make folders for the reports
before_script:
  - mkdir -p shippable/testresults
  - mkdir -p shippable/codecoverage

script:
  - py.test

archive: true
```

9.Commit den Code und `pushe` ihn in dein gegabeltes Repository.

## Wie es geht…

1. Melden Sie sich bei Shippable an.

2. Nach der Anmeldung klicken Sie auf `SYNC ACCOUNT`, um Ihr gegliedertes Repository aufzurufen, falls es noch nicht gelistet ist. Finden und aktivieren Sie das Repo, das Sie erstellen und Tests ausführen möchten. Für dieses Beispiel wählte ich `flask-example` aus meinem GitHub-Repos. Nachdem du es ermöglicht hast, solltest du so etwas wie folgendes sehen:
![shippable-accound](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_03.jpg)

3. Klicken Sie auf die Play-Taste und wählen Sie Zweig zu bauen. Für dieses Rezept wählte ich Meister:

Wenn der Build erfolgreich ist, dann wirst du das Erfolgssymbol sehen.

Wenn Sie das nächste Mal in Ihrem Repository begehen, wird ein Build auf Shippable ausgelöst und der Code wird getestet. Jetzt, um Continuous Deployment auf OpenShift durchzuführen, folgen wir den Anweisungen auf der Shippable Website (http://docs.shippable.com/deployment/openshift/):

1. Holen Sie sich den Deployment Key aus Ihrem Shippable Dashboard (auf der rechten Seite, unter Repos):

![shippable-dashboard](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_20.jpg)

2. Kopiere es unter die (https://openshift.redhat.com/app/console/settings) Einstellungen | Public Keys Abschnitt auf OpenShift wie folgt:

![openshift-settings](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_04.jpg)

3. Holen Sie sich den Quellcode-Repository-Link von der OpenShift-Applikationsseite, die im nächsten Schritt als OPNESHIFT_REPO verwendet wird:
![openshift-applications](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_21.jpg)

4. Nachdem der Bereitstellungsschlüssel installiert ist, aktualisieren Sie die Datei shippable.yml wie folgt:

```
env: 
  global: 
    - OPENSHIFT_REPO=ssh://545ea4964382ec337f000009@blueprint-neependra.rhcloud.com/~/git/blueprint.git 

language: python 

python: 
  - 2.6 
  - 2.7 

install: 
  - pip install -r requirements.txt 

# Make folders for the reports 
before_script: 
  - mkdir -p shippable/testresults 
  - mkdir -p shippable/codecoverage 
  - git remote -v | grep ^openshift || git remote add openshift $OPENSHIFT_REPO 
  - cd wsgi 

script: 
  - py.test 

after_success: 
  - git push -f openshift $BRANCH:master 

archive: true 
```

`OPENSHIFT_REPO` sollte die App, die Sie mit OpenShift eingesetzt haben, widerspiegeln. Es wird sich von dem unterscheiden, was in diesem Beispiel gezeigt wird.

5. Beide diese Änderungen und schieben sie zu GitHub. Sie sehen einen Build auf Shippable ausgelöst und eine neue App, die auf OpenShift eingesetzt wird.

6. Besuchen Sie die Homepage Ihrer App, und Sie sollten den aktualisierten Inhalt sehen.

### Wie es funktioniert…

Bei jeder Build-Anweisung verschiebt Shippable je nach Bild- und Sprachtyp, der in der Datei `shippable.yml` angegeben ist, neue Container und führt den Build aus, um Tests durchzuführen. In unserem Fall wird Shippable zwei Container abspinnen, eine für Python 2.6 und die andere für Python 2.7. Shippable fügt ein Webhook zu Ihrem GitHub Repository hinzu, wie folgt, wenn Sie es mit ihnen registrieren:

![flask-example](https://www.packtpub.com/graphics/9781788297615/graphics/4862OS_05_05.jpg)

Also jedes Mal, wenn eine Änderung an GitHub begangen wird, wird ein Build auf Shippable ausgelöst und nach dem Erfolg wird es auf OpenShift eingesetzt.

### Siehe auch

Detaillierte Dokumentation finden Sie auf der Website von Shippable unter http://docs.shippable.com/

