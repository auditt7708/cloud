Eine andere Art von Ausdruck, den Sie testen können, `if` Aussagen und andere Bedingungen der reguläre Ausdruck sind. 
Ein regelmäßiger Ausdruck ist eine leistungsfähige Möglichkeit, Strings mit Muster zu vergleichen.

## Pracktische umsetzung 

Dies ist ein Beispiel für die Verwendung eines regulären Ausdrucks in einer bedingten Anweisung. Dazu fügen folgendes unserer manifests Datei hinzu:

```
if $::architecture =~ /64/ {
  notify { '64Bit OS Installed': }
} else {
  notify { 'Upgrade to 64Bit': }
  fail('Not 64 Bit')
}
```
## Wie es Funktioniert

Die Puppet behandelt den Text, der zwischen den Schrägstrichen als regulärer Ausdruck geliefert wird, und spezifiziert den dazu übereinstimmenden Text.
Wenn der Ausdrück passt wird die `if` Anweisung erfolgreich und der Code zwischen den ersten zwei geschweiften Klammern abgearbeitet andernfalls wird der Code zwischen den zweiten geschweiften Klammern abgearbeitet.
Bei disem beispiel haben wir einen regulären exdruck benutzt um unterschiedliche Linx distrubutionnen und die unterschiedlichen bezeichnungen zur 64bit unterstützung abzufangen die sich je nach distribution `amd64` oder x86_64 nennen.

Wenn wirs möchten das etwas ausgeführt wird wenn etwas nicht passt benutze `!~` stadt `=~`
`~` ist hier ein Parameter recht häufig zu verwirrung führt `!~` bedeutet "nicht gleich" und `=~` in etwa "gleich ungefähr" was etwas uneindeutig ist und zu nicht vorhersargbaren ergebnissen führen kann.
Ein der wenigen einsatzgebite für `=~`  ist einen Benutzer sucht dort möchte man ja auch wenn man den Namen nicht so genau kenn alle alternativen Namen angezeigt bekommen was man hiermit erreichen würde