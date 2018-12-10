# [jupyter](https://jupyter.org/) Installation auf eigenen Server
[jupyter](https://jupyter.org/) kann eigentlich auf jedem OS Installiert werden wenn man sich damit beschäftigt.
**Voraussetzungen**
- python3 
- git 
- curl

## Gundlegende Installation von github
Einfache installation ohne extras nur der Server

### Installation via (npmjs/npm)[https://www.npmjs.com/]
```
npm install -g configurable-http-proxy
python3 -m pip install jupyterhub  
```

damit die Localeen Noteboks gehen muss noch: 

`python3 -m pip install --upgrade notebook`

Installiert werden.

Danach ist der Server via `https://localhost:8000` erreichbar. Benutzer werden via [pam](../pam)

Für mehrere Benutzer muss ein Privilegierter Benutzer zum starten genommen werden.

### mehrere Benutzer unter jupyter



## [jupyter](https://jupyter.org/) Hinter einem Proxy
In dem meisten Fällen wird heute ein service hinter einer firewall betrieben.
Was eine Weiterleitung notwendig macht im allgemeinen wird im Bereich Webtechnologien soetwas als Proxy bezeichnet
Dazu muss eine Variable definiert werden mit dem Proxy Server als Ziel

`export http_proxy=<your_proxy>`

## [jupyter](https://jupyter.org/) und SSL/TLS 

Um nicht alles in für jeden Lesbaren Text Übertragen zu müssen muss man noch seine Zertifikate hinterlegen.

```
export REQUESTS_CA_BUNDLE=</directory/with/your/ssl/certificates>
```

Und danach noch (npm)[../npm] mitteilen wp man es abgelegt hat.

`sudo npm config set cafile=</directory/with/your/ssl/certificates>`


## Server Installation

Für den eigentlichen Server gipt es diverse Möglichkeiten.

* [JupyterHub ](../jupyterhub)

**Quellen:**
* [Eigener Server](https://tljh.jupyter.org/en/latest/#the-littlest-jupyterhub)
* [jupyter Server mit Kubernetes](https://z2jh.jupyter.org/en/stable/)
* [Github jupyterhub](https://github.com/jupyterhub/jupyterhub)
* [docker Jupyter](https://hub.docker.com/r/jupyterhub/jupyterhub/)