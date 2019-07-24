# Anzeige offener Dateien ("list open files")

Prozesse gerade alle die Bash benutzen

`lsof /bin/bash`

alle offenen Dateien anzeigen die nicht von _root_ Geöffnet sind anzeigen:

`sudo lsof -u ^root`

Alle Netzwerkport des benutzer _www-data_ ausgeben

`sudo lsof -a -i -u www-data`

