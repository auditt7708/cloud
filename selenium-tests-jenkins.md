Selen arbeitet, indem er einen Browser aufruft und auf einen Webserver zeigt, auf dem Ihre Anwendung läuft, und dann den Browser ferngesteuert, indem er sich in die JavaScript- und DOM-Ebenen integriert.

Wenn Sie die Tests entwickeln, können Sie zwei grundlegende Methoden verwenden:

*     Notieren Sie Benutzerinteraktionen im Browser und speichern Sie den resultierenden Testcode für die Wiederverwendung 

*     Schreiben Sie die Tests von Scratch mit Selenium Test API 

Viele Entwickler bevorzugen es, Tests als Code mit der Selen-API zu Beginn zu schreiben, was mit einem testgetriebenen Entwicklungsansatz kombiniert werden kann.

Unabhängig davon, wie die Tests entwickelt werden, müssen sie in der Integration Build-Server laufen.

Dies bedeutet, dass Sie Browser benötigen, die irgendwo in Ihrer Testumgebung installiert sind. Dies kann ein bisschen problematisch sein, da Build-Server in der Regel kopflos sind, das heißt, sie sind Server, die keine Benutzeroberflächen ausführen.

Es ist möglich, einen Browser in einer simulierten Desktop-Umgebung auf dem Build-Server zu umwickeln.

Eine fortschrittlichere Lösung ist die Verwendung von Selenium Grid. Wie der Name schon sagt, bietet Selenium Grid einen Server, der eine Anzahl von Browser-Instanzen gibt, die von den Tests verwendet werden können. Damit ist es möglich, eine Reihe von Tests parallel durchzuführen und eine Reihe von verschiedenen Browser-Konfigurationen bereitzustellen.

Sie können mit der einzigen Browser-Lösung beginnen und später auf die Selenium Grid-Lösung migrieren, wenn Sie es brauchen.

Es gibt auch einen bequemen Docker-Container, der Selenium Grid implementiert.