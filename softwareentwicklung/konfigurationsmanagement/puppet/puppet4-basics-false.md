---
title: puppet4-basics-false
description: 
published: true
date: 2021-06-09T15:55:26.972Z
tags: 
editor: markdown
dateCreated: 2021-06-09T15:55:21.838Z
---

#False in Puppet

Es gibt nur eine Sache in Puppet den wert False hat nähmlich `false` ohne irgendwelche weiteren Zeichen.
Aus `"false"` machet Puppet `true`.
Und aus `"true"` macht Puppet `true`.

Hier ein beispiel :

```pp
if "false" {
  notify { 'True': }
}
if 'false' {
  notify { 'Also true': }
}
if false {
  notify { 'Not true': }
}
```

Wenn dieser Code durch Puppe ausgeführt wird, werden die ersten beiden Meldungen ausgelöst.
Die endgültige Benachrichtigung wird nicht ausgelöst; Es ist die einzige, die falsch auswertet, da `notify` nur bei einem positivem Ergebnis auslöst wird .