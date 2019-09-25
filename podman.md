# Podman

## Kommandos

Pull eines Images

`podman pull docker.io/library/alpine:latest`

Rootles Container

`podman run -d alpine top`

Top für container

`podman exec 5f421b01faa ps -ef`

Pod erstellen

`podman pod create --name mypod`

Container einem Pod hinzufügen

`podman run --detach --pod=mypd alpine:latest top`

`podman ps --all --pod`


## Quellen

* [pdman Homepage](https://podman.io/)
