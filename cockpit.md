# Systemd einrichten

```sh
sudo systemctl start cockpit
​sudo systemctl enable cockpit.socket
```

## Firewall

```sh
sudo firewall-cmd --add-service=cockpit
​sudo firewall-cmd --add-service=cockpit --permanent
​sudo firewall-cmd --reload
```