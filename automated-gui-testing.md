Automatisierung GUI-Tests hat viele wünschenswerte Eigenschaften, aber es ist auch schwierig. Ein Grund dafür ist, dass sich Benutzeroberflächen während der Entwicklungsphase stark ändern, und Schaltflächen und Steuerelemente bewegen sich in der GUI.

Ältere Generationen von GUI-Test-Tools funktionierten oft durch die Synthese von Maus-Events und senden sie an die GUI. Wenn eine Taste verschoben wurde, ging der simulierte Mausklick nirgendwo hin, und der Test ist fehlgeschlagen. Es wurde dann teuer, die Tests mit Änderungen in der GUI aktualisiert zu halten.

Selen ist ein Web-UI-Test-Toolkit, das einen anderen, effektiveren Ansatz nutzt. Die Controller werden mit Identifikatoren instrumentiert, so dass Selen die Controller finden kann, indem sie das Dokumentobjektmodell (DOM) untersucht, anstatt blindlings Mausklicks zu erzeugen.

Selen arbeitet in der Praxis ziemlich gut und hat sich im Laufe der Jahre weiterentwickelt.

Eine andere Methode wird durch das Sikuli-Testgerüst angewendet. Es verwendet ein Computer Vision Framework, OpenCV, um zu identifizieren Controller, auch wenn sie bewegen oder ändern Erscheinungen. Dies ist nützlich, um native Anwendungen wie Spiele zu testen.

Der untenstehende Screenshot stammt aus der Selenium IDE.
![Selenium-IDE](https://www.packtpub.com/graphics/9781785882876/graphics/4892_06_02.jpg)

