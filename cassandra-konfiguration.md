# Cassandra konfigurieren

Um Cassandra auf einem einzelnen Knoten auszuführen, reicht die Standardkonfigurationsdatei ./conf/cassandra.yamlaus. Sie sollten keine Konfiguration ändern müssen. Wenn Sie jedoch einen Cluster von Knoten bereitstellen oder Clients verwenden, die sich nicht auf demselben Host befinden, müssen einige Parameter geändert werden.

Die Cassandra-Konfigurationsdateien befinden sich im confVerzeichnis der Tarballs. Bei Paketen befinden sich die Konfigurationsdateien in /etc/cassandra.

## Laufzeit Eigenschaften

Der größte Teil der Konfiguration in Cassandra erfolgt über Yaml-Eigenschaften, die festgelegt werden können cassandra.yaml. Sie sollten mindestens die folgenden Eigenschaften festlegen:

* cluster_name : Der Name Ihres Clusters.
* seeds : Eine durch Kommas getrennte Liste der IP-Adressen Ihrer Cluster-Seeds.
* storage_port : Sie müssen dies nicht unbedingt ändern, aber stellen Sie sicher, dass keine Firewalls diesen Port blockieren.
* listen_address : Die IP-Adresse Ihres Knotens. Dadurch können andere Knoten mit diesem Knoten kommunizieren. Daher ist es wichtig, dass Sie ihn ändern. Alternativ können Sie listen_interfaceCassandra mitteilen, welche Schnittstelle verwendet werden soll und welche Adresse nacheinander verwendet werden soll. Stellen Sie nur einen ein, nicht beide.
* native_transport_port : Stellen Sie bei storage_port sicher, dass dieser Port nicht von Firewalls blockiert wird, da Clients über diesen Port mit Cassandra kommunizieren.
Ändern des Speicherorts von Verzeichnissen
Die folgenden yaml-Eigenschaften steuern den Speicherort von Verzeichnissen:

data_file_directories: ein oder mehrere Verzeichnisse, in denen sich Datendateien befinden.
commitlog_directory: Das Verzeichnis, in dem sich Commitlog-Dateien befinden.
saved_caches_directory: Das Verzeichnis, in dem sich gespeicherte Caches befinden.
hints_directory: das Verzeichnis, in dem sich Hinweise befinden.
Wenn Sie aus Leistungsgründen über mehrere Festplatten verfügen, sollten Sie Commitlog- und Datendateien auf verschiedenen Festplatten ablegen.

## Umgebungsvariablen

Einstellungen auf JVM-Ebene wie die Größe des Heapspeichers können in festgelegt werden cassandra-env.sh. Sie können der JVM_OPTSUmgebungsvariablen jedes zusätzliche JVM-Befehlszeilenargument hinzufügen . Wenn Cassandra startet, werden diese Argumente an die JVM übergeben.

## Protokollierung

Der verwendete Logger ist Logback. Sie können die Protokollierungseigenschaften durch Bearbeiten ändern logback.xml. Standardmäßig wird es auf INFO-Ebene in einer aufgerufenen Datei system.logund auf Debug-Ebene in einer aufgerufenen Datei angemeldet debug.log. Wenn es im Vordergrund ausgeführt wird, wird es auch auf INFO-Ebene an der Konsole protokolliert.
