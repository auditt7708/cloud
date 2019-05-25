Variablen müssen immer in geschweiften klammern sein z.b. '${PHP7ENV}.conf'

Beispiel für eine Server Quelle : 

```
source => "puppet:///modules/webserver/${brand}.conf",
```

Puppet`s Parser muss immer unterscheiden können was ein charachter ist und was ein teil einer Variablen ist die geschweiften klammern machen es für den Parser eindeutig