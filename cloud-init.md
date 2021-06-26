---
title: cloud-init
description: 
published: true
date: 2021-06-09T15:00:53.503Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:00:47.775Z
---

# Cloud Init

## Boot Stages

* Generator
* Local
* Network
* Config
* Final

### Generator

Beim Booten unter systemd wird ein Generator ausgeführt, der festlegt, ob cloud-init.target in die Startziele aufgenommen werden soll. Standardmäßig aktiviert dieser Generator Cloud-Init. Cloud-init wird nicht aktiviert, wenn:

Die Datei /etc/cloud/cloud-init.disabledexistiert
Die Kernel-Befehlszeile wie in /proc/cmdlineenthält cloud-init=disabled. Bei der Ausführung in einem Container wird die Kernel-Befehlszeile nicht berücksichtigt, aber Cloud-Init liest eine Umgebungsvariable, die KERNEL_CMDLINEan ihrer Stelle benannt ist.
Diese Mechanismen zum Deaktivieren von Cloud-Init zur Laufzeit sind derzeit nur in systemd vorhanden.

### Local

systemd service    cloud-init-local.service
running     so schnell wie möglich mit /montiertem Lese- / Schreibzugriff
Blöcke    So viel Boot wie möglich muss das Netzwerk blockieren
Module    keiner

Der Zweck der lokalen Bühne ist:

Suchen Sie nach „lokalen" Datenquellen.
Anwenden der Netzwerkkonfiguration auf das System (einschließlich „Fallback")
In den meisten Fällen macht diese Phase nicht viel mehr. Es findet die Datenquelle und bestimmt die zu verwendende Netzwerkkonfiguration. Diese Netzwerkkonfiguration kann stammen von:

Datenquelle : Von der Cloud bereitgestellte Netzwerkkonfiguration über Metadaten
Fallback : Das Fallback-Netzwerk von Cloud-Init besteht darin, das Äquivalent zu „dhcp on eth0" zu rendern, dem historisch beliebtesten Mechanismus für die Netzwerkkonfiguration eines Gasts
none : Die Netzwerkkonfiguration kann deaktiviert werden, indem die Datei /etc/cloud/cloud.cfgmit dem Inhalt geschrieben wird: network: {config: disabled}
Wenn dies der erste Start einer Instanz ist, wird die ausgewählte Netzwerkkonfiguration gerendert. Dies umfasst das Löschen aller vorherigen (veralteten) Konfigurationen, einschließlich der dauerhaften Gerätenamen mit alten Mac-Adressen.

Diese Phase muss das Aufrufen des Netzwerks blockieren, da möglicherweise bereits eine veraltete Konfiguration angewendet wurde. Dies kann negative Auswirkungen haben, z. B. DHCP-Hooks oder die Übertragung eines alten Hostnamens. Es würde auch das System in einen ungeraden Zustand versetzen, von dem es wiederhergestellt werden kann, da es dann möglicherweise Netzwerkgeräte neu starten muss.

Cloud-init wird dann beendet und erwartet, dass der fortgesetzte Start des Betriebssystems die Netzwerkkonfiguration wie konfiguriert startet.

Hinweis : In der Vergangenheit waren lokale Datenquellen nur solche, die ohne Netzwerk verfügbar waren (z. B. 'ConfigDrive'). Wie aus den jüngsten Ergänzungen der DigitalOcean-Datenquelle hervorgeht, können in dieser Phase sogar Datenquellen betrieben werden, für die ein Netzwerk erforderlich ist.


### Network

systemd service    cloud-init.service
läuft    nachdem die lokale Bühne und das konfigurierte Netzwerk aktiv sind
Blöcke    so viel wie möglich vom verbleibenden Boot
Module    cloud_init_modules in/etc/cloud/cloud.cfg
In dieser Phase müssen alle konfigurierten Netzwerke online sein, da alle gefundenen Benutzerdaten vollständig verarbeitet werden. Verarbeitung bedeutet hier:

Abrufen eines #includeoder #include-once(rekursiv) einschließlich http
Komprimieren Sie alle komprimierten Inhalte
Führen Sie einen gefundenen Part-Handler aus.
Diese Phase läuft die disk_setupund mountsModule , die partitionieren können und das Format Platten und konfigurieren Bereitstellungspunkte (wie in /etc/fstab). Diese Module können nicht früher ausgeführt werden, da sie möglicherweise Konfigurationseingaben von Quellen erhalten, die nur über das Netzwerk verfügbar sind. Beispielsweise kann ein Benutzer Benutzerdaten in einer Netzwerkressource bereitgestellt haben, die beschreiben, wie lokale Bereitstellungen durchgeführt werden sollen.

In einigen Clouds wie Azure werden in dieser Phase Dateisysteme erstellt, die bereitgestellt werden sollen, einschließlich solcher, in denen veraltete Verweise (vorherige Instanz) enthalten sind /etc/fstab. Daher sollten /etc/fstabandere Einträge als die für die Ausführung von Cloud-Init erforderlichen erst nach dieser Phase vorgenommen werden.

Zu diesem Zeitpunkt wird ein Part-Handler ausgeführt, ebenso wie Boot-Hooks einschließlich Cloud-Konfiguration bootcmd. Der Benutzer dieser Funktionalität muss sich darüber im Klaren sein, dass das System gerade gestartet wird, wenn sein Code ausgeführt wird.

### Config

systemd service    cloud-config.service
läuft    nach dem Netzwerk
Blöcke    nichts
Module    cloud_config_modules in/etc/cloud/cloud.cfg
In dieser Phase werden nur Konfigurationsmodule ausgeführt. Hier werden Module ausgeführt, die sich nicht wirklich auf andere Startphasen auswirken.

### Final

systemd service    cloud-final.service
läuft    als letzter Teil des Bootes (traditionelles "rc.local")
Blöcke    nichts
Module    cloud_final_modules in/etc/cloud/cloud.cfg
Diese Phase wird so spät wie möglich gestartet. Alle Skripte, die ein Benutzer nach der Anmeldung bei einem System gewohnt ist, sollten hier korrekt ausgeführt werden. Dinge, die hier laufen, schließen ein

Paketinstallationen
Konfigurationsmanagement-Plugins (Marionette, Koch, Salt-Minion)
Benutzerskripte (einschließlich runcmd).
Bei Skripten außerhalb von Cloud-Init, die warten möchten, bis Cloud-Init abgeschlossen ist, kann der Unterbefehl dazu beitragen, externe Skripte zu blockieren, bis Cloud-Init ausgeführt wird, ohne dass eigene Abhängigkeitsketten für Systemeinheiten geschrieben werden müssen. Weitere Informationen finden Sie im Status .cloud-init status

## CLI-Schnittstelle

erwenden Sie für die neueste Liste der Unterbefehle und Argumente die --help Option von cloud-init . Dies kann gegen Cloud-Init selbst oder einen seiner Unterbefehle verwendet werden.

```s
$ cloud-init --help
  usage: /usr/bin/cloud-init [-h] [--version] [--file FILES] [--debug] [--force]
                          {init,modules,single,query,dhclient-hook,features,analyze,devel,collect-logs,clean,status}
                          ...

  optional arguments:
  -h, --help            show this help message and exit
  --version, -v         show program's version number and exit
  --file FILES, -f FILES
                          additional yaml configuration files to use
  --debug, -d           show additional pre-action logging (default: False)
  --force               force running even if no datasource is found (use at
                          your own risk)

  Subcommands:
  {init,modules,single,query,dhclient-hook,features,analyze,devel,collect-logs,clean,status}
      init                initializes cloud-init and performs initial modules
      modules             activates modules using a given configuration key
      single              run a single module
      query               Query standardized instance metadata from the command
                          line.
      dhclient-hook       Run the dhclient hook to record network info.
      features            list defined features
      analyze             Devel tool: Analyze cloud-init logs and data
      devel               Run development tools
      collect-logs        Collect and tar all cloud-init debug info
      clean               Remove logs and artifacts so cloud-init can re-run.
      status              Report cloud-init status or wait on completion.

```

Der Rest dieses Dokuments gibt einen Überblick über die einzelnen Unterbefehle.



* [cloudinit](https://cloudinit.readthedocs.io/en/latest/)