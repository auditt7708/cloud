# [jupyter](https://jupyter.org/) Installation Vorausetzungen

[jupyter](https://jupyter.org/) kann eigentlich auf jedem OS Installiert werden wenn man sich damit beschäftigt.

Voraussetzungen

- python3
- pip
- git
- curl

## Installation

### Installation via pip

Umgebung anlegen

`python -m venv jupyter-env`

In die Umbebung wechseln

`cd jupyter-env\Scripts\activate`

OS unabhängige Installation

`python3 -m pip install jupyter`

> Je nach installation von Python kann der Name zur Ausführbaren Datei unterschiedlich sein.

Starten aus der Konsole

`jupyter notebook`

Starten mit anderem Port

`jupyter notebook --port 9999`

damit die Localen Noteboks gehen muss noch:

`python3 -m pip install --upgrade notebook`

Installiert werden.

Danach ist der Server via `https://localhost:8000` erreichbar. Benutzer werden via [pam](../pam)

Für mehrere Benutzer muss ein Privilegierter Benutzer zum starten genommen werden.

## jupyter Updates

`python -m pip install --upgrade pip`

## mehrere Benutzer unter jupyter

## [jupyter](https://jupyter.org/) Hinter einem Proxy

In dem meisten Fällen wird heute ein service hinter einer firewall betrieben.
Was eine Weiterleitung notwendig macht im allgemeinen wird im Bereich Webtechnologien soetwas als Proxy bezeichnet
Dazu muss eine Variable definiert werden mit dem Proxy Server als Ziel

`export http_proxy=<your_proxy>`

## [jupyter](https://jupyter.org/) und SSL/TLS

Um nicht alles in für jeden Lesbaren Text Übertragen zu müssen muss man noch seine Zertifikate hinterlegen.

```s
export REQUESTS_CA_BUNDLE=</directory/with/your/ssl/certificates>
```

Und danach noch (npm)[../npm] mitteilen wp man es abgelegt hat.

`sudo npm config set cafile=</directory/with/your/ssl/certificates>`

## Server Installation

Für den eigentlichen Server gipt es diverse Möglichkeiten.

* [JupyterHub](../jupyterhub)

**Quellen:**

* [Eigener Server](https://tljh.jupyter.org/en/latest/#the-littlest-jupyterhub)

* [jupyter Server mit Kubernetes](https://z2jh.jupyter.org/en/stable/)

* [Github jupyterhub](https://github.com/jupyterhub/jupyterhub)

* [setting-up-jupyter-notebook-server-as-service-in-ubuntu-16-04](https://aichamp.wordpress.com/2017/06/13/setting-up-jupyter-notebook-server-as-service-in-ubuntu-16-04/)

* [Using-sudo-to-run-JupyterHub-without-root-privileges](https://github.com/jupyterhub/jupyterhub/wiki/Using-sudo-to-run-JupyterHub-without-root-privileges)

* [docker Jupyter](https://hub.docker.com/r/jupyterhub/jupyterhub/)

* [jupyter-notebook-under-pyenv-in-systemd-only-gives-system-python](https://stackoverflow.com/questions/50242491/jupyter-notebook-under-pyenv-in-systemd-only-gives-system-python)
