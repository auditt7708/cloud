Die Wahl geeigneter und informativer Namen für Ihre Module und Klassen wird eine große Hilfe sein, wenn es um die Lesbarkeit Ihres Codes geht. 
Das ist noch wichtiger, wenn andere Leute ihren Code lesen und an ihren Manifesten arbeiten müssen.

Hier einige tips wie man dinge in ihren manifests benen kann:

1. Namensmodule nach der Software oder dem Service, denn es verwalten soll , z.B. `Apache` oder `haproxy`.
2. Namensklassen in Modulen (Unterklassen) nach der Funktion oder dem Dienst, den sie dem Modul zur Verfügung stellen, z.B. `apache::vhosts` oder `rails::dependencies`.
3. Wenn eine Klasse innerhalb eines Moduls den von diesem Modul bereitgestellten Dienst deaktiviert, benennen Sie ihn `disabled`. Zum Beispiel sollte eine Klasse, die Apache deaktiviert, `Apache::disabled` genannt werden.
4. Erstellen Sie eine Rolle und Profile Hierarchie von Modulen. Jede Node sollte eine einzige Rolle haben, die aus einem oder mehreren Profilen besteht. Jedes Profilmodul sollte einen einzigen Dienst konfigurieren.
5. Das Modul, das Benutzer verwaltet, sollte `user` benannt werden.
6. Innerhalb des Benutzerbausteins deklariere deine virtuellen Benutzer im `user::virtuell` (für mehrere virtuelle Benutzer und andere Ressourcen, siehe [Puppet4 Benutzer und virtuelle Ressourcen](../puppet4-benutzer-virtuelleressourcen)).
7. Innerhalb des User-Moduls sollten Unterklassen für bestimmte Benutzergruppen nach der Gruppe benannt werden, z.B. `user::sysadmins` oder `user::contractors`.