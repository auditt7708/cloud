# Tomcat

ERinfache grundlagen zur einrichtung.

## Tomcat-Cluster

Cluster einrichten bei Tomcat

## Tomcat-Reverse-Proxy

Tomcat als setup mit reverse proxy nutzen

## Tomcat [Logging](../logging)

Mit tomcat logs Praktikabel einrichten

## loging wie [syslog](../syslog)

## loging mit [logstsh](../logstah)

## loging mit [graylog](../graylog)

Zu anpassende Datei für änderungen am loggin ist immer die `server.xml` im Verzeichnis `` .

```xml

 <Valve className="org.apache.catalina.valves.AccessLogValve"
                 directory="logs"  prefix="access_log" suffix=".log"
                 pattern="%h %l %u %t %{HOST}i &quot;%r&quot; %s %b %I %S %D" />
                <!--
                    %a - Remote IP address
                        %A - Local IP address
                        %b - Bytes sent, excluding HTTP headers, or '-' if zero
                        %B - Bytes sent, excluding HTTP headers
                        %h - Remote host name (or IP address if enableLookups for the connector is false)
                        %H - Request protocol
                        %l - Remote logical username from identd (always returns '-')
                        %m - Request method (GET, POST, etc.)
                        %p - Local port on which this request was received
                        %q - Query string (prepended with a '?' if it exists)
                        %r - First line of the request (method and request URI)
                        %s - HTTP status code of the response
                        %S - User session ID
                        %t - Date and time, in Common Log Format
                        %u - Remote user that was authenticated (if any), else '-'
                        %U - Requested URL path
                        %v - Local server name
                        %D - Time taken to process the request, in millis
                        %T - Time taken to process the request, in seconds
                        %I - current request thread name (can compare later with stacktraces)
                -->
```

## Tomcat Tools

* [webjars](https://www.webjars.org/) WebJars are client-side web libraries (e.g. jQuery & Bootstrap) packaged into JAR (Java Archive) files.
* [tomcatmanager](https://pypi.org/project/tomcatmanager/)
* [easy-war-deployment](http://emmanuelrosa.com/articles/easy-war-deployment/)