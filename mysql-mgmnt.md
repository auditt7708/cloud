# Datenbanken

## Neue Datenbank anlegen

`CREATE DATABASE database_name;`

## Neue Datenbank anlegen wenn Sie nicht schonn vorhanden ist

`CREATE DATABASE IF NOT EXISTS database_name;`

## Liste der Datenbanken

`SHOW DATABASES;`

## Datenbank löschen

`DROP DATABASE database_name;`

## Datenbank löschen wenn Sie vorhanden ist

`DROP DATABASE IF EXISTS database_name;`

## Benutzer

### Neuen Benutzer anlegen

`CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'user_password';`

### Benutzer Password ändern. wenn DB älter sind

`SET PASSWORD FOR 'database_user'@'localhost' = PASSWORD('new_password');;`

### Neuen Benutzer anlegen auf ip eingeschränkt

`CREATE USER 'newuser'@'10.8.0.5' IDENTIFIED BY 'user_password';`

### Alle Benutzer auflisten

`SELECT user, host FROM mysql.user;`

### Benutzerberechtigugen ausgeben

<<<<<<< HEAD
`SHOW GRANTS FOR 'database_user'@'localhost';`
=======
`SHOW GRANTS FOR 'database_user'@'localhost';`

>>>>>>> bbacd8996fafa1e0ea5fd2d8bd7c77fc4364f275
