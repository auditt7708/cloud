Bei der Deklaration von Dateiressourcen, die Symlinks sind, verwenden Sie `ensure => link` und legen Sie das Zielattribut wie folgt fest:


```
file { '/etc/php5/cli/php.ini':
  ensure => link,
  target => '/etc/php.ini',
}
```
