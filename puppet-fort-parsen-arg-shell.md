Wenn Sie Werte in eine Befehlszeile einfügen möchten (z.B die von einer `exec` Ressource ausgeführt werden), müssen sie oft quted sein, besonders wenn sie Leerzeichen enthalten. Die `shellquote` Funktion wird eine beliebige Anzahl von Argumenten, einschließlich Arrays, und zitieren jedes der Argumente und geben sie alle als eine Leerzeichen getrennte Zeichenfolge, die Sie an Befehle übergeben können.

In diesem Beispiel möchten wir eine `exec` Ressource einrichten, die eine Datei umbenennent. Aber sowohl die Quelle als auch der Zielname enthalten Leerzeichen, also müssen sie in der Kommandozeile korrekt gequted werden.

