# Docker

Inhaltsverzeichnis

## [Docker unter CentOS7](https://coderleaf.wordpress.com/2017/02/10/run-docker-as-user-on-centos7/)

`usermod -aG docker $(whoami)`

Die Datei _/etc/docker/daemon.json_ anpassen um mit einem Normalen Benutzer zu benutzen.

```json
{
    "live-restore": true,
    "group": "docker"
}
```

## Docker Sorage unter CentOS 7

Notwendige Pakete installieren

`sudo yum install yum-utils device-mapper-persistent-data lvm2`

Docker activiren und starten und zustand Prüfen.

```s
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

Image löschen

`docker rmi`

`docker image rm ID`

Image Speicher und Wiedrherstellen

`docker save -o /mein/Ziel/image.tar`

`docker load -i /meinZeil/image.tar`

Alle abgeleiteten Images löschen

`--no-prune`

## Adminstration

> Ohne angabe bei `CMD` von etwas was auch weiter leuft wird sich der Container sofort beenden
> Images die mit _<None>_ angezeit werden nenen sich Dangling Images und müssen mit dem Schalter `-a` aufgrufen werden

## Datein und Verzeichnisse

~/.docker/daemon.json = json Konfiguration für einen Benutzer

## [Networkking](../docker-networking)

* [weave](../docker-networking-weave-net-install-konfiguration)

* [UI server for Contiv](https://github.com/rhim/auth_proxy)

## [docker-einleitung-und-Installation](../docker-einleitung-und-Installation)

## [docker-einleitung-und-Installation-anforderungen](../docker-einleitung-und-Installation-anforderungen)

## [docker-einleitung-und-Installation-Befehlszeile](../docker-einleitung-und-Installation-Befehlszeile)

## [docker-einleitung-und-Installation-build](../docker-einleitung-und-Installation-build)

## [docker-einleitung-und-Installation-hosts-maschine](../docker-einleitung-und-Installation-hosts-maschine)

## [docker-einleitung-und-Installation-installieren](../docker-einleitung-und-Installation-installieren)

## [docker-einleitung-und-Installation-user](../docker-einleitung-und-Installation-user)

## [docker-benutzen-image-listing-suche](../docker-benutzen-image-listing-suche)

## [docker-api-client-remote](../docker-api-client-remote)

## [docker-api-container-remote](../docker-api-container-remote)

## [docker-api-daemon-remote](../docker-api-daemon-remote)

## [docker-api-image-operations-remote](../docker-api-image-operations-remote)

## [docker-api-programmierung](../docker-api-programmierung)

## [docker-api-remote-sicherheit](../docker-api-remote-sicherheit)

## [docker-arbeiten-images-apache-dockerfile](../docker-arbeiten-images-apache-dockerfile)

## [docker-arbeiten-images-auto-github-bitbucket](../docker-arbeiten-images-auto-github-bitbucket)

## [docker-arbeiten-images-debootstrap](../docker-arbeiten-images-debootstrap)

## [docker-arbeiten-images-dockerfiles-build](../docker-arbeiten-images-dockerfiles-build)

## [docker-arbeiten-images-exportieren](../docker-arbeiten-images-exportieren)

## [docker-arbeiten-images-firefox-example](../docker-arbeiten-images-firefox-example)

## [docker-arbeiten-images-geschichte](../docker-arbeiten-images-geschichte)

## [docker-arbeiten-images-importieren](../docker-arbeiten-images-importieren)

## [docker-arbeiten-images-konto-docker-hub](../docker-arbeiten-images-konto-docker-hub)

## [docker-arbeiten-images-loeschen](../docker-arbeiten-images-loeschen)

## [docker-arbeiten-images-private-registry](../docker-arbeiten-images-private-registry)

## [docker-arbeiten-images-supermin](../docker-arbeiten-images-supermin)

## [docker-arbeiten-images-veroefendlichen](../docker-arbeiten-images-veroefendlichen)

## [docker-arbeiten-images-visual-abhaengigkeiten](../docker-arbeiten-images-visual-abhaengigkeiten)

## [docker-arbeiten-images-von-container](../docker-arbeiten-images-von-container)

## [docker-arbeiten-images-wordpress-example](../docker-arbeiten-images-wordpress-example)

## [docker-arbeiten-mit-docker-images](../docker-arbeiten-mit-docker-images)

## [docker-arbeiten-mit-docker](../docker-arbeiten-mit-docker)

## Docker Benutzen

## [docker-benutzen-container-exposing-ports](../docker-benutzen-container-exposing-ports)

## [docker-benutzen-container-labeling-filtering](../docker-benutzen-container-labeling-filtering)

## [docker-benutzen-container-loeschen](../docker-benutzen-container-loeschen)

## [docker-benutzen-container-logs](../docker-benutzen-container-logs)

## [docker-benutzen-container-lowlevel-info](../docker-benutzen-container-lowlevel-info)

## [docker-benutzen-container-neuer-prozess](../docker-benutzen-container-neuer-prozess)

## [docker-benutzen-container-privilegierter-zugriff](../docker-benutzen-container-privilegierter-zugriff)

## [docker-benutzen-container-regeln-neustart](../docker-benutzen-container-regeln-neustart)

## [docker-benutzen-container-starten](../docker-benutzen-container-starten)

## [docker-benutzen-container-stoppen](../docker-benutzen-container-stoppen)

## [docker-benutzen-container-zugriff-host](../docker-benutzen-container-zugriff-host)

## [docker-benutzen-image-pulling](../docker-benutzen-image-pulling)

## [docker-benutzen-images-auflisten](../docker-benutzen-images-auflisten)

## Docker Daten Management

## [docker-daten-mgmnt-lamp-example](../docker-daten-mgmnt-lamp-example)

## [docker-daten-mgmnt-multihost-flanell](../docker-daten-mgmnt-multihost-flanell)

## [docker-daten-mgmnt-net-ipv6](../docker-daten-mgmnt-net-ipv6)

## [docker-daten-mgmnt-network-remote](../docker-daten-mgmnt-network-remote)

## [docker-daten-mgmnt-verknuepfen](../docker-daten-mgmnt-verknuepfen)

## [docker-daten-mgmnt-verwalten](../docker-daten-mgmnt-verwalten)

## [docker-daten-mgmnt](../docker-daten-mgmnt)

## [docker-networking](../docker-networking)

## [docker-networking-plugins](../docker-networking-plugins)

## [docker-networking-weave-net-benutzen](../docker-networking-weave-net-benutzen)

## [docker-networking-weave-net-dns](../docker-networking-weave-net-dns)

## [docker-networking-weave-net-install-konfiguration](../docker-networking-weave-net-install-konfiguration)

## [docker-networking-weave-net-ipam](../docker-networking-weave-net-ipam)

## [docker-networking-weave-net-plugins](../docker-networking-weave-net-plugins)

## [docker-networking-weave-net-sicherheit](../docker-networking-weave-net-sicherheit)

## [docker-networking-weave-net](../docker-networking-weave-net)

## Docker Orcestration

## [docker-orchestration-atomic-cockpit](../docker-orchestration-atomic-cockpit)

## [docker-orchestration-atomic-host](../docker-orchestration-atomic-host)

## [docker-orchestration-atomic-speicher](../docker-orchestration-atomic-speicher)

## [docker-orchestration-atomic-update-rollback](../docker-orchestration-atomic-update-rollback)

## [docker-orchestration-compose](../docker-orchestration-compose)

## [docker-orchestration-coreos](../docker-orchestration-coreos)

## [docker-Orchestration-hosting](../docker-Orchestration-hosting)

## [docker-orchestration-kubernetes-cluster](../docker-orchestration-kubernetes-cluster)

## [docker-orchestration-kubernetes-skalierung](../docker-orchestration-kubernetes-skalierung)

## [docker-orchestration-kubernetes-wordpress](../docker-orchestration-kubernetes-wordpress)

## [Docker Swarm](../docker-swarm)

## [docker-orchestration-swarm](../docker-orchestration-swarm)

## Docker Pervermence

## [docker-performence-container-ressourcennutzung](../docker-performence-container-ressourcennutzung)

## [docker-performence-cpu](../docker-performence-cpu)

## [docker-performence-leistungsueberwachung](../docker-performence-leistungsueberwachung)

## [docker-performence-netzwerkleistung](../docker-performence-netzwerkleistung)

## [docker-performence-plattenleistung](../docker-performence-plattenleistung)

## [docker-performence](../docker-performence)

## Docker Praktische einsatz

## [docker-praktischer-einsatz-app-openshift](../docker-praktischer-einsatz-app-openshift)

## [docker-praktischer-einsatz-cicd-drone](../docker-praktischer-einsatz-cicd-drone)

## [docker-praktischer-einsatz-cicd-shippable-openshift](../docker-praktischer-einsatz-cicd-shippable-openshift)

## [docker-praktischer-einsatz-openstack](../docker-praktischer-einsatz-openstack)

## [docker-praktischer-einsatz-paas-openshift-origin](../docker-praktischer-einsatz-paas-openshift-origin)

## [docker-praktischer-einsatz-testen](../docker-praktischer-einsatz-testen)

## [docker-praktischer-einsatz](../docker-praktischer-einsatz)

## Docker Registry

## [docker-registry](../docker-registry)

## Docker Sicherheit

## [docker-sicherheit](../docker-sicherheit)

## [docker-sicherheit-selinux-volume](../docker-sicherheit-selinux-volume)

## [docker-sicherheit-selinux-mac](../docker-sicherheit-selinux-mac)

## [docker-sicherheit-namespaces-hosts-container](../docker-sicherheit-namespaces-hosts-container)

## [docker-sicherheit-berechtigungen-root](../docker-sicherheit-berechtigungen-root)

## Docker Tips und Tricks

## [docker-tips-tricks-debug-eigene-bruecke](../docker-tips-tricks-debug-eigene-bruecke)

## [docker-tips-tricks-debug-images-raw](../docker-tips-tricks-debug-images-raw)

## [docker-tips-tricks-debug-mode](../docker-tips-tricks-debug-mode)

## [docker-tips-tricks-docker-source-build](../docker-tips-tricks-docker-source-build)

## [docker-tips-tricks-echtzeit-events-container](../docker-tips-tricks-echtzeit-events-container)

## [docker-tips-tricks-protokoll-driver](../docker-tips-tricks-protokoll-driver)

## [docker-tips-tricks-treiber-aendern](../docker-tips-tricks-treiber-aendern)

## [docker-hilfe-tips-tricks](../docker-hilfe-tips-tricks)

## [Docker Dienst auf Centos7](../docker-service-centos7)

## [Docker Networks auf Centos7](../docker-networking.centos7)

## [Docker Rastaya KanBan Board](../docker-projekt-rastaya)

## [Docker web2ldap](../docker-projekt-web2ldap)

## [Private Docker Projekte](../docker-projekte)

## Docker Fehlerbehebung

## [Docker Fehler](../docker-fehler)

**Quellen:**

* [DockerAndFuelPHP](http://ucf.github.io/fuelphp-crash-course)
* [dockerfiles](https://github.com/kernt/dockerfiles)
* [docker-tools](https://github.com/kernt/docker-tools)
* [Configuring Docker Remote API with TLS on CoreOS](http://blog.jameskyle.org/2014/04/coreos-docker-remote-api-tls/)
* [Remote access to Docker with TLS](https://sheerun.net/2014/05/17/remote-access-to-docker-with-tls/)
=======
# Docker

Docker Begriffe

Reposirory =
registry =

Optionen

Image löschen

`docker rmi`

`docker image rm ID`

Image Speicher und Wiedrherstellen

`docker save -o /mein/Ziel/image.tar`

`docker load -i /meinZeil/image.tar`

Alle abgeleiteten Images löschen

`--no-prune`

## Adminstration

> Ohne angabe bei `CMD` von etwas was auch weiter leuft wird sich der Container sofort beenden
> Images die mit _<None>_ angezeit werden nenen sich Dangling Images und müssen mit dem Schalter `-a` aufgrufen werden

## Datein und verzeichnisse

~/.docker/daemon.json = json Konfiguration für einen Benutzer

## [Networkking](../docker-networking)

* [weave](../docker-networking-weave-net-install-konfiguration)

* [UI server for Contiv](https://github.com/rhim/auth_proxy)

## [docker-einleitung-und-Installation](../docker-einleitung-und-Installation)

## [docker-einleitung-und-Installation-anforderungen](../docker-einleitung-und-Installation-anforderungen)

## [docker-einleitung-und-Installation-Befehlszeile](../docker-einleitung-und-Installation-Befehlszeile)

## [docker-einleitung-und-Installation-build](../docker-einleitung-und-Installation-build)

## [docker-einleitung-und-Installation-hosts-maschine](../docker-einleitung-und-Installation-hosts-maschine)

## [docker-einleitung-und-Installation-installieren](../docker-einleitung-und-Installation-installieren)

## [docker-einleitung-und-Installation-user](../docker-einleitung-und-Installation-user)

## [docker-benutzen-image-listing-suche](../docker-benutzen-image-listing-suche)

## [docker-api-client-remote](../docker-api-client-remote)

## [docker-api-container-remote](../docker-api-container-remote)

## [docker-api-daemon-remote](../docker-api-daemon-remote)

## [docker-api-image-operations-remote](../docker-api-image-operations-remote)

## [docker-api-programmierung](../docker-api-programmierung)

## [docker-api-remote-sicherheit](../docker-api-remote-sicherheit)

## [docker-arbeiten-images-apache-dockerfile](../docker-arbeiten-images-apache-dockerfile)

## [docker-arbeiten-images-auto-github-bitbucket](../docker-arbeiten-images-auto-github-bitbucket)

## [docker-arbeiten-images-debootstrap](../docker-arbeiten-images-debootstrap)

## [docker-arbeiten-images-dockerfiles-build](../docker-arbeiten-images-dockerfiles-build)

## [docker-arbeiten-images-exportieren](../docker-arbeiten-images-exportieren)

## [docker-arbeiten-images-firefox-example](../docker-arbeiten-images-firefox-example)

## [docker-arbeiten-images-geschichte](../docker-arbeiten-images-geschichte)

## [docker-arbeiten-images-importieren](../docker-arbeiten-images-importieren)

## [docker-arbeiten-images-konto-docker-hub](../docker-arbeiten-images-konto-docker-hub)

## [docker-arbeiten-images-loeschen](../docker-arbeiten-images-loeschen)

## [docker-arbeiten-images-private-registry](../docker-arbeiten-images-private-registry)

## [docker-arbeiten-images-supermin](../docker-arbeiten-images-supermin)

## [docker-arbeiten-images-veroefendlichen](../docker-arbeiten-images-veroefendlichen)

## [docker-arbeiten-images-visual-abhaengigkeiten](../docker-arbeiten-images-visual-abhaengigkeiten)

## [docker-arbeiten-images-von-container](../docker-arbeiten-images-von-container)

## [docker-arbeiten-images-wordpress-example](../docker-arbeiten-images-wordpress-example)

## [docker-arbeiten-mit-docker-images](../docker-arbeiten-mit-docker-images)

## [docker-arbeiten-mit-docker](../docker-arbeiten-mit-docker)

## Docker Benutzen

## [docker-benutzen-container-exposing-ports](../docker-benutzen-container-exposing-ports)

## [docker-benutzen-container-labeling-filtering](../docker-benutzen-container-labeling-filtering)

## [docker-benutzen-container-loeschen](../docker-benutzen-container-loeschen)

## [docker-benutzen-container-logs](../docker-benutzen-container-logs)

## [docker-benutzen-container-lowlevel-info](../docker-benutzen-container-lowlevel-info)

## [docker-benutzen-container-neuer-prozess](../docker-benutzen-container-neuer-prozess)

## [docker-benutzen-container-privilegierter-zugriff](../docker-benutzen-container-privilegierter-zugriff)

## [docker-benutzen-container-regeln-neustart](../docker-benutzen-container-regeln-neustart)

## [docker-benutzen-container-starten](../docker-benutzen-container-starten)

## [docker-benutzen-container-stoppen](../docker-benutzen-container-stoppen)

## [docker-benutzen-container-zugriff-host](../docker-benutzen-container-zugriff-host)

## [docker-benutzen-image-pulling](../docker-benutzen-image-pulling)

## [docker-benutzen-images-auflisten](../docker-benutzen-images-auflisten)

## Docker Daten Management

## [docker-daten-mgmnt-lamp-example](../docker-daten-mgmnt-lamp-example)

## [docker-daten-mgmnt-multihost-flanell](../docker-daten-mgmnt-multihost-flanell)

## [docker-daten-mgmnt-net-ipv6](../docker-daten-mgmnt-net-ipv6)

## [docker-daten-mgmnt-network-remote](../docker-daten-mgmnt-network-remote)

## [docker-daten-mgmnt-verknuepfen](../docker-daten-mgmnt-verknuepfen)

## [docker-daten-mgmnt-verwalten](../docker-daten-mgmnt-verwalten)

## [docker-daten-mgmnt](../docker-daten-mgmnt)

## [docker-networking](../docker-networking)

## [docker-networking-plugins](../docker-networking-plugins)

## [docker-networking-weave-net-benutzen](../docker-networking-weave-net-benutzen)

## [docker-networking-weave-net-dns](../docker-networking-weave-net-dns)

## [docker-networking-weave-net-install-konfiguration](../docker-networking-weave-net-install-konfiguration)

## [docker-networking-weave-net-ipam](../docker-networking-weave-net-ipam)

## [docker-networking-weave-net-plugins](../docker-networking-weave-net-plugins)

## [docker-networking-weave-net-sicherheit](../docker-networking-weave-net-sicherheit)

## [docker-networking-weave-net](../docker-networking-weave-net)

## Docker Orcestration

## [docker-orchestration-atomic-cockpit](../docker-orchestration-atomic-cockpit)

## [docker-orchestration-atomic-host](../docker-orchestration-atomic-host)

## [docker-orchestration-atomic-speicher](../docker-orchestration-atomic-speicher)

## [docker-orchestration-atomic-update-rollback](../docker-orchestration-atomic-update-rollback)

## [docker-orchestration-compose](../docker-orchestration-compose)

## [docker-orchestration-coreos](../docker-orchestration-coreos)

## [docker-Orchestration-hosting](../docker-Orchestration-hosting)

## [docker-orchestration-kubernetes-cluster](../docker-orchestration-kubernetes-cluster)

## [docker-orchestration-kubernetes-skalierung](../docker-orchestration-kubernetes-skalierung)

## [docker-orchestration-kubernetes-wordpress](../docker-orchestration-kubernetes-wordpress)

## [docker-orchestration-swarm](../docker-orchestration-swarm)

## Docker Pervermence

## [docker-performence-container-ressourcennutzung](../docker-performence-container-ressourcennutzung)

## [docker-performence-cpu](../docker-performence-cpu)

## [docker-performence-leistungsueberwachung](../docker-performence-leistungsueberwachung)

## [docker-performence-netzwerkleistung](../docker-performence-netzwerkleistung)

## [docker-performence-plattenleistung](../docker-performence-plattenleistung)

## [docker-performence](../docker-performence)

## Docker Praktische einsatz

## [docker-praktischer-einsatz-app-openshift](../docker-praktischer-einsatz-app-openshift)

## [docker-praktischer-einsatz-cicd-drone](../docker-praktischer-einsatz-cicd-drone)

## [docker-praktischer-einsatz-cicd-shippable-openshift](../docker-praktischer-einsatz-cicd-shippable-openshift)

## [docker-praktischer-einsatz-openstack](../docker-praktischer-einsatz-openstack)

## [docker-praktischer-einsatz-paas-openshift-origin](../docker-praktischer-einsatz-paas-openshift-origin)

## [docker-praktischer-einsatz-testen](../docker-praktischer-einsatz-testen)

## [docker-praktischer-einsatz](../docker-praktischer-einsatz)

## Docker Registry

## [docker-registry](../docker-registry)

## Docker Sicherheit

## [docker-sicherheit](../docker-sicherheit)

## [docker-sicherheit-selinux-volume](../docker-sicherheit-selinux-volume)

## [docker-sicherheit-selinux-mac](../docker-sicherheit-selinux-mac)

## [docker-sicherheit-namespaces-hosts-container](../docker-sicherheit-namespaces-hosts-container)

## [docker-sicherheit-berechtigungen-root](../docker-sicherheit-berechtigungen-root)

## Docker Tips und Tricks

## [docker-tips-tricks-debug-eigene-bruecke](../docker-tips-tricks-debug-eigene-bruecke)

## [docker-tips-tricks-debug-images-raw](../docker-tips-tricks-debug-images-raw)

## [docker-tips-tricks-debug-mode](../docker-tips-tricks-debug-mode)

## [docker-tips-tricks-docker-source-build](../docker-tips-tricks-docker-source-build)

## [docker-tips-tricks-echtzeit-events-container](../docker-tips-tricks-echtzeit-events-container)

## [docker-tips-tricks-protokoll-driver](../docker-tips-tricks-protokoll-driver)

## [docker-tips-tricks-treiber-aendern](../docker-tips-tricks-treiber-aendern)

## [docker-hilfe-tips-tricks](../docker-hilfe-tips-tricks)

## [Docker Dienst auf Centos7](../docker-service-centos7)

## [Docker Networks auf Centos7](../docker-networking.centos7)

## [Docker Rastaya KanBan Board](../docker-projekt-rastaya)

## [Docker web2ldap](../docker-projekt-web2ldap)

## [Private Docker Projekte](../docker-projekte)

**Quellen:**

* [DockerAndFuelPHP](http://ucf.github.io/fuelphp-crash-course)
* [dockerfiles](https://github.com/kernt/dockerfiles)
* [docker-tools](https://github.com/kernt/docker-tools)
* [Configuring Docker Remote API with TLS on CoreOS](http://blog.jameskyle.org/2014/04/coreos-docker-remote-api-tls/)
* [Remote access to Docker with TLS](https://sheerun.net/2014/05/17/remote-access-to-docker-with-tls/)
>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
* [Securing Docker’s Remote](https://dzone.com/articles/securing-docker%E2%80%99s-remote-api)