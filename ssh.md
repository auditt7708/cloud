# SSH Server Einrichten

ssh agent für passphrase benutzen

1. ssh agent im hintergrund starten

    `eval "$(ssh-agent -s)"`

2. SSH Private key zum ssh agent hinzufügen

   `ssh-add ~/.ssh/id_rsa`

danch prüfen ob das Zielsystem functioniert