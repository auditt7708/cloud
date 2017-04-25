Ein Replikationscontroller ist ein Begriff für API-Objekte in Kubernetes, der sich auf Pod-Repliken bezieht. Die Idee ist, in der Lage sein, eine Reihe von Pods Verhaltensweisen zu kontrollieren. Der Replikationscontroller sorgt dafür, dass die Pods in einer benutzerdefinierten Nummer ständig laufen. Wenn einige Pods im Replikationscontroller abstürzen und beenden, wird das System Pods mit den ursprünglichen Konfigurationen auf gesunden Knoten automatisch neu erstellen und eine gewisse Anzahl von Prozessen kontinuierlich laufen lassen. Nach dieser Funktion, egal ob Sie Repliken von Pods benötigen oder nicht, können Sie immer die Pods mit dem Replikations-Controller für Autorecovery abschirmen. In diesem Rezept werden Sie lernen, wie Sie Ihre Pods verwalten, indem Sie den Replikations-Controller:

![schema-replication-controller](https://www.packtpub.com/graphics/9781788297615/graphics/B05161_02_01.jpg)

Der Replikationscontroller behandelt in der Regel eine Reihe von Anwendungen. Wie Sie im vorigen Bild sehen, starten wir einen Replikationscontroller mit drei Pod Repliken. Einige Mechanismusdetails sind wie folgt aufgeführt:

* Der Dämon im Master wird als Controller Manager bezeichnet und hilft, die Ressource in seinem gewünschten Zustand zu halten. Beispielsweise ist der gewünschte Zustand des Replikationscontrollers im vorherigen Bild drei Pod-Repliken.

* Der Daemon-Scheduler im Master übernimmt die Zuordnung von Aufgaben zu gesunden Knoten.

* Der Selektor des Replikationscontrollers wird verwendet, um zu entscheiden, welche Pods er deckt. Wenn die Schlüsselwertpaare im Etikett des Pods alle Elemente im Selektor des Replikationscontrollers enthalten, gehört dieser Pod zu diesem Replikationscontroller. Wie Sie sehen werden, zeigt das vorherige Bild drei Pods unter der Ladung des Replikationscontrollers. Da der Selektor abgedeckt und als Projekt und Rolle bezeichnet wird, könnte die Pod mit der anderen kleineren Versionsnummer (Pod 2) noch eines der Mitglieder sein.

### Fertig werden

Wir haben das Management des Replikationscontrollers im Kubernetes-Master demonstriert, als wir das Kubernetes-Clientpaket installiert haben. Bitte melden Sie sich zuerst beim Master an und stellen Sie sicher, dass Ihre Umgebung Replikationscontroller erstellen kann.

### Tip

Die Auswertung der Replikationscontroller-Erstellung vom Master

Sie können überprüfen, ob Ihr Kubernetes Master ein praktischer ist, indem Sie die folgenden Punkte überprüfen:

Prüfen Sie, ob die Daemons laufen oder nicht. Es sollten drei Arbeits-Daemon-Prozesse auf dem Master-Knoten vorhanden sein: Apiserver, Scheduler und Controller-Manager.

Überprüfen Sie den Befehl kubectl existiert und ist bearbeitbar. Probieren Sie den Befehl kubectl erhalten Componentstatus oder kubectl bekommen cs, so können Sie nicht nur die Komponenten der Status, sondern auch die Machbarkeit von kubectl zu überprüfen.

Überprüfen Sie, ob die Knoten bereit sind zu arbeiten. Sie können sie durch den Befehl kubectl erhalten Knoten für ihren Status zu überprüfen.

Falls einige der vorstehenden Punkte ungültig sind, lesen Sie bitte auf> Kapitel 1, Erstellen Sie Ihre eigenen Kubernetes für die korrekten Richtlinien der Installation.

### Wie es geht…

Ein Replikationscontroller kann direkt über CLI oder über eine Vorlagendatei erstellt werden. Wir werden die bisherige Lösung in diesem Abschnitt ausdrücken. Für Vorlage eins, siehe das Rezept Arbeiten mit Konfigurationsdateien in Kapitel 3, Spielen mit Containern.
Erstellen eines Replikationscontrollers

Um Replikationscontroller zu erstellen, verwenden wir den Unterbefehl nach kubectl. Das grundlegende Befehlsmuster sieht wie folgt aus:
```
//  kubectl run <REPLICATION CONTROLLER NAME> --images=<IMAGE NAME> [OPTIONAL_FLAGS]
# kubectl run my-first-rc --image=nginx
CONTROLLER    CONTAINER(S)   IMAGE(S)   SELECTOR      REPLICAS
my-first-rc   my-first-rc    nginx      run=my-first-rc   1
```

Dieser einfache Befehl erstellt einen Replikationscontroller nach Bild nginx aus dem Docker Hub (https://hub.docker.com). Der Name, `my-first-rc`, muss in allen Replikationscontrollern eindeutig sein. Ohne vorgegebene Anzahl von Repliken wird das System nur einen Pod als Standardwert erstellen. Es gibt mehr optionale Flags, die Sie zusammen integrieren können, um einen qualifizierten Replikationscontroller zu erstellen:

|--Flag=[Default Wert]|Beschreibung|Beispiel|
| :---: | :---: | :---: |
| `--replicas=1` |Die Anzahl der Pod Repliken| `--replicas=3` |
| `--port=-1` |Der weiter geleitete Port des Containers| `--port=80` |
| `--hostport=-1 `|Die Host-Port-Mapping für den Container-Port. Vergewissern Sie sich, dass bei der Verwendung der Flagge nicht mehrere Pod-Repliken auf einem Node ausgeführt werden, um Port-Konflikte zu vermeiden.| -`-hostport=8080` |
| `--labels=""` |Key-Wert-Paare als Labels für Pods. Trennen Sie jedes Paar mit einem Komma.| --`labels="ProductName=HappyCloud,ProductionState=staging,ProjectOwner=Amy"` |
| `--command[=false]` |Nachdem der Container hochgefahren ist, führen Sie einen anderen Befehl durch dieses Flagg aus. Zwei gestrichelte Linien hängen das Flag als Segmentierung an.| `--command -- /myapp/run.py -o logfile` |
| `--env=[]` |Legen Sie Umgebungsvariablen in Containern fest. Dieses Flag könnte mehrmals in einem einzigen Befehl verwendet werden.| `--env="USERNAME=amy" --env="PASSWD=pa$$w0rd"` |
| `--overrides=""` |Verwenden Sie dieses Flag, um einige generierte Objekte des Systems im JSON-Format zu überschreiben. Der JSON-Wert verwendet ein einziges Zitat, um dem doppelten Zitat zu entgehen. Das Feld apiVersion ist notwendig. Detaillierte Artikel und Anforderungen finden Sie im Kapitel Arbeiten mit Konfigurationsdateien in [Spielen mit Containern](../kubernates-container)| `--overrides='{"apiVersion": "v1"}'` |
| `--limits=""` |Die obere Grenze der Ressourcennutzung im Container. Sie können festlegen, wie viel CPU und Speicher verwendet werden könnten. Die CPU-Einheit ist die Anzahl der Kerne im Format `NUMBERm`. `M` zeigt `milli` (10-3) an. Die Speichereinheit ist Byte. Bitte überprüfen Sie auch `--requests`||
| `--requests=""` |Die Mindestanforderung an die Ressourcen für Container. Die Regel des Wertes ist die gleiche wie `--limits`| `--requests="cpu=250m,memory=256Mi" `|
| `--dry-run[=false]` |Anzeige der Objektkonfiguration, ohne sie zum Erstellen zu senden.| `--dry-run` |
| `--attach[=false]` |Für den Replikationscontroller wird Ihr Terminal an eine der Replikaten angehängt und das Laufzeitprotokoll aus dem Programm angezeigt. Die Voreinstellung ist, den ersten Container in der Pod zu befragen, genauso wie Dockers anhängen. Einige Protokolle aus dem System zeigen den Status des Containers an.| `--attach` |
|`-i , --stdin[=false]`|Aktivieren Sie den interaktiven Modus des Containers. Die Replik muss 1 sein.|`-i`|
| `--tty=[false]` |Zu jedem Container eine neue `tty` (neue Controlling-Terminal) zuordnen. Sie müssen den interaktiven Modus aktivieren, indem Sie das Flag -i oder --stdin anhängen.|`--tty`|