Dieser Abschnitt wird Hadoop vorstellen, erklären, wie man den Hadoop Stack auf Mesos einrichtet und die Probleme beseitigt, die bei der Einrichtung des Stapels häufig auftreten.
Einführung in Hadoop

Hadoop wurde von Mike Cafarella und Doug Cutting im Jahr 2006 entwickelt, um die Distribution für das Nutch-Projekt zu verwalten. Das Projekt wurde nach Dougs Spielzeug-Elefanten benannt.

Die folgenden Module bilden das Apache Hadoop Framework:

* **Hadoop Common**: Dies hat die üblichen Bibliotheken und Dienstprogramme, die von anderen Modulen benötigt werden

* **Hadoop Distributed File System (HDFS)**: Dies ist ein verteiltes, skalierbares Dateisystem, das in der Lage ist, Petabyte von Daten auf Rohstoffhardware zu speichern

* **Hadoop YARN**: Dies ist ein Ressourcen-Manager, um Cluster-Ressourcen zu verwalten (ähnlich wie Mesos)

* **Hadoop MapReduce**: Dies ist ein Verarbeitungsmodell für die parallele Datenverarbeitung im Maßstab


## MapReduce

MapReduce ist ein Verarbeitungsmodell, mit dem große Datenmengen auf einer verteilten, gruppenbasierten Infrastruktur zuverlässig und fehlertolerant verarbeitet werden können.

Das Wort MapReduce ist eine Kombination aus Map und Reduce Tasks, die hier beschrieben werden:

* Der **Map Task**: In diesem Schritt wird eine Operation an allen Elementen des Eingabedatensatzes durchgeführt, um sie nach Bedarf zu transformieren (zB Anwendung einer Filterbedingung)

* **The Reduce Task**: Der nächste Schritt verwendet die von der Map-Task erzeugte Ausgabe als Eingabe und wendet eine aggregierte Operation an, um die endgültige Ausgabe zu erzeugen (z. B. Summierung aller Werte)

Die Planung, Durchführung und Überwachung der Aufgaben erfolgt zuverlässig durch den Rahmen, ohne dass der Anwendungsprogrammierer sich darum kümmern muss.
Hadoop Distributed File System

Basierend auf Google Filesystem oder GFS bietet Hadoop Distributed File System (HDFS) ein skalierbares, verteiltes Dateisystem, um große Datenmengen zuverlässig und fehlertolerant zu speichern.

HDFS basiert auf einer Master / Slave-Architektur, wobei der Master aus einem einsamen NamensNode besteht, der die Metadaten des Dateisystems verarbeitet und einzelne oder mehrere Slave-Knoten, die die Daten speichern und auch als **DataNode** bezeichnet werden.

Jede Datei in HDFS wird in mehrere Blöcke unterteilt, wobei jeder dieser Blöcke in DataNode gespeichert ist. **NameNode** ist verantwortlich für die Aufrechterhaltung von Informationen darüber, welcher Block vorhanden ist, in welchem ​​DataNode. Operationen wie Lesen / Schreiben werden von DataNode zusammen mit Blockverwaltungsaufgaben wie dem Erstellen, Entfernen und Replizieren von Anweisungen von NameNode behandelt.

Interaktion ist durch eine Shell, wo ein Satz von Befehlen verwendet werden kann, um mit dem Dateisystem zu kommunizieren.

![hdf-architecture](https://www.packtpub.com/graphics/9781785886249/graphics/B05186_08_01.jpg)

## Hadoop auf Mesos aufstellen

In diesem Abschnitt wird erklärt, wie man Hadoop auf Mesos einrichtet. Eine bestehende Hadoop-Distribution kann auch auf Mesos aufgebaut werden. Um Hadoop auf Mesos laufen zu lassen, muss unsere Hadoop-Distribution `Hadoop-Mesos-0.1.0.jar` enthalten (die Version zum Zeitpunkt des Schreibens dieses Buches). Dies ist für jede Hadoop-Distribution erforderlich, die eine Protobuf-Version höher als 2.5.0 verwendet. Wir werden auch einige Konfigurationseigenschaften setzen, um das Setup abzuschließen, wie nachfolgend erläutert wird. Beachten Sie, dass zum Zeitpunkt des Schreibens dieses Kapitels YARN und MRv2 nicht unterstützt werden.

Lassen Sie uns die hier erwähnten Schritte folgen:

1. Öffnen Sie das Terminal auf Ihrem Cluster und feuern Sie die folgenden Befehle auf, um Hadoop auf Mesos einzurichten:
```
# Install snappy-java package if not alr
eady installed.
$ sudo apt-get install libsnappy-dev

# Clone the repository
$ git clone https://github.com/Mesos/Hadoop

$ cd Hadoop

# Build the Hadoop-Mesos-0.1.0.jar
$ mvn package
```

2. Sobald der vorherige Befehl ausgeführt wird, wird es das `target/Hadoop-Mesos-0.1.0.jar` Jar erstellen.

Eine Sache, die hier zu beachten ist, dass wenn Sie eine ältere Version von Mesos haben und das Glas gegen diese Version bauen müssen, dann müssen Sie die Datei `pom.xml` mit der entsprechenden Version bearbeiten. Wir können die folgenden Versionen in der Datei `pom.xml` ändern:
```
  <!-- runtime deps versions -->
  <commons-logging.version>1.1.3</commons-logging.version>
  <commons-httpclient.version>3.1</commons-httpclient.version>
<Hadoop-client.version>2.5.0-mr1-cdh5.2.0</Hadoop-client.version>
  <Mesos.version>0.23.1</Mesos.version>
  <protobuf.version>2.5.0</protobuf.version>
  <metrics.version>3.1.0</metrics.version>
  <snappy-java.version>1.0.5</snappy-java.version>
```

3. Jetzt können wir eine Hadoop-Distribution herunterladen. Wie Sie hier sehen können, haben wir das `Hadoop-Mesos jar` mit der Version` hasoop-2.5.0-mr1-cdh5.2.0` kompiliert. Es kann mit folgendem Befehl heruntergeladen werden:
```
$ wget 
http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.5.0-cdh5.2.0.tar.gz
# Extract the contents
$ tar zxf hadoop-2.5.0-cdh5.2.0.tar.gz
```

4. Jetzt müssen wir `Hadoop-Mesos-0.1.0.jar` in die Hadoop `share/Hadoop/common/lib` Verzeichnis kopieren. Dies geschieht wie hier gezeigt:
`$ cp hadoop-Mesos-0.1.0.jar hadoop-2.5.0-cdh5.2.0/share/hadoop/common/lib/`

5. Wir müssen nun die Symlinks der CHD5-Distribution aktualisieren, um auf die richtige Version zu verweisen (da sie sowohl MRv1 als auch MRv2 (YARN) enthält) mit den folgenden Befehlssätzen:
```
$ cd hadoop-2.5.0-cdh5.2.0
$ mv bin bin-mapreduce2
$ mv examples examples-mapreduce2 
$ ln -s bin-mapreduce1 bin
$ ln -s examples-mapreduce1 examples

$ pushd etc
$ mv hadoop hadoop-mapreduce2
$ ln -s hadoop-mapreduce1 Hadoop
$ popd
$ pushd share/hadoop
$ rm mapreduce
$ ln -s mapreduce1 mapreduce
$ popd 
```

6. Alle Konfigurationen sind nun fertig. Wir können die Hadoop-Distribution auf unser bestehendes Hadoop Distributed File System (HDFS) -System archivieren und hochladen, wo es von Mesos zugänglich ist. Schauen Sie sich die folgenden Befehle an:

```
$ tar czf hadoop-2.5.0-cdh5.2.0.tar.gz hadoop-2.5.0-cdh5.2.0
$ hadoop fs -put hadoop-2.5.0-cdh5.2.0.tar.gz /hadoop-2.5.0-cdh5.2.0.tar.gz
```

7. Sobald Sie fertig sind, können wir `JobTracker` konfigurieren, um jeden `TaskTracker` Knoten auf Mesos zu starten, indem er die Datei `maped-site.xml` wie folgt editiert:
```
<property>
  <name>mapred.job.tracker</name>
  <value>localhost:9001</value>
</property>

<property>
  <name>mapred.jobtracker.taskScheduler</name>
  <value>org.apache.Hadoop.mapred.MesosScheduler</value>
</property>

<property>
  <name>mapred.Mesos.taskScheduler</name>
  <value>org.apache.Hadoop.mapred.JobQueueTaskScheduler</value>
</property>

<property>
  <name>mapred.Mesos.master</name>
  <value>localhost:5050</value>
</property>

<property>
  <name>mapred.Mesos.executor.uri</name>
  <value>hdfs://localhost:9000/Hadoop-2.5.0-cdh5.2.0.tar.gz</value>
</property>
```
8. Ein paar Eigenschaften in der `mapred-Site.xml` Datei sind Mesos-spezifisch, wie `mapred.Mesos.master` oder `mapred.Mesos.executor.uri`.

9. Wir können nun den `JobTracker` Dienst starten, indem wir die Mesos-Bibliothek mit folgendem Befehl einschließen:

`$ MESOS_NATIVE_LIBRARY=/path/to/libMesos.so Hadoop jobtracker`


## Eine erweiterte Konfigurationsanleitung

Weitere Details zu den Konfigurationseinstellungen in Mesos finden Sie unter https://github.com/mesos/hadoop/blob/master/configuration.md.

## Häufige Probleme und Lösungen

Die beiden häufigsten Probleme bei der Einrichtung von Hadoop auf Mesos sind:

* Unfähigkeit, die Mesos-Bibliothek in der Umgebung zu setzen
* Build failures

Eine Lösung für diese beiden Probleme wird hier beschrieben:
* **Missing the Mesos library in the environment**: Wir erhalten einen Ausnahmestapel, wenn wir vergessen, die Mesos-Bibliothek in der Umgebung unter folgender URL zu setzen: https://github.com/mesos/hadoop/issues/25.

Dies kann durch die Einstellung der folgenden Umgebungsvariablen behoben werden:
```
$ export MESOS_NATIVE_LIBRARY=/usr/local/lib/libMesos.so
$ export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libMesos.so
```

* **The Maven build failure**: Wir werden nicht in der Lage sein, das Paket bei einigen Gelegenheiten zu bauen, weil es Fehler verursacht. Ein Beispiel für einen Build-Fehler finden Sie hier: https://github.com/mesos/hadoop/issues/64.

Dies kann vermieden werden, indem man die älteren Maven-Abhängigkeiten aus der Umgebung entfernt und wieder aufbaut.

Hier ist ein Beispiel:
```
$ mv ~/.m2 ~/.mv_back
$ mvn package
```

