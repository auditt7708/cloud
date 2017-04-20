Jetzt wissen wir, wie wir mit Containern und Images arbeiten können. 
Im letzten Kapitel haben wir auch gesehen, wie man Container verknüpft und Daten zwischen dem Host und anderen Containern austauscht. 
Wir haben auch gesehen, wie Container von einem Host mit anderen Containern von anderen Hosts kommunizieren können.

Nun schauen wir uns verschiedene Anwendungsfälle von Docker an. Lass uns hier ein paar auflisten

* **Schnelles Prototyping von Ideen**: Das ist einer meiner Lieblings-Use Cases. Sobald wir eine Idee haben, ist es sehr einfach, es mit Docker zu prototypen. Alles, was wir tun müssen, ist die Einrichtung von Containern, um alle Backend-Dienste, die wir benötigen, und verbinden sie zusammen. Zum Beispiel, um eine LAMP-Anwendung einzurichten, erhalten Sie die Web- und DB-Server und verknüpfen sie, wie wir im vorherigen Kapitel gesehen haben.

* **Zusammenarbeit und Vertrieb**: GitHub ist eines der besten Beispiele für die Zusammenarbeit und den Vertrieb des Codes. Ähnlich bietet Docker Funktionen wie Dockerfile, Registry und Import/Export, um mit anderen zu teilen und zusammenzuarbeiten. Wir haben das alles in früheren Kapiteln abgedeckt.

* **Continuous Integration (CI)**: Die folgende Definition auf der Website von Martin Fowler (http://www.martinfowler.com/articles/continuousIntegration.html) deckt alles ab:

"Continuous Integration ist eine Software-Entwicklungspraxis, in der Mitglieder eines Teams ihre Arbeit häufig integrieren, in der Regel jede Person mindestens täglich integriert - was zu mehreren Integrationen pro Tag führt. Jede Integration wird durch einen automatisierten Build (einschließlich Test) überprüft, um Integrationsfehler zu erkennen So schnell wie möglich Viele Teams finden, dass dieser Ansatz zu deutlich reduzierten Integrationsproblemen führt und es einem Team ermöglicht, kohärente Software schneller zu entwickeln. Dieser Artikel ist ein schneller Überblick über die kontinuierliche Integration, die die Technik und den aktuellen Gebrauch zusammenfasst. "


Mit Rezepten aus anderen Kapiteln können wir eine Umgebung für CI mit Docker erstellen. Sie können Ihre eigene CI-Umgebung erstellen oder Dienste von Unternehmen wie Shippable und Drone erhalten. Wir werden sehen, wie Shippable und Drone für CI Arbeit später in diesem Kapitel verwendet werden können. Lieferbar ist nicht eine gehostete Lösung aber Drone ist, die Ihnen eine bessere Kontrolle geben kann. Ich dachte, es wäre hilfreich, wenn ich hier von beiden rede:

* **Continuous Delivery (CD)**: Der nächste Schritt nach CI ist Continuous Delivery, mit dem wir unseren Code schnell und zuverlässig unseren Kunden, der Cloud und anderen Umgebungen ohne manuelle Arbeit bereitstellen können. In diesem Kapitel werden wir sehen, wie wir automatisch eine App auf Red Hat OpenShift über Shippable CI einsetzen können.

* **Plattform-as-a-Service (PaaS)**: Docker kann verwendet werden, um Ihre eigenen PaaS zu bauen. Es kann mit Tools / Plattformen wie OpenShift, CoreOS, Atomic, Tsuru und so weiter eingesetzt werden. Später in diesem Kapitel werden wir sehen, wie man PaaS mit OpenShift Origin (https://www.openshift.com/products/origin) einrichtet.
### Übersicht

* [Testing mit Docker](../docker-praktischer-einsatz-testen)

* [Einrichten von  CI/CD mit Shippable und Red Hat OpenShift](../docker-praktischer-einsatz-cicd-shippable-openshift)

* [Einrichten CI/CD mit Drone](../docker-praktischer-einsatz-cicd-drone)

* [Einrichten vom PaaS mit OpenShift Origin](../docker-praktischer-einsatz-paas-openshift-origin)

* [Erstellen und Bereitstellen einer App auf OpenShift v3 aus dem Quellcode](../docker-praktischer-einsatz-app-openshift)

* [Konfigurieren von Docker als Hypervisor-Treiber für Openstack](../docker-praktischer-einsatz-openstack)