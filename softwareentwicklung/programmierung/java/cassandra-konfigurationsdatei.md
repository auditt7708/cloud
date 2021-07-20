---
title: cassandra-konfigurationsdatei
description: 
published: true
date: 2021-06-09T14:59:17.306Z
tags: 
editor: markdown
dateCreated: 2021-06-09T14:59:09.427Z
---

Cassandra-Konfigurationsdatei

## cluster_name

Der Name des Clusters. Dies wird hauptsächlich verwendet, um zu verhindern, dass Maschinen in einem logischen Cluster einem anderen beitreten.
Standardwert: 'Testcluster'

## num_tokens

Dies definiert die Anzahl der Token, die diesem Knoten im Ring zufällig zugewiesen werden. Je mehr Token im Vergleich zu anderen Knoten vorhanden sind, desto größer ist der Anteil der Daten, die dieser Knoten speichert. Sie möchten wahrscheinlich, dass alle Knoten die gleiche Anzahl von Token haben, vorausgesetzt, sie haben die gleiche Hardwarefähigkeit.

Wenn Sie dies nicht angeben, verwendet Cassandra aus Gründen der Legacy-Kompatibilität den Standardwert 1 Token und das initial_token wie unten beschrieben.

Wenn Sie initial_token angeben, wird diese Einstellung beim ersten Start des Knotens überschrieben. Bei nachfolgenden Starts gilt diese Einstellung auch dann, wenn das anfängliche Token festgelegt ist.

Wenn Sie bereits einen Cluster mit 1 Token pro Knoten haben und auf mehrere Token pro Knoten migrieren möchten, lesen Sie http://wiki.apache.org/cassandra/Operations

Standardwert: 256

## allocate_tokens_for_keyspace

Diese Option ist standardmäßig auskommentiert.

Löst die automatische Zuweisung von num_tokens-Token für diesen Knoten aus. Der Zuordnungsalgorithmus versucht, Token so auszuwählen, dass die replizierte Last über die Knoten im Datencenter für den Replikationsfaktor optimiert wird.

Die jedem Knoten zugewiesene Last ist nahezu proportional zu seiner Anzahl von Knoten.

Wird nur mit dem Murmur3Partitioner unterstützt.

Der Replikationsfaktor wird über die Replikationsstrategie bestimmt, die vom angegebenen Schlüsselbereich verwendet wird.

Standardwert: KEYSPACE

## allocate_tokens_for_local_replication_factor

Diese Option ist standardmäßig auskommentiert.

Der Replikationsfaktor wird unabhängig vom Schlüsselbereich oder Datencenter explizit festgelegt. Dies ist der Replikationsfaktor innerhalb des Rechenzentrums wie bei NTS.

Standardwert: 3

## initial_token

Diese Option ist standardmäßig auskommentiert.

Mit initial_token können Sie Token manuell angeben. Während Sie es mit vnodes (num_tokens> 1, oben) verwenden können - in diesem Fall sollten Sie eine durch Kommas getrennte Liste bereitstellen -, wird es hauptsächlich verwendet, wenn Sie Knoten zu älteren Clustern hinzufügen, für die vnodes nicht aktiviert sind.

## hinted_handoff_enabled

Siehe [HintedHandoff](http://wiki.apache.org/cassandra/HintedHandoff).
Kann global aktiviert sein, entweder "wahr" oder "falsch"

Standardwert: true

hinted_handoff_disabled_datacenters
Diese Option ist standardmäßig auskommentiert.

Wenn hinted_handoff_enabled true ist, eine schwarze Liste von Rechenzentren, die keine angedeutete Übergabe durchführen

Standardwert (komplexe Option) :

```s
#    - DC1
#    - DC2
```

## max_hint_window_in_ms

Dies definiert die maximale Zeit, die ein toter Host benötigt, um Hinweise zu generieren. Nachdem es so lange tot war, werden neue Hinweise dafür erst erstellt, wenn es lebend gesehen und wieder untergegangen ist.

Standardwert: 10800000 # 3 Stunden

## hinted_handoff_throttle_in_kb

Maximale Drosselung in KB pro Sekunde und Liefer-Thread. Dies wird proportional zur Anzahl der Knoten im Cluster reduziert. (Wenn der Cluster zwei Knoten enthält, verwendet jeder Übermittlungsthread die maximale Rate. Wenn drei vorhanden sind, wird jeder auf die Hälfte des Maximums gedrosselt, da wir davon ausgehen, dass zwei Knoten gleichzeitig Hinweise liefern.)

Standardwert: 1024

## max_hints_delivery_threads

Anzahl der Threads, mit denen Hinweise geliefert werden sollen; Erhöhen Sie diese Anzahl, wenn Sie Multi-DC-Bereitstellungen haben, da die Cross-DC-Übergabe tendenziell langsamer ist

Standardwert: 2

## hints_directory

Diese Option ist standardmäßig auskommentiert.

Verzeichnis, in dem Cassandra Hinweise speichern soll. Wenn nicht festgelegt, lautet das Standardverzeichnis $ CASSANDRA_HOME / data / hints.

Standardwert: / var / lib / cassandra / hints

## hints_flush_period_in_ms

Wie oft sollten Hinweise von den internen Puffern auf die Festplatte geleert werden? Wird nicht auslösen fsync.

Standardwert: 10000

## max_hints_file_size_in_mb

Maximale Größe für eine einzelne Hinweisdatei in Megabyte.

Standardwert: 128

## hints_compression

Diese Option ist standardmäßig auskommentiert.

Komprimierung für die Hinweisdateien. Wenn nicht angegeben, werden Hinweisdateien unkomprimiert geschrieben. LZ4-, Snappy- und Deflate-Kompressoren werden unterstützt.

Standardwert (komplexe Option) :

```s
#   - class_name: LZ4Compressor
#     parameters:
#         -
```

## batchlog_replay_throttle_in_kb

Maximale Drossel in KBs pro Sekunde, insgesamt. Dies wird proportional zur Anzahl der Knoten im Cluster reduziert.

Standardwert: 1024

## authenticator

Authentifizierungs-Backend, Implementierung von IAuthenticator; wird verwendet, um Benutzer zu identifizieren. Cassandra stellt sofort org.apache.cassandra.auth zur Verfügung. {AllowAllAuthenticator, PasswordAuthenticator}.

AllowAllAuthenticator führt keine Überprüfungen durch - deaktivieren Sie die Authentifizierung.
PasswordAuthenticator verwendet Benutzernamen / Passwort-Paare, um Benutzer zu authentifizieren. Es speichert Benutzernamen und Hash-Passwörter in der Tabelle system_auth.roles. Bitte erhöhen Sie den Replikationsfaktor für den Schlüsselbereich system_auth, wenn Sie diesen Authentifikator verwenden. Bei Verwendung von PasswordAuthenticator muss auch CassandraRoleManager verwendet werden (siehe unten).
Standardwert: AllowAllAuthenticator

## authorizer

Autorisierungs-Backend, Implementierung von IAuthorizer; Wird verwendet, um den Zugriff einzuschränken / Berechtigungen bereitzustellen. Cassandra stellt sofort org.apache.cassandra.auth zur Verfügung. {AllowAllAuthorizer, CassandraAuthorizer}.

AllowAllAuthorizer erlaubt jedem Benutzer jede Aktion - deaktivieren Sie die Autorisierung.
CassandraAuthorizer speichert Berechtigungen in der Tabelle system_auth.role_permissions. Bitte erhöhen Sie den Replikationsfaktor für den Schlüsselbereich system_auth, wenn Sie diesen Autorisierer verwenden.
Standardwert: AllowAllAuthorizer

## role_manager

Teil des Authentifizierungs- und Autorisierungs-Backends, Implementierung von IRoleManager; wird verwendet, um Zuschüsse und Mitgliedschaften zwischen Rollen aufrechtzuerhalten. Cassandra stellt standardmäßig org.apache.cassandra.auth.CassandraRoleManager bereit, in dem Rolleninformationen im Schlüsselbereich system_auth gespeichert werden. Die meisten Funktionen des IRoleManager erfordern eine authentifizierte Anmeldung. Wenn der konfigurierte IAuthenticator die Authentifizierung nicht tatsächlich implementiert, sind die meisten dieser Funktionen nicht verfügbar.

CassandraRoleManager speichert Rollendaten im Schlüsselbereich system_auth. Bitte erhöhen Sie den Replikationsfaktor für den Schlüsselbereich system_auth, wenn Sie diesen Rollenmanager verwenden.
Standardwert: CassandraRoleManager

## network_authorizer

Netzwerkautorisierungs-Backend, Implementierung von INetworkAuthorizer; wird verwendet, um den Benutzerzugriff auf bestimmte Domänencontroller einzuschränken. Cassandra stellt standardmäßig org.apache.cassandra.auth zur Verfügung. {AllowAllNetworkAuthorizer, CassandraNetworkAuthorizer}.

AllowAllNetworkAuthorizer ermöglicht jedem Benutzer den Zugriff auf einen beliebigen Domänencontroller. Deaktivieren Sie die Autorisierung.
CassandraNetworkAuthorizer speichert Berechtigungen in der Tabelle system_auth.network_permissions. Bitte erhöhen Sie den Replikationsfaktor für den Schlüsselbereich system_auth, wenn Sie diesen Autorisierer verwenden.
Standardwert: AllowAllNetworkAuthorizer

## roles_validity_in_ms

Gültigkeitsdauer für den Rollen-Cache (das Abrufen erteilter Rollen kann je nach Rollenmanager ein teurer Vorgang sein, CassandraRoleManager ist ein Beispiel) Zugegebene Rollen werden für authentifizierte Sitzungen in AuthenticatedUser zwischengespeichert und können nach dem hier angegebenen Zeitraum erneut (asynchron) geladen werden. Der Standardwert ist 2000 und wird auf 0 gesetzt, um das Caching vollständig zu deaktivieren. Wird für AllowAllAuthenticator automatisch deaktiviert.

Standardwert: 2000

## roles_update_interval_in_ms

Diese Option ist standardmäßig auskommentiert.

Aktualisierungsintervall für den Rollen-Cache (falls aktiviert). Nach diesem Intervall können Cache-Einträge aktualisiert werden. Beim nächsten Zugriff wird ein asynchrones Neuladen geplant und der alte Wert zurückgegeben, bis er abgeschlossen ist. Wenn role_validity_in_ms nicht Null ist, muss dies auch sein. Der Standardwert ist der gleiche Wert wie role_validity_in_ms.

Standardwert: 2000

## permissions_validity_in_ms

Gültigkeitsdauer für den Berechtigungscache (das Abrufen von Berechtigungen kann je nach Autorisierer eine teure Operation sein, CassandraAuthorizer ist ein Beispiel). Der Standardwert ist 2000 und wird zum Deaktivieren auf 0 gesetzt. Wird für AllowAllAuthorizer automatisch deaktiviert.

Standardwert: 2000

## permissions_update_interval_in_ms

Diese Option ist standardmäßig auskommentiert.

Aktualisierungsintervall für den Berechtigungscache (falls aktiviert). Nach diesem Intervall können Cache-Einträge aktualisiert werden. Beim nächsten Zugriff wird ein asynchrones Neuladen geplant und der alte Wert zurückgegeben, bis er abgeschlossen ist. Wenn permissions_validity_in_ms nicht Null ist, muss dies auch sein. Der Standardwert ist der gleiche Wert wie permissions_validity_in_ms.

Standardwert: 2000

## credentials_validity_in_ms

Gültigkeitsdauer für den Cache für Anmeldeinformationen. Dieser Cache ist eng mit der bereitgestellten PasswordAuthenticator-Implementierung von IAuthenticator verbunden. Wenn eine andere IAuthenticator-Implementierung konfiguriert ist, wird dieser Cache nicht automatisch verwendet, sodass die folgenden Einstellungen keine Auswirkungen haben. Beachten Sie, dass Anmeldeinformationen in ihrer verschlüsselten Form zwischengespeichert werden. Wenn Sie diesen Cache aktivieren, wird möglicherweise die Anzahl der an die zugrunde liegende Tabelle gestellten Abfragen verringert, die Latenz einzelner Authentifizierungsversuche wird jedoch möglicherweise nicht wesentlich verringert. Der Standardwert ist 2000 und wird auf 0 gesetzt, um das Zwischenspeichern von Anmeldeinformationen zu deaktivieren.

Standardwert: 2000

## credentials_update_interval_in_ms

Diese Option ist standardmäßig auskommentiert.

Aktualisierungsintervall für den Cache für Anmeldeinformationen (falls aktiviert). Nach diesem Intervall können Cache-Einträge aktualisiert werden. Beim nächsten Zugriff wird ein asynchrones Neuladen geplant und der alte Wert zurückgegeben, bis er abgeschlossen ist. Wenn credentials_validity_in_ms nicht Null ist, muss dies auch sein. Der Standardwert ist der gleiche Wert wie credentials_validity_in_ms.

Standardwert: 2000

## partitioner

Der Partitionierer ist für die Verteilung von Zeilengruppen (nach Partitionsschlüssel) auf die Knoten im Cluster verantwortlich. Der Partitionierer kann NICHT geändert werden, ohne alle Daten neu zu laden. Wenn Sie Knoten hinzufügen oder ein Upgrade durchführen, sollten Sie dies auf denselben Partitionierer einstellen, den Sie derzeit verwenden.

Der Standardpartitionierer ist der Murmur3Partitioner. Ältere Partitionierer wie RandomPartitioner, ByteOrderedPartitioner und OrderPreservingPartitioner wurden nur aus Gründen der Abwärtskompatibilität aufgenommen. Bei neuen Clustern sollten Sie diesen Wert NICHT ändern.

Standardwert: org.apache.cassandra.dht.Murmur3Partitioner

## data_file_directories

Diese Option ist standardmäßig auskommentiert.

Verzeichnisse, in denen Cassandra Daten auf der Festplatte speichern soll. Wenn mehrere Verzeichnisse angegeben werden, verteilt Cassandra die Daten gleichmäßig auf diese, indem die Tokenbereiche aufgeteilt werden. Wenn nicht festgelegt, lautet das Standardverzeichnis $ CASSANDRA_HOME / data / data.

Standardwert (komplexe Option) :

`#     - /var/lib/cassandra/data`

## commitlog_directory

Diese Option ist standardmäßig auskommentiert. Protokoll festschreiben. Bei Verwendung auf einer Magnetfestplatte sollte dies eine separate Spindel als die Datenverzeichnisse sein. Wenn nicht festgelegt, lautet das Standardverzeichnis $ CASSANDRA_HOME / data / commitlog.

Standardwert: / var / lib / cassandra / commitlog

## cdc_enabled

Aktivieren / Deaktivieren der CDC-Funktionalität auf Knotenbasis. Dies ändert die Logik, die für die Zurückweisung der Schreibpfadzuweisung verwendet wird (Standard: Niemals ablehnen. CDC: Zurückweisen Mutation, die eine CDC-fähige Tabelle enthält, wenn der Speicherplatz im cdc_raw_directory begrenzt ist).

Standardwert: false

## cdc_raw_directory

Diese Option ist standardmäßig auskommentiert.

CommitLogSegments werden beim Flush in dieses Verzeichnis verschoben, wenn cdc_enabled: true ist und das Segment Mutationen für eine CDC-fähige Tabelle enthält. Dies sollte auf einer anderen Spindel als die Datenverzeichnisse platziert werden. Wenn nicht festgelegt, lautet das Standardverzeichnis $ CASSANDRA_HOME / data / cdc_raw.

Standardwert: / var / lib / cassandra / cdc_raw

## disk_failure_policy

Richtlinie für Datenfestplattenfehler:

**sterben**
Fahren Sie Klatsch- und Client-Transporte herunter und beenden Sie die JVM für alle fs-Fehler oder Single-Sstable-Fehler, damit der Knoten ersetzt werden kann.

**stop_paranoid**
Beenden Sie Klatsch- und Client-Transporte auch bei Single-Sstable-Fehlern. Beenden Sie die JVM auf Fehler beim Start.

**halt**
Fahren Sie Klatsch- und Client-Transporte herunter, sodass der Knoten praktisch tot bleibt, aber dennoch über JMX überprüft werden kann. Beenden Sie die JVM während des Startvorgangs auf Fehler.

**best_effort**
Beenden Sie die Verwendung der ausgefallenen Festplatte und antworten Sie auf Anforderungen basierend auf den verbleibenden verfügbaren sstables. Dies bedeutet, dass Sie bei CL.ONE veraltete Daten sehen werden!

**ignorieren**
Ignorieren Sie schwerwiegende Fehler und lassen Sie Anforderungen fehlschlagen, wie in Cassandra vor 1.2
Standardwert: Stopp

## commit_failure_policy

Richtlinie für Festschreibungsfehler:

**sterben**
Fahren Sie den Knoten herunter und beenden Sie die JVM, damit der Knoten ersetzt werden kann.

**halt**
Fahren Sie den Knoten herunter, sodass der Knoten praktisch tot bleibt. Er kann jedoch weiterhin über JMX überprüft werden.

**stop_commit**
Fahren Sie das Festschreibungsprotokoll herunter, damit Schreibvorgänge gesammelt werden, aber weiterhin Lesevorgänge ausgeführt werden, wie in Cassandra vor Version 2.0.5

**ignorieren**
Ignorieren Sie schwerwiegende Fehler und lassen Sie die Stapel fehlschlagen
Standardwert: Stopp

## prepared_statements_cache_size_mb

Maximale Größe des vom nativen Protokoll vorbereiteten Anweisungscaches

Gültige Werte sind entweder "auto" (ohne den Wert) oder ein Wert größer 0.

Beachten Sie, dass die Angabe eines zu großen Werts zu lang laufenden GCs und möglicherweise zu Speichermangel führt. Halten Sie den Wert auf einem kleinen Bruchteil des Haufens.

Wenn ständig Meldungen angezeigt werden, dass vorbereitete Anweisungen in letzter Minute verworfen wurden, weil das Cache-Limit erreicht wurde, müssen Sie zunächst die Grundursache dieser Meldungen untersuchen und prüfen, ob vorbereitete Anweisungen korrekt verwendet werden. Verwenden Sie daher Bindungsmarkierungen für variable Teile.

Ändern Sie den Standardwert nur, wenn Sie wirklich besser vorbereitete Anweisungen haben, als in den Cache passen. In den meisten Fällen ist es nicht erforderlich, diesen Wert zu ändern. Die ständige Vorbereitung von Aussagen ist eine Leistungsstrafe.

Der Standardwert ("auto") ist 1/256 des Heaps oder 10 MB, je nachdem, welcher Wert größer ist

## key_cache_size_in_mb

Maximale Größe des Schlüsselcaches im Speicher.

Jeder Schlüssel-Cache-Treffer speichert 1 Suche und jeder Zeilen-Cache-Treffer speichert mindestens 2 Suchen, manchmal mehr. Der Schlüsselcache ist für die Zeit, die er spart, ziemlich klein, daher lohnt es sich, ihn in großen Mengen zu verwenden. Der Zeilencache spart noch mehr Zeit, muss jedoch die gesamte Zeile enthalten, sodass er äußerst platzintensiv ist. Verwenden Sie den Zeilencache am besten nur, wenn Sie heiße oder statische Zeilen haben.

HINWEIS: Wenn Sie die Größe verringern, werden beim Start möglicherweise nicht die heißesten Schlüssel geladen.

Der Standardwert ist leer, um ihn auf "automatisch" zu setzen (min (5% des Heapspeichers (in MB), 100 MB)). Auf 0 setzen, um den Schlüsselcache zu deaktivieren.

## key_cache_save_period

Dauer in Sekunden, nach der Cassandra den Schlüsselcache speichern soll. Caches werden wie in dieser Konfigurationsdatei angegeben im Verzeichnis saved_caches_directory gespeichert.

Gespeicherte Caches verbessern die Kaltstartgeschwindigkeit erheblich und sind in Bezug auf die E / A für den Schlüsselcache relativ günstig. Das Speichern von Zeilencaches ist viel teurer und wird nur begrenzt verwendet.

Standard ist 14400 oder 4 Stunden.

Standardwert: 14400

## key_cache_keys_to_save

Diese Option ist standardmäßig auskommentiert.

Anzahl der zu speichernden Schlüssel aus dem Schlüsselcache Standardmäßig deaktiviert, dh alle Schlüssel werden gespeichert

Standardwert: 100

## row_cache_class_name

Diese Option ist standardmäßig auskommentiert.

Name der Zeilencache-Implementierungsklasse. Verfügbare Implementierungen:

**org.apache.cassandra.cache.OHCProvider**
Vollständige Implementierung des Zeilen-Cache außerhalb des Heapspeichers (Standard).

**org.apache.cassandra.cache.SerializingCacheProvider**
Dies ist die Zeilen-Cache-Implementierung, die in früheren Versionen von Cassandra verfügbar war.

Standardwert: org.apache.cassandra.cache.OHCProvider

## row_cache_size_in_mb

Maximale Größe des Zeilencaches im Speicher. Beachten Sie, dass für die Implementierung des OHC-Cache ein zusätzlicher Speicher außerhalb des Heapspeichers erforderlich ist, um die Kartenstrukturen zu verwalten, und ein gewisser Speicher während des Betriebs während des Betriebs, bevor / nachdem Cache-Einträge auf die Cache-Kapazität angerechnet werden können. Dieser Overhead ist normalerweise im Vergleich zur gesamten Kapazität gering. Geben Sie nicht mehr Speicher an, den sich das System im schlimmsten Fall leisten kann, und lassen Sie etwas Spielraum für den Cache auf Blockebene des Betriebssystems. Lassen Sie Ihr System niemals tauschen.

Der Standardwert ist 0, um das Zeilen-Caching zu deaktivieren.

Standardwert: 0

## row_cache_save_period

Dauer in Sekunden, nach der Cassandra den Zeilencache speichern soll. Caches werden wie in dieser Konfigurationsdatei angegeben im Verzeichnis saved_caches_directory gespeichert.

Gespeicherte Caches verbessern die Kaltstartgeschwindigkeit erheblich und sind in Bezug auf die E / A für den Schlüsselcache relativ günstig. Das Speichern von Zeilencaches ist viel teurer und wird nur begrenzt verwendet.

Die Standardeinstellung ist 0, um das Speichern des Zeilencaches zu deaktivieren.

Standardwert: 0

## row_cache_keys_to_save

Diese Option ist standardmäßig auskommentiert.

Anzahl der zu speichernden Schlüssel aus dem Zeilencache. Geben Sie 0 an (dies ist die Standardeinstellung). Dies bedeutet, dass alle Schlüssel gespeichert werden

Standardwert: 100

## counter_cache_size_in_mb

Maximale Größe des Zähler-Cache im Speicher.

Der Zähler-Cache hilft dabei, die Konkurrenz von Zählersperren für heiße Zählerzellen zu verringern. Im Fall von RF = 1 führt ein Zähler-Cache-Treffer dazu, dass Cassandra den Lesevorgang vor dem vollständigen Schreiben überspringt. Bei RF> 1 hilft ein Treffer im Zähler-Cache weiterhin, die Dauer des Sperrhaltes zu verringern, was bei Aktualisierungen der heißen Zählerzellen hilfreich ist, ermöglicht jedoch nicht das vollständige Überspringen des Lesevorgangs. Nur das lokale Tupel (Clock, Count) einer Zählerzelle wird gespeichert, nicht der gesamte Zähler, daher ist es relativ billig.

HINWEIS: Wenn Sie die Größe verringern, werden beim Start möglicherweise nicht die heißesten Schlüssel geladen.

Der Standardwert ist leer, um ihn auf "automatisch" zu setzen (min (2,5% des Heapspeichers (in MB), 50 MB)). Auf 0 setzen, um den Zähler-Cache zu deaktivieren. HINWEIS: Wenn Sie Zählerlöschvorgänge durchführen und sich auf niedrige gcgs verlassen, sollten Sie den Zähler-Cache deaktivieren.

## counter_cache_save_period

Dauer in Sekunden, nach der Cassandra den Zähler-Cache speichern soll (nur Schlüssel). Caches werden wie in dieser Konfigurationsdatei angegeben im Verzeichnis saved_caches_directory gespeichert.

Standard ist 7200 oder 2 Stunden.

Standardwert: 7200

## counter_cache_keys_to_save

Diese Option ist standardmäßig auskommentiert.

Anzahl der zu speichernden Schlüssel aus dem Zähler-Cache Standardmäßig deaktiviert, dh alle Schlüssel werden gespeichert

Standardwert: 100

## saved_caches_directory

Diese Option ist standardmäßig auskommentiert.

gespeicherte Caches Wenn nicht festgelegt, lautet das Standardverzeichnis $ CASSANDRA_HOME / data / saved_caches.

Standardwert: / var / lib / cassandra / saved_caches

## commitlog_sync_batch_window_in_ms

Diese Option ist standardmäßig auskommentiert.

commitlog_sync kann entweder "periodisch", "Gruppe" oder "Stapel" sein.

Im Batch-Modus bestätigt Cassandra keine Schreibvorgänge, bis das Festschreibungsprotokoll auf die Festplatte geschrieben wurde. Jeder eingehende Schreibvorgang löst die Flush-Task aus. commitlog_sync_batch_window_in_ms ist ein veralteter Wert. Bisher hatte es fast keinen Wert und wird entfernt.

Standardwert: 2

## commitlog_sync_group_window_in_ms

Diese Option ist standardmäßig auskommentiert.

Der Gruppenmodus ähnelt dem Stapelmodus, in dem Cassandra Schreibvorgänge erst bestätigt, wenn das Festschreibungsprotokoll auf die Festplatte geschrieben wurde. Der Unterschied besteht darin, dass der Gruppenmodus zwischen den Löschvorgängen auf commitlog_sync_group_window_in_ms wartet.

Standardwert: 1000

## commitlog_sync

Die Standardoption ist "periodisch", wobei Schreibvorgänge sofort bestätigt werden können und das CommitLog einfach alle Commitlog_sync_period_in_ms Millisekunden synchronisiert wird.

Standardwert: periodisch

## commitlog_sync_period_in_ms

Standardwert: 10000

## periodic_commitlog_sync_lag_block_in_ms

Diese Option ist standardmäßig auskommentiert.

Im periodischen Commitlog-Modus die Anzahl der Millisekunden, die Schreibvorgänge blockiert werden sollen, während auf das langsame Löschen der Festplatte gewartet wird.

## commitlog_segment_size_in_mb

Die Größe der einzelnen Commitlog-Dateisegmente. Ein Commitlog-Segment kann archiviert, gelöscht oder recycelt werden, sobald alle darin enthaltenen Daten (möglicherweise aus jeder Spaltenfamilie im System) in sstables gelöscht wurden.

Die Standardgröße ist 32, was fast immer in Ordnung ist. Wenn Sie jedoch Commitlog-Segmente archivieren (siehe commitlog_archiving.properties), möchten Sie wahrscheinlich eine feinere Granularität der Archivierung. 8 oder 16 MB sind angemessen. Die maximale Mutationsgröße kann auch über die Einstellung max_mutation_size_in_kb in cassandra.yaml konfiguriert werden. Der Standardwert ist die Hälfte der Größe commitlog_segment_size_in_mb * 1024. Dies sollte positiv sein und weniger als 2048 betragen.

HINWEIS: Wenn max_mutation_size_in_kb explizit festgelegt ist, muss commitlog_segment_size_in_mb auf mindestens die doppelte Größe von max_mutation_size_in_kb / 1024 festgelegt werden

Standardwert: 32

## commitlog_compression

Diese Option ist standardmäßig auskommentiert.

Komprimierung für das Festschreibungsprotokoll. Wenn nicht angegeben, wird das Festschreibungsprotokoll unkomprimiert geschrieben. LZ4-, Snappy- und Deflate-Kompressoren werden unterstützt.

Standardwert (komplexe Option) :

```s
#   - class_name: LZ4Compressor
#     parameters:
#         -
```

## seed_provider

Jede Klasse, die die SeedProvider-Schnittstelle implementiert und über einen Konstruktor verfügt, der eine Map <String, String> von Parametern verwendet, reicht aus.

Standardwert (komplexe Option) :
```s
# Addresses of hosts that are deemed contact points.
# Cassandra nodes use this list of hosts to find each other and learn
# the topology of the ring.  You must change this if you are running
# multiple nodes!
- class_name: org.apache.cassandra.locator.SimpleSeedProvider
  parameters:
      # seeds is actually a comma-delimited list of addresses.
      # Ex: "<ip1>,<ip2>,<ip3>"
      - seeds: "127.0.0.1:7000"
```

## concurrent_reads

Bei Workloads mit mehr Daten, als in den Speicher passen, besteht der Engpass von Cassandra in Lesevorgängen, bei denen Daten von der Festplatte abgerufen werden müssen. "Concurrent_reads" sollte auf (16 * number_of_drives) gesetzt werden, damit die Operationen im Stack so tief in die Warteschlange gestellt werden können, dass das Betriebssystem und die Laufwerke sie neu anordnen können. Gleiches gilt für "concurrent_counter_writes", da Zählerschreibvorgänge die aktuellen Werte lesen, bevor sie inkrementiert und zurückgeschrieben werden.

Da Schreibvorgänge fast nie an E / A gebunden sind, hängt die ideale Anzahl von "concurrent_writes" von der Anzahl der Kerne in Ihrem System ab. (8 * Anzahl_der_Kerne) ist eine gute Faustregel.

Standardwert: 32

## concurrent_writes

Standardwert: 32

## concurrent_counter_writes

Standardwert: 32

## concurrent_materialized_view_writes

Bei materialisierten Ansichtsschreibvorgängen, da es sich um einen Lesevorgang handelt, sollte dies durch weniger gleichzeitige Lesevorgänge oder gleichzeitige Schreibvorgänge begrenzt werden.

Standardwert: 32

## file_cache_size_in_mb

Diese Option ist standardmäßig auskommentiert.

Maximaler Speicher für sstable Chunk Cache und Buffer Pooling. 32 MB davon sind für das Poolen von Puffern reserviert, der Rest wird als Cache verwendet, der unkomprimierte stabile Blöcke enthält. Der Standardwert ist 1/4 von Heap oder 512 MB. Dieser Pool wird außerhalb des Heaps zugewiesen, zusätzlich zu dem für den Heap zugewiesenen Speicher. Der Cache hat auch einen On-Heap-Overhead, der ungefähr 128 Bytes pro Block beträgt (dh 0,2% der reservierten Größe, wenn die Standardgröße von 64 KB verwendet wird). Speicher wird nur bei Bedarf zugewiesen.

Standardwert: 512

## buffer_pool_use_heap_if_exhausted

Diese Option ist standardmäßig auskommentiert.

Flag, das angibt, ob ein Heap zugewiesen oder deaktiviert werden soll, wenn der sstable-Pufferpool erschöpft ist, dh wenn der maximale Speicher file_cache_size_in_mb überschritten wurde. Danach werden keine Puffer zwischengespeichert, sondern auf Anfrage zugewiesen.

Standardwert: true

## disk_optimization_strategy

Diese Option ist standardmäßig auskommentiert.

Die Strategie zur Optimierung des Festplattenlesevorgangs Mögliche Werte sind: ssd (für Solid-State-Festplatten die Standardeinstellung) Spinning (für sich drehende Festplatten)

Standardwert: ssd

## memtable_heap_space_in_mb

Diese Option ist standardmäßig auskommentiert.

Insgesamt zulässiger Speicher für Memtables. Cassandra akzeptiert keine Schreibvorgänge mehr, wenn das Limit überschritten wird, bis ein Flush abgeschlossen ist, und löst einen Flush basierend auf memtable_cleanup_threshold aus. Wenn dies weggelassen wird, setzt Cassandra beide auf 1/4 der Größe des Heaps.

Standardwert: 2048

## memtable_offheap_space_in_mb

Diese Option ist standardmäßig auskommentiert.

Standardwert: 2048

## memtable_cleanup_threshold

Diese Option ist standardmäßig auskommentiert.

memtable_cleanup_threshold ist veraltet. Die Standardberechnung ist die einzig vernünftige Wahl. Weitere Informationen finden Sie in den Kommentaren zu memtable_flush_writers.

Verhältnis der belegten nicht spülbaren Memtable-Größe zur zulässigen Gesamtgröße, die eine Flush der größten Memtable auslöst. Größere mct bedeuten größere Spülungen und damit weniger Verdichtung, aber auch weniger gleichzeitige Spülaktivitäten, was es schwierig machen kann, Ihre Festplatten unter starker Schreiblast zu halten.

memtable_cleanup_threshold ist standardmäßig 1 / (memtable_flush_writers + 1)

Standardwert: 0,11

## memtable_allocation_type

Geben Sie an, wie Cassandra Memtable-Speicher zuweist und verwaltet. Optionen sind:

**heap_buffers**
auf Haufen nio Puffer

**ffheap_buffers**
aus Haufen (direkt) nio Puffer

**offheap_objects**
aus Heap-Objekten

Standardwert: heap_buffers

## repair_session_space_in_mb

Diese Option ist standardmäßig auskommentiert.

Begrenzen Sie die Speichernutzung für Merkle-Baumberechnungen während Reparaturen. Der Standardwert ist 1/16 des verfügbaren Heaps. Der Hauptkompromiss besteht darin, dass kleinere Bäume eine geringere Auflösung haben, was zu einem Über-Streaming von Daten führen kann. Wenn bei Reparaturen ein Haufen Druck auftritt, sollten Sie diesen senken, aber Sie dürfen nicht unter ein Megabyte gehen. Wenn Sie viel Über-Streaming sehen, sollten Sie dies erhöhen oder die Reparatur von Teilbereichen verwenden.

Weitere Informationen finden Sie unter https://issues.apache.org/jira/browse/CASSANDRA-14096 .

## commitlog_total_space_in_mb

Diese Option ist standardmäßig auskommentiert.

Gesamtspeicherplatz für Festschreibungsprotokolle auf der Festplatte.

Wenn der Speicherplatz diesen Wert überschreitet, spült Cassandra jede verschmutzte CF im ältesten Segment und entfernt sie. Ein kleiner Gesamt-Commitlog-Speicherplatz führt daher tendenziell zu mehr Flush-Aktivitäten bei weniger aktiven Spaltenfamilien.

Der Standardwert ist der kleinere von 8192 und 1/4 des gesamten Speicherplatzes des Commitlog-Volumes.

Standardwert: 8192

## memtable_flush_writers

Diese Option ist standardmäßig auskommentiert.

Hiermit wird die Anzahl der Memtable-Flush-Writer-Threads pro Festplatte sowie die Gesamtzahl der Memtables festgelegt, die gleichzeitig geleert werden können. Dies ist im Allgemeinen eine Kombination aus Compute und IO-gebunden.

Das Löschen von Memtables ist CPU-effizienter als das Aufnehmen von Memtables, und ein einzelner Thread kann mit der Aufnahmerate eines gesamten Servers auf einer einzelnen schnellen Festplatte Schritt halten, bis er vorübergehend unter EO-Bedingungen in der Regel durch Komprimierung gebunden wird. Zu diesem Zeitpunkt benötigen Sie mehrere bündige Gewinde. Irgendwann in der Zukunft kann es ständig CPU-gebunden werden.

Mithilfe der MemtablePool.BlockedOnAllocation-Metrik, die 0 sein sollte, aber ungleich Null ist, wenn Threads blockiert sind und auf das Leeren in den freien Speicher warten, können Sie feststellen, ob das Löschen ins Hintertreffen gerät.

memtable_flush_writers ist standardmäßig zwei für ein einzelnes Datenverzeichnis. Dies bedeutet, dass zwei Memtables gleichzeitig in das einzelne Datenverzeichnis geleert werden können. Wenn Sie über mehrere Datenverzeichnisse verfügen, wird standardmäßig jeweils eine Memtable-Leerung durchgeführt. Bei der Leerung wird jedoch ein Thread pro Datenverzeichnis verwendet, sodass Sie zwei oder mehr Writer erhalten.

Zwei reichen im Allgemeinen aus, um auf einer schnellen Festplatte [Array] zu leeren, die als einzelnes Datenverzeichnis bereitgestellt wird. Das Hinzufügen weiterer Flush-Writer führt zu kleineren, häufigeren Flushs, die mehr Komprimierungsaufwand verursachen.

Es gibt einen direkten Kompromiss zwischen der Anzahl der gleichzeitig zu spülenden Memtables und der Größe und Häufigkeit der Spülung. Mehr ist nicht besser. Sie benötigen nur genügend Flush-Writer, um niemals auf das Leeren in den freien Speicher zu warten.

Standardwert: 2

## cdc_total_space_in_mb

Diese Option ist standardmäßig auskommentiert.

Gesamter Speicherplatz für Änderungsdatenerfassungsprotokolle auf der Festplatte.

Wenn der Speicherplatz diesen Wert überschreitet, löst Cassandra WriteTimeoutException für Mutationen aus, einschließlich Tabellen mit aktiviertem CDC. Ein CDCCompactor ist dafür verantwortlich, die unformatierten CDC-Protokolle zu analysieren und sie zu löschen, wenn die Analyse abgeschlossen ist.

Der Standardwert ist mindestens 4096 MB und 1/8 des gesamten Speicherplatzes des Laufwerks, auf dem sich cdc_raw_directory befindet.

Standardwert: 4096

## cdc_free_space_check_interval_ms

Diese Option ist standardmäßig auskommentiert.

Wenn wir unser cdc_raw-Limit erreichen und der CDCCompactor entweder hinterherläuft oder unter Gegendruck steht, prüfen wir im folgenden Intervall, ob neuer Speicherplatz für cdc-verfolgte Tabellen verfügbar ist. Standard auf 250ms

Standardwert: 250

## index_summary_capacity_in_mb

Eine feste Speicherpoolgröße in MB für SSTable-Indexzusammenfassungen. Wenn leer, wird standardmäßig 5% der Heap-Größe verwendet. Wenn die Speichernutzung aller Indexzusammenfassungen diese Grenze überschreitet, verkleinern SSTables mit niedrigen Leseraten ihre Indexzusammenfassungen, um diese Grenze einzuhalten. Dies ist jedoch ein Best-Effort-Prozess. Unter extremen Bedingungen muss Cassandra möglicherweise mehr als diese Speichermenge verwenden.

## index_summary_resize_interval_in_minutes

Wie oft sollten Indexzusammenfassungen erneut abgetastet werden? Dies erfolgt regelmäßig, um den Speicher aus dem Pool mit fester Größe in sstables umzuverteilen, die proportional zu ihren letzten Leseraten sind. Wenn Sie den Wert -1 festlegen, wird dieser Prozess deaktiviert, und vorhandene Indexzusammenfassungen bleiben auf ihrem aktuellen Stichprobenpegel.

Standardwert: 60

## trickle_fsync

Gibt an, ob beim sequentiellen Schreiben in Abständen fsync () ausgeführt werden soll, um das Betriebssystem zu zwingen, die verschmutzten Puffer zu leeren. Aktivieren Sie diese Option, um zu verhindern, dass plötzliches Leeren des verschmutzten Puffers die Leselatenz beeinträchtigt. Fast immer eine gute Idee für SSDs; nicht unbedingt auf Platten.

Standardwert: false

## trickle_fsync_interval_in_kb

Standardwert: 10240

## storage_port

TCP-Port für Befehle und Daten Aus Sicherheitsgründen sollten Sie diesen Port nicht dem Internet aussetzen. Firewall es bei Bedarf.

Standardwert: 7000

## ssl_storage_port

SSL-Port für ältere verschlüsselte Kommunikation. Diese Eigenschaft wird nicht verwendet, sofern sie nicht in server_encryption_options aktiviert ist (siehe unten). Ab Cassandra 4.0 ist diese Eigenschaft veraltet, da ein einzelner Port für sichere und unsichere Verbindungen verwendet werden kann. Aus Sicherheitsgründen sollten Sie diesen Port nicht dem Internet aussetzen. Firewall es bei Bedarf.

Standardwert: 7001

## listen_address

Adresse oder Schnittstelle, an die gebunden werden soll, und Anweisung anderer Cassandra-Knoten, eine Verbindung herzustellen. Sie müssen dies ändern, wenn mehrere Knoten kommunizieren können sollen!

Setzen Sie listen_address ODER listen_interface, nicht beide.

Wenn Sie es leer lassen, bleibt es bei InetAddress.getLocalHost (). Dies wird immer das Richtige tun, wenn der Knoten richtig konfiguriert ist (Hostname, Namensauflösung usw.), und das Richtige ist, die dem Hostnamen zugeordnete Adresse zu verwenden (möglicherweise nicht).

Das Setzen von listen_address auf 0.0.0.0 ist immer falsch.

Standardwert: localhost

## listen_interface

Diese Option ist standardmäßig auskommentiert.

Setzen Sie listen_address ODER listen_interface, nicht beide. Schnittstellen müssen einer einzelnen Adresse entsprechen, IP-Aliasing wird nicht unterstützt.

Standardwert: eth0

## listen_interface_prefer_ipv6

Diese Option ist standardmäßig auskommentiert.

Wenn Sie die Schnittstelle nach Namen angeben und die Schnittstelle eine IPv4- und eine IPv6-Adresse hat, können Sie angeben, welche mit listen_interface_prefer_ipv6 ausgewählt werden soll. Bei false wird die erste IPv4-Adresse verwendet. Wenn true, wird die erste IPv6-Adresse verwendet. Der Standardwert ist false und bevorzugt IPv4. Wenn es nur eine Adresse gibt, wird diese unabhängig von ipv4 / ipv6 ausgewählt.

Standardwert: false

## broadcast_address

Diese Option ist standardmäßig auskommentiert.

Adresse, die an andere Cassandra-Knoten gesendet werden soll Wenn Sie dieses Feld leer lassen, wird derselbe Wert wie listen_address festgelegt

Standardwert: 1.2.3.4

## listen_on_broadcast_address

Diese Option ist standardmäßig auskommentiert.

Wenn Sie mehrere physische Netzwerkschnittstellen verwenden, setzen Sie diesen Wert auf "true", um zusätzlich zur "listen_address" die Broadcast-Adresse abzuhören, damit die Knoten in beiden Schnittstellen kommunizieren können. Ignorieren Sie diese Eigenschaft, wenn die Netzwerkkonfiguration automatisch zwischen öffentlichen und privaten Netzwerken wie EC2 weitergeleitet wird.

Standardwert: false

## internode_authenticator

Diese Option ist standardmäßig auskommentiert.

Internode-Authentifizierungs-Backend, Implementierung von IInternodeAuthenticator; wird verwendet, um Verbindungen von Peer-Knoten zuzulassen / zu verbieten.

Standardwert: org.apache.cassandra.auth.AllowAllInternodeAuthenticator

## start_native_transport

Gibt an, ob der native Transportserver gestartet werden soll. Die Adresse, an die der native Transport gebunden ist, wird durch rpc_address definiert.

Standardwert: true

## native_transport_port

Port für den nativen CQL-Transport zum Abhören von Clients Aus Sicherheitsgründen sollten Sie diesen Port nicht dem Internet aussetzen. Firewall es bei Bedarf.

Standardwert: 9042

## native_transport_port_ssl

Diese Option ist standardmäßig auskommentiert. Durch Aktivieren der nativen Transportverschlüsselung in client_encryption_options können Sie entweder die Verschlüsselung für den Standardport oder einen dedizierten zusätzlichen Port zusammen mit dem unverschlüsselten standardmäßigen native_transport_port verwenden. Wenn Sie die Clientverschlüsselung aktivieren und native_transport_port_ssl deaktivieren, wird die Verschlüsselung für native_transport_port verwendet. Wenn Sie native_transport_port_ssl auf einen anderen Wert als native_transport_port setzen, wird die Verschlüsselung für native_transport_port_ssl verwendet, während native_transport_port unverschlüsselt bleibt.

Standardwert: 9142

## native_transport_max_threads

Diese Option ist standardmäßig auskommentiert. Die maximalen Threads für die Verarbeitung von Anforderungen (beachten Sie, dass inaktive Threads nach 30 Sekunden gestoppt werden, sodass keine entsprechende minimale Einstellung vorhanden ist).

Standardwert: 128

## native_transport_max_frame_size_in_mb

Diese Option ist standardmäßig auskommentiert.

Die maximale Größe des zulässigen Rahmens. Größere Frames (Anfragen) werden als ungültig abgelehnt. Der Standardwert ist 256 MB. Wenn Sie diesen Parameter ändern, möchten Sie möglicherweise max_value_size_in_mb entsprechend anpassen. Dies sollte positiv sein und unter 2048 liegen.

Standardwert: 256

## native_transport_frame_block_size_in_kb

Diese Option ist standardmäßig auskommentiert.

Wenn die Prüfsumme als Protokolloption aktiviert ist, gibt dies die Größe der Blöcke an, in die Frames eingeteilt werden.

Standardwert: 32

## native_transport_max_concurrent_connections

Diese Option ist standardmäßig auskommentiert.

Die maximale Anzahl gleichzeitiger Clientverbindungen. Der Standardwert ist -1, was unbegrenzt bedeutet.

Standardwert: -1

## native_transport_max_concurrent_connections_per_ip

Diese Option ist standardmäßig auskommentiert.

Die maximale Anzahl gleichzeitiger Clientverbindungen pro Quell-IP. Der Standardwert ist -1, was unbegrenzt bedeutet.

Standardwert: -1

## native_transport_allow_older_protocols

Steuert, ob Cassandra ältere, aber derzeit unterstützte Protokollversionen berücksichtigt. Der Standardwert ist true. Dies bedeutet, dass alle unterstützten Protokolle berücksichtigt werden.

Standardwert: true

## native_transport_idle_timeout_in_ms

Diese Option ist standardmäßig auskommentiert.

Steuert, wann inaktive Clientverbindungen geschlossen werden. Inaktive Verbindungen waren solche, die über einen bestimmten Zeitraum weder gelesen noch geschrieben wurden.

Clients können Heartbeats implementieren, indem sie nach einer Zeitüberschreitung eine native OPTIONS-Protokollnachricht senden, die den Zeitgeber für die Leerlaufzeitüberschreitung auf der Serverseite zurücksetzt. Um inaktive Clientverbindungen zu schließen, müssen auf der Clientseite entsprechende Werte für Heartbeat-Intervalle festgelegt werden.

Zeitüberschreitungen für Leerlaufverbindungen sind standardmäßig deaktiviert.

Standardwert: 60000

## rpc_address

Die Adresse oder Schnittstelle, an die der native Transportserver gebunden werden soll.

Setzen Sie rpc_address ODER rpc_interface, nicht beide.

Wenn Sie rpc_address leer lassen, hat dies den gleichen Effekt wie auf listen_address (dh es basiert auf dem konfigurierten Hostnamen des Knotens).

Beachten Sie, dass Sie im Gegensatz zu listen_address 0.0.0.0 angeben können, aber auch Broadcast_rpc_address auf einen anderen Wert als 0.0.0.0 setzen müssen.

Aus Sicherheitsgründen sollten Sie diesen Port nicht dem Internet aussetzen. Firewall es bei Bedarf.

Standardwert: localhost

## rpc_interface

Diese Option ist standardmäßig auskommentiert.

Setzen Sie rpc_address ODER rpc_interface, nicht beide. Schnittstellen müssen einer einzelnen Adresse entsprechen, IP-Aliasing wird nicht unterstützt.

Standardwert: eth1

## rpc_interface_prefer_ipv6

Diese Option ist standardmäßig auskommentiert.

Wenn Sie die Schnittstelle nach Namen angeben und die Schnittstelle eine IPv4- und eine IPv6-Adresse hat, können Sie angeben, welche mit rpc_interface_prefer_ipv6 ausgewählt werden soll. Bei false wird die erste IPv4-Adresse verwendet. Wenn true, wird die erste IPv6-Adresse verwendet. Der Standardwert ist false und bevorzugt IPv4. Wenn es nur eine Adresse gibt, wird diese unabhängig von ipv4 / ipv6 ausgewählt.

Standardwert: false

## broadcast_rpc_address

Diese Option ist standardmäßig auskommentiert.

RPC-Adresse zur Übertragung an Treiber und andere Cassandra-Knoten. Dies kann nicht auf 0.0.0.0 eingestellt werden. Wenn Sie dieses Feld leer lassen, wird dies auf den Wert von rpc_address gesetzt. Wenn rpc_address auf 0.0.0.0 festgelegt ist, muss Broadcast_rpc_address festgelegt werden.

Standardwert: 1.2.3.4

## rpc_keepalive

Aktivieren oder Deaktivieren von Keepalive für RPC / native Verbindungen

Standardwert: true

## internode_send_buff_size_in_bytes

Diese Option ist standardmäßig auskommentiert.

Kommentar zum Festlegen der Socket-Puffergröße für die Internodienkommunikation Beachten Sie, dass beim Einstellen die Puffergröße durch net.core.wmem_max begrenzt ist und wenn sie nicht festgelegt wird, durch net.ipv4.tcp_wmem definiert wird. Siehe auch: / proc / sys / net / core / wmem_max / proc / sys / net / core / rmem_max / proc / sys / net / ipv4 / tcp_wmem / proc / sys / net / ipv4 / tcp_wmem und 'man tcp'

## internode_recv_buff_size_in_bytes

Diese Option ist standardmäßig auskommentiert.

Kommentar zum Festlegen der Socket-Puffergröße für die Internodienkommunikation Beachten Sie, dass beim Festlegen der Puffergröße die Puffergröße durch net.core.wmem_max begrenzt ist und wenn sie nicht festgelegt wird, durch net.ipv4.tcp_wmem definiert wird

## incremental_backups

Setzen Sie diesen Wert auf true, damit Cassandra eine feste Verknüpfung zu jedem sstable erstellt, der lokal in einem Backup / Unterverzeichnis der Keyspace-Daten gelöscht oder gestreamt wird. Das Entfernen dieser Links liegt in der Verantwortung des Betreibers.

Standardwert: false

## snapshot_before_compaction

Gibt an, ob vor jeder Verdichtung ein Schnappschuss erstellt werden soll. Seien Sie vorsichtig mit dieser Option, da Cassandra die Schnappschüsse nicht für Sie bereinigt. Am nützlichsten, wenn Sie bei einer Änderung des Datenformats paranoid sind.

Standardwert: false

## auto_snapshot

Gibt an, ob vor dem Abschneiden des Schlüsselbereichs oder dem Löschen von Spaltenfamilien ein Snapshot der Daten erstellt wurde. Der STRONGLY empfohlene Standardwert true sollte verwendet werden, um die Datensicherheit zu gewährleisten. Wenn Sie dieses Flag auf false setzen, gehen beim Abschneiden oder Löschen Daten verloren.

Standardwert: true

## column_index_size_in_kb

Granularität des Kollatierungsindex von Zeilen innerhalb einer Partition. Erhöhen Sie den Wert, wenn Ihre Zeilen groß sind oder wenn Sie eine sehr große Anzahl von Zeilen pro Partition haben. Die konkurrierenden Ziele sind folgende:

Eine geringere Granularität bedeutet, dass mehr Indexeinträge generiert werden und das Nachschlagen von Zeilen mit der Partition nach Sortierspalte schneller ist
Cassandra behält jedoch den Kollatierungsindex für heiße Zeilen (als Teil des Schlüsselcaches) im Speicher, sodass Sie durch eine größere Granularität mehr heiße Zeilen zwischenspeichern können
Standardwert: 64

## column_index_cache_size_in_kb

Pro sstable indizierte Schlüssel-Cache-Einträge (der oben erwähnte Kollatierungsindex im Speicher), die diese Größe überschreiten, werden nicht auf dem Heap gespeichert. Dies bedeutet, dass nur Partitionsinformationen auf dem Heap gespeichert werden und die Indexeinträge von der Festplatte gelesen werden.

Beachten Sie, dass sich diese Größe auf die Größe der serialisierten Indexinformationen und nicht auf die Größe der Partition bezieht.

Standardwert: 2

## concurrent_compactors

Diese Option ist standardmäßig auskommentiert.

Anzahl der gleichzeitig zulässigen Komprimierungen, NICHT einschließlich Validierungs- „Komprimierungen" für die Reparatur gegen Entropie. Gleichzeitige Komprimierungen können dazu beitragen, die Leseleistung bei einer gemischten Lese- / Schreibarbeitslast zu erhalten, indem die Tendenz kleiner sstables verringert wird, sich während einer einzelnen Komprimierung mit langer Laufzeit anzusammeln. Die Standardeinstellung ist normalerweise in Ordnung. Wenn Probleme mit der zu langsamen oder zu schnellen Komprimierung auftreten, sollten Sie zuerst compaction_throughput_mb_per_sec überprüfen.

concurrent_compactors ist standardmäßig kleiner (Anzahl der Festplatten, Anzahl der Kerne), mit einem Minimum von 2 und einem Maximum von 8.

Wenn Ihre Datenverzeichnisse von SSD gesichert werden, sollten Sie dies auf die Anzahl der Kerne erhöhen.

Standardwert: 1

## concurrent_validations

Diese Option ist standardmäßig auskommentiert.

Anzahl der gleichzeitig zulässigen Reparaturvalidierungen. Standard ist unbegrenzt Werte kleiner als eins werden als unbegrenzt interpretiert (Standard)

Standardwert: 0

## concurrent_materialized_view_builders

Anzahl der gleichzeitig zulässigen materialisierten View Builder-Aufgaben.

Standardwert: 1

## compaction_throughput_mb_per_sec

Drosselt die Verdichtung auf den angegebenen Gesamtdurchsatz im gesamten System. Je schneller Sie Daten einfügen, desto schneller müssen Sie komprimieren, um den stabilen Countdown niedrig zu halten. Im Allgemeinen ist es jedoch mehr als ausreichend, diesen Wert auf das 16- bis 32-fache der Rate festzulegen, mit der Sie Daten einfügen. Wenn Sie diesen Wert auf 0 setzen, wird die Drosselung deaktiviert. Beachten Sie, dass dieses Konto für alle Arten der Verdichtung gilt, einschließlich der Validierungsverdichtung.

Standardwert: 16

## sstable_preemptive_open_interval_in_mb

Beim Komprimieren können die Ersatz-Stall (e) geöffnet werden, bevor sie vollständig geschrieben wurden, und anstelle der vorherigen Stallungen für jeden Bereich verwendet werden, der geschrieben wurde. Dies hilft dabei, Lesevorgänge reibungslos zwischen den sstables zu übertragen, die Abwanderung des Seitencaches zu verringern und heiße Zeilen heiß zu halten

Standardwert: 50

## stream_entire_sstables

Diese Option ist standardmäßig auskommentiert.

Wenn diese Option aktiviert ist, kann Cassandra ganze berechtigten SSTables zwischen Knoten, einschließlich aller Komponenten, auf Null kopieren. Dies beschleunigt die Netzwerkübertragung erheblich, abhängig von der durch stream_throughput_outbound_megabits_per_sec angegebenen Drosselung. Wenn Sie dies aktivieren, wird der GC-Druck auf den Sende- und Empfangsknoten verringert. Wenn nicht gesetzt, ist die Standardeinstellung aktiviert. Diese Funktion versucht zwar, die Festplatten im Gleichgewicht zu halten, kann dies jedoch nicht garantieren. Diese Funktion wird automatisch deaktiviert, wenn die Internodienverschlüsselung aktiviert ist. Derzeit kann dies mit Leveled Compaction verwendet werden. Sobald CASSANDRA-14586 behoben ist, profitieren auch andere Verdichtungsstrategien, wenn sie in Kombination mit CASSANDRA-6696 verwendet werden.

Standardwert: true

## stream_throughput_outbound_megabits_per_sec

Diese Option ist standardmäßig auskommentiert.

Drosselt alle ausgehenden Streaming-Dateiübertragungen auf diesem Knoten auf den angegebenen Gesamtdurchsatz in Mbit / s. Dies ist erforderlich, da Cassandra beim Streaming von Daten während des Bootstraps oder der Reparatur hauptsächlich sequentielle E / A-Vorgänge ausführt, was zu einer Überlastung der Netzwerkverbindung und einer Verschlechterung der RPC-Leistung führen kann. Wenn nicht festgelegt, beträgt der Standardwert 200 Mbit / s oder 25 MB / s.

Standardwert: 200

## inter_dc_stream_throughput_outbound_megabits_per_sec

Diese Option ist standardmäßig auskommentiert.

Drosselt die gesamte Übertragung von Streaming-Dateien zwischen den Rechenzentren. Mit dieser Einstellung können Benutzer den DC-Stream-Durchsatz drosseln und den gesamten mit stream_throughput_outbound_megabits_per_sec konfigurierten Netzwerk-Stream-Verkehr drosseln. Wenn diese Option deaktiviert ist, beträgt der Standardwert 200 Mbit / s oder 25 MB / s

Standardwert: 200

## read_request_timeout_in_ms

Wie lange sollte der Koordinator warten, bis die Lesevorgänge abgeschlossen sind? Der niedrigste akzeptable Wert beträgt 10 ms.

Standardwert: 5000

## range_request_timeout_in_ms

Wie lange sollte der Koordinator warten, bis die Seq- oder Index-Scans abgeschlossen sind? Der niedrigste akzeptable Wert beträgt 10 ms.

Standardwert: 10000

## write_request_timeout_in_ms

Wie lange sollte der Koordinator warten, bis die Schreibvorgänge abgeschlossen sind? Der niedrigste akzeptable Wert beträgt 10 ms.

Standardwert: 2000

## counter_write_request_timeout_in_ms

Wie lange sollte der Koordinator warten, bis die Zählerschreibvorgänge abgeschlossen sind? Der niedrigste akzeptable Wert beträgt 10 ms.

Standardwert: 5000

## cas_contention_timeout_in_ms

Wie lange sollte ein Koordinator eine CAS-Operation wiederholen, die mit anderen Vorschlägen für dieselbe Zeile konkurriert? Der niedrigste akzeptable Wert beträgt 10 ms.

Standardwert: 1000

## truncate_request_timeout_in_ms

Wie lange der Koordinator warten soll, bis die Kürzungen abgeschlossen sind (Dies kann viel länger dauern, da wir, wenn auto_snapshot nicht deaktiviert ist, zuerst leeren müssen, damit wir vor dem Entfernen der Daten einen Snapshot erstellen können.) Der niedrigste akzeptable Wert beträgt 10 ms.

Standardwert: 60000

## request_timeout_in_ms

Das Standardzeitlimit für andere, verschiedene Vorgänge. Der niedrigste akzeptable Wert beträgt 10 ms.

Standardwert: 10000

## internode_application_send_queue_capacity_in_bytes

Diese Option ist standardmäßig auskommentiert.

Defensive Einstellungen zum Schutz von Cassandra vor echten Netzwerkpartitionen. Siehe (CASSANDRA-14358) für Details.

Die Zeit, die gewartet werden muss, bis Internode-TCP-Verbindungen hergestellt sind. internode_tcp_connect_timeout_in_ms = 2000

Die Zeitspanne, in der nicht bestätigte Daten für eine Verbindung zulässig sind, bevor die Verbindung unterbrochen wird. Beachten Sie, dass dies nur unter Linux + epoll unterstützt wird und sich ab Linux 4.12 seltsamerweise oberhalb einer Einstellung von 30000 (es dauert viel länger als 30 Sekunden) verhält . Wenn Sie etwas so Hoches wollen, setzen Sie dies auf 0, wodurch der Standard des Betriebssystems übernommen und das System net.ipv4.tcp_retries2 auf ~ 8 konfiguriert wird. internode_tcp_user_timeout_in_ms = 30000

Die maximale kontinuierliche Dauer einer Verbindung kann im Anwendungsbereich internode_application_timeout_in_ms = 30000 nicht beschreibbar sein

Globale Grenzwerte pro Endpunkt und pro Verbindung für Nachrichten, die für die Zustellung an andere Knoten in die Warteschlange gestellt werden und darauf warten, bei Ankunft von anderen Knoten im Cluster verarbeitet zu werden. Diese Grenzwerte gelten für die On-Wire-Größe der gesendeten oder empfangenen Nachricht.

Das grundlegende Limit pro Verbindung wird isoliert verwendet, bevor ein Endpunkt oder ein globales Limit festgelegt wird. Jedes Knotenpaar hat drei Verbindungen: dringend, klein und groß. Daher kann jeder Knoten maximal N * 3 * (internode_application_send_queue_capacity_in_bytes + internode_application_receive_queue_capacity_in_bytes) Nachrichten haben, die ohne Koordination zwischen ihnen in die Warteschlange gestellt werden, obwohl in der Praxis bei tokenbewusstem Routing nur RF * -Token-Knoten mit signifikanter Bandbreite kommunizieren müssen.

Das Limit pro Endpunkt gilt für alle Nachrichten, die das Limit pro Link überschreiten, gleichzeitig mit dem globalen Limit für alle Links zu oder von einem einzelnen Knoten im Cluster. Das globale Limit gilt für alle Nachrichten, die das Limit pro Verbindung überschreiten, gleichzeitig mit dem Limit pro Endpunkt für alle Links zu oder von einem beliebigen Knoten im Cluster.

Standardwert: 4194304 # 4MiB

## internode_application_send_queue_reserve_endpoint_capacity_in_bytes

Diese Option ist standardmäßig auskommentiert.

Standardwert: 134217728 # 128MiB

## internode_application_send_queue_reserve_global_capacity_in_bytes

Diese Option ist standardmäßig auskommentiert.

Standardwert: 536870912 # 512MiB

## internode_application_receive_queue_capacity_in_bytes

Diese Option ist standardmäßig auskommentiert.

Standardwert: 4194304 # 4MiB

## internode_application_receive_queue_reserve_endpoint_capacity_in_bytes

Diese Option ist standardmäßig auskommentiert.

Standardwert: 134217728 # 128MiB

## internode_application_receive_queue_reserve_global_capacity_in_bytes

Diese Option ist standardmäßig auskommentiert.

Standardwert: 536870912 # 512MiB

## slow_query_log_timeout_in_ms

Wie lange dauert es, bis ein Knoten langsame Abfragen protokolliert? Wenn Sie Abfragen auswählen, deren Ausführung länger als dieses Zeitlimit dauert, wird eine aggregierte Protokollnachricht generiert, sodass langsame Abfragen identifiziert werden können. Setzen Sie diesen Wert auf Null, um die langsame Abfrageprotokollierung zu deaktivieren.

Standardwert: 500

## cross_node_timeout

Diese Option ist standardmäßig auskommentiert.

Aktivieren Sie den Informationsaustausch über Betriebszeitlimits zwischen Knoten, um Anforderungszeitlimits genau zu messen. Wenn deaktiviert, gehen Replikate davon aus, dass Anforderungen sofort vom Koordinator an sie weitergeleitet wurden. Dies bedeutet, dass wir unter Überlastungsbedingungen so viel zusätzliche Zeit damit verschwenden, bereits abgelaufene Anforderungen zu verarbeiten.

Warnung: Es wird allgemein angenommen, dass Benutzer NTP in ihren Clustern eingerichtet haben und dass die Uhren nur geringfügig synchronisiert sind, da dies eine Voraussetzung für die allgemeine Korrektheit der letzten Schreibgewinne ist.

Standardwert: true

## streaming_keep_alive_period_in_secs

Diese Option ist standardmäßig auskommentiert.

Festlegen der Keep-Alive-Periode für das Streaming Dieser Knoten sendet regelmäßig eine Keep-Alive-Nachricht mit dieser Periode. Wenn der Knoten für 2 Keep-Alive-Zyklen keine Keep-Alive-Nachricht vom Peer empfängt, läuft die Stream-Sitzung ab und schlägt fehl. Der Standardwert ist 300s (5 Minuten). Dies bedeutet, dass der Stream für blockierte Streams standardmäßig in 10 Minuten abgelaufen ist

Standardwert: 300

## streaming_connections_per_host

Diese Option ist standardmäßig auskommentiert.

Begrenzen Sie die Anzahl der Verbindungen pro Host für das Streaming. Erhöhen Sie diese Anzahl, wenn Sie feststellen, dass Joins eher an die CPU als an das Netzwerk gebunden sind (z. B. einige Knoten mit großen Dateien).

Standardwert: 1

## phi_convict_threshold

Diese Option ist standardmäßig auskommentiert.

Phi-Wert, der erreicht werden muss, damit ein Host markiert wird. Die meisten Benutzer sollten dies niemals anpassen müssen.

Standardwert: 8

## endpoint_snitch

endpoint_snitch - Setzen Sie dies auf eine Klasse, die IEndpointSnitch implementiert. Der Schnatz hat zwei Funktionen:

Es lehrt Cassandra genug über Ihre Netzwerktopologie, um Anforderungen effizient weiterzuleiten
Dadurch kann Cassandra Replikate in Ihrem Cluster verteilen, um korrelierte Fehler zu vermeiden. Dazu werden Maschinen in "Rechenzentren" und "Racks" gruppiert. Cassandra wird ihr Bestes tun, um nicht mehr als ein Replikat auf demselben „Rack" zu haben (das möglicherweise kein physischer Standort ist).
CASSANDRA ERLAUBT NICHT, AUF EINEN INKOMPATIBLEN SCHALTER ZU SCHALTEN, WENN DATEN IN DEN CLUSTER EINGEFÜGT SIND. Dies würde zu Datenverlust führen. Wenn Sie also mit dem Standard-SimpleSnitch beginnen, der jeden Knoten auf "Rack1" in "Datencenter1" findet, müssen Sie nur GossipingPropertyFileSnitch (und das ältere PFS) hinzufügen, wenn Sie ein weiteres Datencenter hinzufügen müssen. Wenn Sie von dort zu einem inkompatiblen Snitch wie Ec2Snitch migrieren möchten, können Sie dies tun, indem Sie unter Ec2Snitch neue Knoten hinzufügen (die sie in einem neuen „Rechenzentrum" lokalisieren) und die alten außer Betrieb nehmen.

Cassandra bietet sofort:

SimpleSnitch:
Behandelt Strategieordnung als Nähe. Dies kann die Cache-Lokalität verbessern, wenn die Lesereparatur deaktiviert wird. Nur für Bereitstellungen mit nur einem Rechenzentrum geeignet.
GossipingPropertyFileSnitch
Dies sollte Ihr Anlaufpunkt für die Produktion sein. Das Rack und das Datencenter für den lokalen Knoten werden in cassandra-rackdc.properties definiert und über Klatsch an andere Knoten weitergegeben. Wenn cassandra-topology.properties vorhanden ist, wird es als Fallback verwendet, um die Migration von PropertyFileSnitch zu ermöglichen.
PropertyFileSnitch:
Die Nähe wird durch das Rack und das Rechenzentrum bestimmt, die explizit in cassandra-topology.properties konfiguriert sind.
Ec2Snitch:
Geeignet für EC2-Bereitstellungen in einer einzelnen Region. Lädt Informationen zu Region und Verfügbarkeitszone aus der EC2-API. Die Region wird als Rechenzentrum und die Verfügbarkeitszone als Rack behandelt. Es werden nur private IPs verwendet, sodass dies nicht in mehreren Regionen funktioniert.
Ec2MultiRegionSnitch:
Verwendet öffentliche IP-Adressen als Broadcast-Adresse, um regionale Verbindungen zu ermöglichen. (Daher sollten Sie auch Startadressen für die öffentliche IP festlegen.) Sie müssen den storage_port oder ssl_storage_port in der öffentlichen IP-Firewall öffnen. (Für den Verkehr innerhalb der Region wechselt Cassandra nach dem Herstellen einer Verbindung zur privaten IP.)
RackInferringSnitch:
Die Nähe wird durch das Rack und das Rechenzentrum bestimmt, von denen angenommen wird, dass sie dem 3. bzw. 2. Oktett der IP-Adresse jedes Knotens entsprechen. Sofern dies nicht Ihren Bereitstellungskonventionen entspricht, wird dies am besten als Beispiel für das Schreiben einer benutzerdefinierten Snitch-Klasse verwendet und in diesem Sinne bereitgestellt.
Sie können einen benutzerdefinierten Schnatz verwenden, indem Sie diesen auf den vollständigen Klassennamen des Schnatzes setzen, von dem angenommen wird, dass er sich in Ihrem Klassenpfad befindet.

Standardwert: SimpleSnitch

## dynamic_snitch_update_interval_in_ms

Steuert, wie oft der teurere Teil der Host-Score-Berechnung durchgeführt werden soll

Standardwert: 100

## dynamic_snitch_reset_interval_in_ms

Steuert, wie oft alle Host-Scores zurückgesetzt werden sollen, damit sich ein schlechter Host möglicherweise erholen kann

Standardwert: 600000

## dynamic_snitch_badness_threshold

Wenn der Wert größer als Null ist, können Replikate an Hosts angeheftet werden, um die Cache-Kapazität zu erhöhen. Die Badness-Schwelle steuert, wie viel schlechter der angeheftete Host sein muss, bevor der dynamische Schnatz andere Replikate ihm vorziehen wird. Dies wird als Doppel ausgedrückt, das einen Prozentsatz darstellt. Ein Wert von 0,2 bedeutet also, dass Cassandra weiterhin die statischen Schnatzwerte bevorzugt, bis der angeheftete Host 20% schlechter als der schnellste war.

Standardwert: 0.1

## server_encryption_options

Aktivieren oder Deaktivieren der JVM-Verschlüsselung zwischen Knoten und Netty-Standardeinstellungen für unterstützte SSL-Socket-Protokolle und Cipher Suites können mithilfe benutzerdefinierter Verschlüsselungsoptionen ersetzt werden. Dies wird nur empfohlen, wenn Sie über Richtlinien verfügen, die bestimmte Einstellungen vorschreiben, oder anfällige Chiffren oder Protokolle deaktivieren müssen, falls die JVM nicht aktualisiert werden kann. FIPS-kompatible Einstellungen können auf JVM-Ebene konfiguriert werden und sollten keine Änderung der Verschlüsselungseinstellungen beinhalten: https://docs.oracle.com/javase/8/docs/technotes/guides/security/jsse/FIPS.html

HINWEIS Derzeit sind keine benutzerdefinierten Verschlüsselungsoptionen aktiviert. Die verfügbaren Internodienoptionen sind: Alle, Keine, DC, Rack. Bei Einstellung auf DC-Kassandra wird der Datenverkehr zwischen den DCs verschlüsselt. Bei Einstellung auf Rack verschlüsselt Cassandra den Datenverkehr zwischen den Racks

Die in diesen Optionen verwendeten Kennwörter müssen mit den Kennwörtern übereinstimmen, die beim Generieren des Keystores und des Truststores verwendet werden. Anweisungen zum Generieren dieser Dateien finden Sie unter: http://download.oracle.com/javase/8/docs/technotes/guides/security/jsse/JSSERefGuide.html#CreateKeystore

Standardwert (komplexe Option) :

```s
# set to true for allowing secure incoming connections
enabled: false
# If enabled and optional are both set to true, encrypted and unencrypted connections are handled on the storage_port
optional: false
# if enabled, will open up an encrypted listening socket on ssl_storage_port. Should be used
# during upgrade to 4.0; otherwise, set to false.
enable_legacy_ssl_storage_port: false
# on outbound connections, determine which type of peers to securely connect to. 'enabled' must be set to true.
internode_encryption: none
keystore: conf/.keystore
keystore_password: cassandra
truststore: conf/.truststore
truststore_password: cassandra
# More advanced defaults below:
# protocol: TLS
# store_type: JKS
# cipher_suites: [TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA]
# require_client_auth: false
# require_endpoint_verification: false
```

## client_encryption_options

Aktivieren oder Deaktivieren der Client-Server-Verschlüsselung.

Standardwert (komplexe Option) :

```s
enabled: false
# If enabled and optional is set to true encrypted and unencrypted connections are handled.
optional: false
keystore: conf/.keystore
keystore_password: cassandra
# require_client_auth: false
# Set trustore and truststore_password if require_client_auth is true
# truststore: conf/.truststore
# truststore_password: cassandra
# More advanced defaults below:
# protocol: TLS
# store_type: JKS
# cipher_suites: [TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA]
internode_compression
internode_compression steuert, ob der Verkehr zwischen Knoten komprimiert wird. Kann sein:

alle
Der gesamte Datenverkehr wird komprimiert
dc
Der Datenverkehr zwischen verschiedenen Rechenzentren wird komprimiert
keiner
nichts wird komprimiert.
```

Standardwert: dc

## inter_dc_tcp_nodelay

Aktivieren oder deaktivieren Sie tcp_nodelay für die Kommunikation zwischen Gleichstrom. Wenn Sie es deaktivieren, werden größere (aber weniger) Netzwerkpakete gesendet, wodurch der Overhead des TCP-Protokolls selbst verringert wird. Dies führt zu einer Erhöhung der Latenz, wenn Sie datencenterübergreifende Antworten blockieren.

Standardwert: false

## tracetype_query_ttl

TTL für verschiedene Trace-Typen, die während der Protokollierung des Reparaturprozesses verwendet werden.

Standardwert: 86400

tracetype_repair_ttl
Standardwert: 604800

## enable_user_defined_functions

Wenn nicht festgelegt, werden alle GC-Pausen, die größer als gc_log_threshold_in_ms sind, auf INFO-Ebene protokolliert. UDFs (benutzerdefinierte Funktionen) sind standardmäßig deaktiviert. Ab Cassandra 3.0 gibt es eine Sandbox, die die Ausführung von bösem Code verhindern soll.

Standardwert: false

## enable_scripted_user_defined_functions

Aktiviert geskriptete UDFs (JavaScript-UDFs). Java-UDFs sind immer aktiviert, wenn enable_user_defined_functions true ist. Aktivieren Sie diese Option, um UDFs mit "Sprach-Javascript" oder einem benutzerdefinierten JSR-223-Anbieter verwenden zu können. Diese Option hat keine Auswirkung, wenn enable_user_defined_functions false ist.

Standardwert: false

## windows_timer_interval

Der Standard-Windows-Kernel-Timer und die Planungsauflösung für die Energieeinsparung betragen 15,6 ms. Das Verringern dieses Werts unter Windows kann zu einer viel kürzeren Latenz und einem besseren Durchsatz führen. In einigen virtualisierten Umgebungen kann es jedoch zu negativen Auswirkungen auf die Leistung kommen, wenn diese Einstellung unter ihren Systemstandards geändert wird. Das Sysinternals-Tool "clockres" kann die Standardeinstellung Ihres Systems bestätigen.

Standardwert: 1

## transparent_data_encryption_options

Aktiviert die Verschlüsselung ruhender Daten (auf der Festplatte). Es können verschiedene Schlüsselanbieter angeschlossen werden, die Standardeinstellung lautet jedoch aus einem Schlüsselspeicher im JCE-Stil. Ein einzelner Schlüsselspeicher kann mehrere Schlüssel enthalten, aber der Schlüssel, auf den durch "key_alias" verwiesen wird, ist der einzige Schlüssel, der zum Verschlüsseln von Vorgängen verwendet wird. Zuvor verwendete Schlüssel können (und sollten!) sich noch im Schlüsselspeicher befinden und werden bei Entschlüsselungsvorgängen verwendet (um den Fall der Schlüsselrotation zu behandeln).

Es wird dringend empfohlen, JCE-Richtliniendateien (Java Cryptography Extension) für Ihre Version des JDK herunterzuladen und zu installieren. (aktueller Link: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html )

Derzeit werden nur die folgenden Dateitypen für eine transparente Datenverschlüsselung unterstützt, obwohl in zukünftigen Cassandra-Versionen weitere hinzukommen: Commitlog, Hinweise

Standardwert (komplexe Option) :

```s
enabled: false
chunk_length_kb: 64
cipher: AES/CBC/PKCS5Padding
key_alias: testing:1
# CBC IV length for AES needs to be 16 bytes (which is also the default size)
# iv_length: 16
key_provider:
  - class_name: org.apache.cassandra.security.JKSKeyProvider
    parameters:
      - keystore: conf/.keystore
        keystore_password: cassandra
        store_type: JCEKS
        key_password: cassandra
```

## tombstone_warn_threshold

SICHERHEITS-SCHWELLEN # 
Wenn Sie einen Scan innerhalb oder zwischen einer Partition ausführen, müssen die Tombstones im Speicher bleiben, damit wir sie an den Koordinator zurückgeben können, der sie verwendet, um sicherzustellen, dass auch andere Replikate über die gelöschten Zeilen informiert sind. Bei Workloads, die viele Tombstones generieren, kann dies zu Leistungsproblemen führen und sogar den Server-Heap belasten. ( http://www.datastax.com/dev/blog/cassandra-anti-patterns-queues-and-queue-like-datasets ) Passen Sie die Schwellenwerte hier an, wenn Sie die Gefahren verstehen und trotzdem mehr Grabsteine ​​scannen möchten. Diese Schwellenwerte können auch zur Laufzeit mithilfe der StorageService-MBean angepasst werden.

Standardwert: 1000

## tombstone_failure_threshold

Standardwert: 100000

batch_size_warn_threshold_in_kb
Protokollieren Sie WARN bei jeder Stapelgröße mit mehreren Partitionen, die diesen Wert überschreitet. Standardmäßig 5 KB pro Stapel. Bei der Vergrößerung dieses Schwellenwerts ist Vorsicht geboten, da dies zu einer Knoteninstabilität führen kann.

Standardwert: 5

## batch_size_fail_threshold_in_kb

Fehler bei Stapeln mit mehreren Partitionen, die diesen Wert überschreiten. Standardmäßig 50 KB (10x Warnschwelle).

Standardwert: 50

## unlogged_batch_across_partitions_warn_threshold

Protokollieren Sie WARN für alle Stapel, die nicht vom Typ LOGGED sind und sich über mehr Partitionen als diesen Grenzwert erstrecken

Standardwert: 10

## compaction_large_partition_warning_threshold_mb

Protokollieren Sie eine Warnung, wenn Sie Partitionen komprimieren, die größer als dieser Wert sind

Standardwert: 100

## gc_log_threshold_in_ms

Diese Option ist standardmäßig auskommentiert.

GC-Pausen von mehr als 200 ms werden auf INFO-Ebene protokolliert. Dieser Schwellenwert kann angepasst werden, um die Protokollierung bei Bedarf zu minimieren

Standardwert: 200

## gc_warn_threshold_in_ms

Diese Option ist standardmäßig auskommentiert.

GC-Pausen größer als gc_warn_threshold_in_ms werden auf WARN-Ebene protokolliert. Passen Sie den Schwellenwert basierend auf Ihren Anwendungsdurchsatzanforderungen an. Wenn Sie den Wert auf 0 setzen, wird die Funktion deaktiviert.

Standardwert: 1000

## max_value_size_in_mb

Diese Option ist standardmäßig auskommentiert.

Maximale Größe eines beliebigen Werts in SSTables. Sicherheitsmaßnahme zur frühzeitigen Erkennung von SSTable-Korruption. Jede Wertgröße, die größer als dieser Schwellenwert ist, führt dazu, dass eine SSTable als beschädigt markiert wird. Dies sollte positiv sein und unter 2048 liegen.

Standardwert: 256

## back_pressure_enabled

Gegendruckeinstellungen # Wenn diese Option aktiviert ist, wendet der Koordinator die unten angegebene Gegendruckstrategie auf jede an Replikate gesendete Mutation an, um den Druck auf überlastete Replikate zu verringern.

Standardwert: false

## back_pressure_strategy

Die Gegendruckstrategie angewendet. Die Standardimplementierung, RateBasedBackPressure, verwendet drei Argumente: hohes Verhältnis, Faktor und Flusstyp und verwendet das Verhältnis zwischen eingehenden Mutationsantworten und ausgehenden Mutationsanforderungen. Wenn sie unter dem hohen Verhältnis liegen, sind ausgehende Mutationen entsprechend der um den gegebenen Faktor verringerten eingehenden Rate ratenbegrenzt. wenn über dem hohen Verhältnis, wird die Ratenbegrenzung um den gegebenen Faktor erhöht; Ein solcher Faktor wird normalerweise am besten zwischen 1 und 10 konfiguriert. Verwenden Sie größere Werte für eine schnellere Wiederherstellung auf Kosten potenziell mehr fallengelassener Mutationen. Die Ratenbegrenzung wird entsprechend dem Flusstyp angewendet: Wenn SCHNELL, ist sie mit der Geschwindigkeit des schnellsten Replikats ratenbegrenzt, wenn sie mit der Geschwindigkeit des langsamsten langsam ist. Neue Strategien können hinzugefügt werden. Implementierer müssen org.apache.cassandra.net implementieren.

## otc_coalescing_strategy

Diese Option ist standardmäßig auskommentiert.

Koaleszenzstrategien # Durch das Zusammenführen mehrerer Nachrichten wird der Durchsatz der Nachrichtenverarbeitung erheblich gesteigert (Verdoppelung oder mehr). Auf Bare-Metal-Basis ist der Boden für den Durchsatz der Paketverarbeitung hoch genug, dass viele Anwendungen dies nicht bemerken. In virtualisierten Umgebungen kann der Punkt, an dem eine Anwendung durch die Netzwerkpaketverarbeitung gebunden werden kann, im Vergleich zum Durchsatz der Aufgabenverarbeitung überraschend niedrig sein Das ist innerhalb einer VM möglich. Es ist nicht so, dass Bare-Metal nicht von der Zusammenführung von Nachrichten profitiert, sondern dass die Anzahl der Pakete, die eine Bare-Metal-Netzwerkschnittstelle verarbeiten kann, für viele Anwendungen ausreicht, sodass auch ohne Zusammenführung kein Lastmangel auftritt. Das Zusammenführen von Netzwerknachrichten bietet weitere Vorteile, die mit einer einfachen Metrik wie Nachrichten pro Sekunde schwerer zu isolieren sind. Durch das Zusammenführen mehrerer Aufgaben kann ein Netzwerkthread mehrere Nachrichten für die Kosten einer Reise verarbeiten, um sie von einem Socket zu lesen, und alle Aufgaben zur Aufgabenübermittlung können gleichzeitig ausgeführt werden, wodurch die Kontextumschaltung verringert und die Cache-Freundlichkeit der Netzwerknachrichtenverarbeitung erhöht wird. Siehe CASSANDRA-8692 für Details.

Strategie zum Zusammenführen von Nachrichten in OutboundTcpConnection. Kann behoben, gleitender Durchschnitt, Zeithorizont, deaktiviert werden (Standard). Sie können auch eine Unterklasse von CoalescingStrategies.CoalescingStrategy nach Namen angeben.

Standardwert: DEAKTIVIERT

## otc_coalescing_window_us

Diese Option ist standardmäßig auskommentiert.

Wie viele Mikrosekunden müssen auf das Zusammenwachsen warten? Bei einer festen Strategie ist dies die Zeitspanne nach dem Empfang der ersten Nachricht, bevor sie mit den zugehörigen Nachrichten gesendet wird. Für den gleitenden Durchschnitt ist dies die maximale Wartezeit sowie das Intervall, in dem Nachrichten durchschnittlich eintreffen müssen, damit das Zusammenführen aktiviert werden kann.

Standardwert: 200

## otc_coalescing_enough_coalesced_messages

Diese Option ist standardmäßig auskommentiert.

Versuchen Sie nicht, Nachrichten zusammenzuführen, wenn wir bereits so viele Nachrichten erhalten haben. Dies sollte mehr als 2 und weniger als 128 sein.

Standardwert: 8

## otc_backlog_expiration_interval_ms

Diese Option ist standardmäßig auskommentiert.

Wie viele Millisekunden zwischen zwei Ablaufabläufen im Backlog (Warteschlange) der OutboundTcpConnection zu warten sind. Der Ablauf ist abgeschlossen, wenn sich Nachrichten im Backlog häufen. Löschbare Nachrichten sind abgelaufen, um den von abgelaufenen Nachrichten belegten Speicher freizugeben. Das Intervall sollte zwischen 0 und 1000 liegen, und in den meisten Installationen ist der Standardwert angemessen. Ein kleinerer Wert kann Nachrichten möglicherweise etwas früher ablaufen lassen, was zu mehr CPU-Zeit und Warteschlangenkonflikten führt, während der Nachrichtenstau wiederholt wird. Ein Intervall von 0 deaktiviert jede Wartezeit, wie dies bei früheren Cassandra-Versionen der Fall ist.

Standardwert: 200

## ideal_consistency_level

Diese Option ist standardmäßig auskommentiert.

Verfolgen Sie eine Metrik pro Schlüsselbereich, die angibt, ob die Replikation die ideale Konsistenzstufe für Schreibvorgänge ohne Zeitüberschreitung erreicht hat. Dies unterscheidet sich von der Konsistenzstufe, die von jedem Schreibvorgang angefordert wird und möglicherweise niedriger ist, um die Verfügbarkeit zu erleichtern.

Standardwert: EACH_QUORUM

## automatic_sstable_upgrade

Diese Option ist standardmäßig auskommentiert.

Automatische Aktualisierung von sstables nach dem Upgrade - Wenn keine normale Komprimierung erforderlich ist, wird der älteste nicht aktualisierte sstable auf die neueste Version aktualisiert

Standardwert: false

## max_concurrent_automatic_sstable_upgrades

Diese Option ist standardmäßig auskommentiert. Begrenzen Sie die Anzahl gleichzeitiger stabiler Upgrades

Standardwert: 1

## audit_logging_options

Überwachungsprotokollierung - Protokolliert jede eingehende CQL-Befehlsanforderung und Authentifizierung an einen Knoten. Ausführliche Informationen zu den verschiedenen Konfigurationsoptionen finden Sie in den Dokumenten zu audit_logging.

## full_query_logging_options

Diese Option ist standardmäßig auskommentiert.

Standardoptionen für die vollständige Abfrageprotokollierung - Diese können über die Befehlszeile überschrieben werden, wenn nodetool enablefullquerylog ausgeführt wird

## corrupted_tombstone_strategy

Diese Option ist standardmäßig auskommentiert.

Das Überprüfen von Grabsteinen beim Lesen und Komprimieren kann entweder "deaktiviert", "warnen" oder "Ausnahme" sein.

Standardwert: deaktiviert

## diagnostic_events_enabled

Diagnoseereignisse # Wenn diese Option aktiviert ist, können Diagnoseereignisse bei der Behebung von Betriebsproblemen hilfreich sein. Emittierte Ereignisse enthalten Details zum internen Status und zu zeitlichen Beziehungen zwischen Ereignissen, auf die Clients über JMX zugreifen können.

Standardwert: false

## native_transport_flush_in_batches_legacy

Diese Option ist standardmäßig auskommentiert.

Verwenden Sie die native TCP-Nachrichtenverschmelzung für den Transport. Wenn Sie beim Upgrade auf 4.0 feststellen, dass Ihr Durchsatz abnimmt und Sie insbesondere einen alten Kernel ausführen oder weniger Clientverbindungen haben, ist diese Option möglicherweise eine Bewertung wert.

Standardwert: false

## repaired_data_tracking_for_range_reads_enabled

Aktivieren der Verfolgung des reparierten Datenstatus während des Lesens und des Vergleichs zwischen Replikaten Fehlanpassungen zwischen den reparierten Replikatsätzen können entweder als bestätigt oder als nicht bestätigt charakterisiert werden. In diesem Zusammenhang bedeutet unbestätigt, dass das Vorhandensein anstehender Reparatursitzungen, nicht reparierter Partitions-Grabsteine ​​oder einer anderen Bedingung dazu führt, dass die Disparität nicht als schlüssig angesehen werden kann. Bestätigte Nichtübereinstimmungen sollten ein Auslöser für Untersuchungen sein, da sie auf Korruption oder Datenverlust hinweisen können. Es gibt separate Flags für Lesevorgänge zwischen Bereich und Partition, da einzelne Partitionslesevorgänge nur verfolgt werden, wenn CL> 1 ist und eine Digest-Nichtübereinstimmung auftritt. Derzeit verwenden Bereichsabfragen keine Digests. Wenn diese Option für Bereichslesevorgänge aktiviert ist, enthalten alle Bereichslesevorgänge eine reparierte Datenverfolgung. Da dies etwas Overhead hinzufügt,

Standardwert: false

## repaired_data_tracking_for_partition_reads_enabled

Standardwert: false

report_unconfirmed_repaired_data_mismatches
Bei false werden nur bestätigte Nichtübereinstimmungen gemeldet. Wenn dies der Fall ist, wird auch eine separate Metrik für nicht bestätigte Nichtübereinstimmungen aufgezeichnet. Dies dient dazu, potenzielle Signale zu vermeiden: Rauschprobleme sind unbestätigte Fehlanpassungen sind weniger umsetzbar als bestätigte.

Standardwert: false

## enable_materialized_views

EXPERIMENTELLE MERKMALE #
Aktiviert die Erstellung einer materialisierten Ansicht auf diesem Knoten. Materialisierte Ansichten gelten als experimentell und werden für die Verwendung in der Produktion nicht empfohlen.

Standardwert: false

## enable_sasi_indexes

Aktiviert die SASI-Indexerstellung auf diesem Knoten. SASI-Indizes gelten als experimentell und werden für die Verwendung in der Produktion nicht empfohlen.

Standardwert: false

## enable_transient_replication

Ermöglicht die Erstellung vorübergehend replizierter Schlüsselbereiche auf diesem Knoten. Die vorübergehende Replikation ist experimentell und wird für die Verwendung in der Produktion nicht empfohlen.

Standardwert: false
