# SSH Server Einrichten

ssh agent für Passphrase benutzen

1. ssh agent im hintergrund starten

    `eval "$(ssh-agent -s)"`

2. SSH Private Key zum SSH Agent hinzufügen

   `ssh-add ~/.ssh/id_rsa`

danch prüfen ob das Zielsystem funktioniert