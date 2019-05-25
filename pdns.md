# PDNS

## Mysql Datenbamk pdns Einrichtung

```s
Datenbank: ``
User:``

```

```sql
GRANT ALL ON pdns.* TO 'pdns'@'localhost' IDENTIFIED BY 'g7KShcbcv4UZQWBk';
GRANT ALL ON pdns.* TO 'pdns'@'tobkern-desktop.example.com' IDENTIFIED BY 'g7KShcbcv4UZQWBk';

```

## Installations script

```sh
DATABASE=pdns
USERNAME=pdns
PASSWORD=g7KShcbcv4UZQWBk
ZONE=example.com

sudo dnf install pdns pdns-backend-mysql

sudo mysql <<EOF
CREATE DATABASE ${DATABASE};
CREATE USER '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}';
GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${USERNAME}'@'localhost';
EOF
sudo mysql $DATABASE < /usr/share/doc/pdns-backend-mysql/schema.mysql.sql

sudo tee /etc/pdns/pdns.conf > /dev/null <<EOF
setuid=pdns
setgid=pdns
launch=gmysql
gmysql-dnssec=true
gmysql-host=localhost
gmysql-user=$USERNAME
gmysql-password=$PASSWORD
gmysql-dbname=$DATABASE
EOF

sudo systemctl start pdns
sudo systemctl enable pdns

sudo mysql <<EOF
INSERT INTO ${DATABASE}.domains (name, type) VALUES ('${ZONE}', 'master');
INSERT INTO ${DATABASE}.records (domain_id, name, type, content) VALUES (LAST_INSERT_ID(), '${ZONE}', 'SOA', 'ns1.${ZONE} hostmaster.${ZONE}. 0 3600 1800 1209600 3600');
EOF
sudo pdnssec rectify-zone $ZONE
```

### Quellen

* [foreman-and-powerdns](https://partial.solutions/2015/foreman-and-powerdns.html)