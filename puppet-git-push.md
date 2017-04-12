Wie wir bereits im dezentralisierten Modell gesehen haben, kann Git verwendet werden, um Dateien zwischen Maschinen mit einer Kombination von ssh- und ssh-Tasten zu übertragen. Es kann auch sinnvoll sein, einen Git-Hook auf jedem erfolgreichen Commit zum Repository zu haben.

Es gibt einen Haken namens Post-Commit, der nach einem erfolgreichen Commit zum Repository ausgeführt werden kann. In diesem Rezept erstellen wir einen Hook, der den Code auf unserem Puppet Master mit Code aus unserem Git Repository auf dem Git Server aktualisiert.


### Fertig werden

Gehen Sie folgendermaßen vor, um loszulegen: