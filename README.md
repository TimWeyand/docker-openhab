Overview
========

Docker image for Openhab (1.8.3). Included is JRE 1.8.45.

Based on the Image of tdeckers/docker-openhab

PULL
=======
```docker pull tweyand/openhab```

Building
========

```docker build -t <username>/openhab .```


Exposed Ports
=======
* 8080 - openHAB HTTP Webinterface
* 8443 - openHAB HTTPS Webinterface
* 5555 - openHAB TELNET Interface
* 9001 - supervisord Webinterface

Folders 
=======
The openHAB Docker expects you to map a configurations directory on the host to /etc/openhab. This allows you to inject your openhab configuration into the container (see example below). If you do not map your configurations, the Oficial Demo will be loaded.

* /etc/openhab - openHAB configuration
* /opt/openhab/logs - openHAB logs
* /opt/openhab/webapps/static - Folder for uuid & secret for http://my.openhab.org
* /opt/openhab/etc - Folder for data like db4o and rr4jd

Timezone
======
You can add a timezone file in the configurations directory, which will be placed in /etc/timezone. Default: UTC

Example content for timezone:
```
Europe/Brussels
```

Addons
======
To enable specific plugins, add a file with name addons.cfg in the configuration directory which lists all addons you want to add.

Example content for addons.cfg:
```
org.openhab.action.mail
org.openhab.action.squeezebox
org.openhab.action.xmpp
org.openhab.binding.exec
org.openhab.binding.http
org.openhab.binding.knx
org.openhab.binding.mqtt
org.openhab.binding.networkhealth
org.openhab.binding.serial
org.openhab.binding.squeezebox
org.openhab.io.squeezeserver
org.openhab.persistence.cosm
org.openhab.persistence.db4o
org.openhab.persistence.gcal
org.openhab.persistence.rrd4j
```

KNX Binding (Network)
=====
If you are running the KNX Binding, you might have problems to connect to your Router. You might need to use the network host to get it working.

Examples
=====

Example: run command (with Demo)
```
docker run -d -p 8080:8080 tweyand/openhab
```

Example: run command (with your openHAB config)
```
docker run -d \
       -p 8080:8080 
       -v [Host-Filesystem-Configuration-Folder]:/etc/openhab/ \
       tweyand/openhab
```

Example: Map configuration and logging directory as well as allow access to Supervisor:
```
docker run -d \
       -p 8080:8080 
       -p 9001:9001 
       -v [Host-Filesystem]/DockerData/openhab/conf:/etc/openhab \
       -v [Host-Filesystem-Logs-Folder]:/opt/openhab/logs \
       tweyand/openhab
```

Example: Configuration which is working for me with KNX
```
docker run -d  \
       --name openhab_1.8.3 \
       --restart always \
       --net host \
       -v [Host-Filesystem]/DockerData/openhab/conf:/etc/openhab \
       -v [Host-Filesystem]/DockerData/openhab/logs:/opt/openhab/logs \
       -v [Host-Filesystem]/DockerData/openhab/etc:/opt/openhab/etc \
       -v [Host-Filesystem]/DockerData/openhab/webapps/static:/opt/openhab/webapps/static \
       tweyand/openhab
```


Start the Demo with: 
```
http://[IP-of-Docker-Host]:8080/openhab.app?sitemap=demo
```
Access Supervisor with: 
```
http://[IP-of-Docker-Host]:9001
```


HABmin
=======

HABmin is not included in this deployment.  However you can easily add is as follows:
```
docker run -d -p 8080:8080 -v /<your_location>/webapps/habmin:/opt/openhab/webapps/habmin -v /<your_location>/openhab/config:/etc/openhab -v /<your_location>/openhab/addons-available/habmin:/opt/openhab/addons-available/habmin tdeckers/openhab
```

Then add these lines to addon.cfg
```
habmin/org.openhab.binding.zwave
habmin/org.openhab.io.habmin
```

Contributors
============
* maddingo
* scottt732
* TimWeyand
* dprus
* tdeckers
* wetware
* carlossg

