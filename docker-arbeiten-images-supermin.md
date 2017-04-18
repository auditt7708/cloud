Früher in diesem Kapitel benutzten wir die FROM-Anweisung, um das Basisbild zu wählen, um mit zu beginnen. Das Bild, das wir erstellen, kann das Basisbild werden, um eine andere Anwendung zu veröffentlichen und so weiter. Von Anfang an bis zu dieser Kette werden wir ein Basisbild von der zugrunde liegenden Linux-Distribution haben, die wir wie Fedora, Ubuntu, CentOS und so weiter nutzen wollen.

Um ein solches Basisbild zu erstellen, müssen wir ein verteilungsspezifisches Basissystem in einem Verzeichnis installieren, das dann als Bild auf Docker importiert werden kann. Mit chroot-Dienstprogramm können wir ein Verzeichnis als Root-Dateisystem fälschen und dann alle notwendigen Dateien in sie setzen, bevor es als Docker-Image importiert wird. Supermin und Debootstrap sind die Art von Werkzeugen, die uns helfen können, den vorherigen Prozess zu erleichtern.

Supermin ist ein Werkzeug, um Supermin Geräte zu bauen. Das sind winzige Geräte, die sich sofort in die Hand nehmen. Früher wurde dieses Programm febootstrap genannt.

Fertig werden

Installiere Supermin auf dem System, wo Sie das Basisbild erstellen möchten. Sie können Supermin auf Fedora mit dem folgenden Befehl installieren: