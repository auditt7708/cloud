
# Helm

Helm ist ein Kubernetes Packetmanager

## Installation auf einem Linux System

```sh
#!/bin/bash
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

exit 0
```

## Helm Konfigurieren

Initiale Konfigurations einstellungen anlegen.

`helm init`

### Quellen

* [Helm Quickstart](https://github.com/kubernetes/helm/blob/master/docs/quickstart.md)