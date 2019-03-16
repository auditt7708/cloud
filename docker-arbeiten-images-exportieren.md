# Docker Arbeiten mit Images. Expotiren

Lassen Sie uns sagen, Sie haben einen Kunden, der sehr strenge Richtlinien hat, die ihnen nicht erlauben, Images von der public domain zu verwenden. In solchen Fällen kannst du Images über Tarballs teilen, die später auf einem anderen System importiert werden können. In diesem Rezept werden wir sehen, wie man das mit dem `docker save` Befehl macht.

## Fertig werden

Kopieren oder importieren Sie ein oder mehrere Docker-Images auf dem Docker-Host.

### Wie es geht…

1. Verwenden Sie die folgende Syntax, um das Image in der tar-Datei zu speichern:
`$ docker save [-o|--output=""] IMAGE [:TAG]`

Um beispielsweise ein tar-Archiv für Fedora zu erstellen, führen Sie den folgenden Befehl aus:
`$ docker save --output=fedora.tar fedora`

Wenn der Tag-Name mit dem Imagenamen angegeben wird, den wir exportieren möchten, wie z.B `fedora:latest` spätestens dann werden nur die mit diesem Tag verknüpften Ebenen exportiert.

### Es gibt mehr…

Wenn `--output` oder `-o` nicht verwendet wird, wird der Ausgang auf `STDOUT` gestreamt:
`$ docker save fedora:latest > fedora-latest.tar`

Ebenso kann der Inhalt des Dateisystems des Containers mit folgendem Befehl exportiert werden:
`$ docker export CONTAINER  > containerXYZ.tar`