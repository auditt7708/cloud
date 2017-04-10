Es ist eine großartige Idee, deine Puppenmanifeste in ein Versionskontrollsystem wie Git oder Subversion zu stellen (Git ist der De-facto-Standard für Puppet). Das gibt Ihnen einige Vorteile:

* Sie können Änderungen rückgängig machen und auf eine vorherige Version Ihres Manifests zurücksetzen
* Sie können mit neuen Features mit einem Zweig experimentieren
* Wenn mehrere Menschen Änderungen an den Manifesten vornehmen müssen, können sie sie selbstständig in ihren eigenen Arbeitskopien machen und dann später ihre Änderungen zusammenführen
* Sie können die git-Log-Funktion verwenden, um zu sehen, was geändert wurde, und wann (und von wem)


### Fertig werden

In diesem Abschnitt importieren wir Ihre vorhandenen Manifestdateien in Git. Wenn Sie ein Puppet-Verzeichnis in einem vorherigen Abschnitt erstellt haben, verwenden Sie bitte das vorhandene Manifest-Verzeichnis.

In diesem Beispiel erstellen wir ein neues Git-Repository auf einem Server, der von allen unseren Knoten zugänglich ist. Es gibt mehrere Schritte, die wir ergreifen müssen, um unseren Code in einem Git-Repository zu halten:

1. Installiere Git auf einem zentralen Server.
2. Erstellen Sie einen Benutzer, um Git auszuführen und das Repository zu besitzen.
3. Erstellen Sie ein Repository, um den Code zu halten.
4. Erstellen Sie SSH-Schlüssel, um den Schlüssel-basierten Zugriff auf das Repository zu ermöglichen.
5. Installiere Git auf einem Knoten und lade die neueste Version aus unserem Git Repository herunter.


Wie es geht...

Folge diesen Schritten: