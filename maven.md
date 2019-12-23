# Maven Konfiguration

## Maven Environment

/etc/profile.d/maven.sh

```sh
export PATH=/opt/maven/bin:$PATH#
```

## Maven Administration

**Maven hilfe**

`mvn -h`

**Erstellen eines Maven-Projekts**

`mvn package`

**Build eines Projekts, das alle gepackten Ausgaben und die Dokumentationssite generiert und für einen Repository-Manager bereitstellt**

`mvn clean deploy Site-Deploy`

**lokales Repository installieren**

`mvn verify`

## Quellen

* [dropwizard mvn](https://dropwizard.github.io/dropwizard/1.3.14/docs/getting-started.html)
* [mesos chronos](https://github.com/mesos/chronos/blob/master/pom.xml)
