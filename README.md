# jitsi #
github repo for jitsi customized container builts

The code in this repository has been heavily based on the work of the jitsi team itself: https://github.com/jitsi/docker-jitsi-meet
Goal of this repo is to have something in place for single host / vm deployments in a NAT environment to run jitsi self-hosted behind one public IP and offer max compatibility in terms of firewalling for participants and try to keep the amount of variables to configure small.
At the same time this config allows run other webservices on the same host /vm.
If code from this repo could go to the original repo part of jitsi I would be all for it.
A few things are added compared to the original docker jitsi setup:
# coturn server integration#
coturn is useful in case of firewall issues for conference clients. see also here:
https://jitsi.github.io/handbook/docs/devops-guide/turn
Running turn in docker helps in terms of isolating coturn from the rest of the network and services that run on the vm / host.
# automatic building #
All containers needed for jitsi are rebuilt on a daily basis using gitlab ci/cd: this helps to update dependencies / identify and fix CVE's.
# overview of daemons / ports
```` 
              Public ip 23.X.Y.Z
  +----------------------------------------------------------------+
  |                                                                | 
  |                           Router                               |
  |                                                                |
  +---------+-------------------+---------------+------------+-----+
            |   Private ip      |               |            |
            |  192.168.B.C/24   |               |            |
            v                   v               v            |
            80                 443        3478/udp,5349      |
        +-------+          +---------+      +--------+       |
        |       |4443      |         |  5349|        |       |
        | Nginx +<----+    | HAProxy +----->+ coTURN |       |
        |       |     |    |         |      |        |       v
        +---+---+     |    +----+----+      +---+----+     10000/udp 
            |   +-----+-----+   |               |     +-------------+ 
            |   |           |   |               |     |             |
            |   |go-mmproxy +<--+               +---->+ videobridge |
            |   |           |4444            10000/udp|             |
            |   +-----------+                         +---------+---+
            |                                          9090     |
            |   +-------------+                          ^      |
            |   |             |                          |      |
            +-->+ Nginx jitsi +--------------------------+      |  
            8289|             |                                 |
                +--+-+--------+                                 |
                   | |                                          |
+------------+     | |    +--------------+                      |
|            |     | |    |              |                      |
| jitsi-meet +<----+ +--->+ prosody/xmpp +<---------------------+
|            |files  5280 |              |5347               
+------------+            +--------------+                   
                              5222,5347
                                  ^    
                +--------+        |    
                |        |        |    
                | jicofo +--------+    
                |        |         
                +--------+
````
# more info on the daemons, containers

| name | purpose | type | more info |
| ------ | ------ | ------ | ------ |
| HAProxy | uses SNI to distinguish traffic for TLS coTURN traffic from  https traffic | daemon on host | https://www.haproxy.org/ |
| Nginx | Nginx instance that runs on the host, needed for letsencrypt certificate renewals and to send traffic to jitsi nginx (on docker) | daemon on host | https://nginx.org/en/ |
|go-mmproxy|arranges original client ip is sent to Nginx. |daemon on host| https://github.com/path-network/go-mmproxy |
|nginx jitsi|serves jitsi web content and forwards traffic using websockets|docker container| https://github.com/jitsi/jitsi-meet |
|prosody/xmpp|xmpp server|docker container|https://prosody.im/|
|jicofo|session manager between participants and videobridge|docker container|https://github.com/jitsi/jicofo|
|videobridge|in case more than 2 participants are part of a conference the videobridge is required|docker container|https://github.com/jitsi/jitsi-videobridge|
|coTURN|required in case no direct connection can be made to the videobridge|docker container|https://github.com/coturn/coturn|

# container setup example including turn.
create a directory named "jitsi" for docker-compose and environment files and get them from here [sample](/sample/)
the .env file contains some passwords. adjust the .env file or use genpw to create random passwords
```
root@debian10:/my_containers/jitsi# sh genpw.sh
root@debian10:/my_containers/jitsi# sh genpw.sh
```
the .env_global contains a reference to your domain and the turn domain plus other variables.
adjust the config so it includes your domains and activate turn:
```bash
# Public URL  and domain for the web service (required)
PUBLIC_URL=https://myjitsi.somewhere.nu

#turn needs a separate domain name. required in case ENABLE_TURN is set to 1
TURN_DOMAIN=myturndomain.somewhere.nu

#activate the usage of turn to allow users to connect via other ports than udp 10000 to jitsi
ENABLE_TURN=1
.....
```
see below for other variables you might want to adjust
bring up the containers and check they are healthy
```
root@debian10:/my_containers/jitsi# docker-compose up -d
root@debian10:/my_containers/jitsi# docker-compose ps
jitsi_jicofo_1     /usr/local/bin/entry.sh /u ...   Up (healthy)                                                           
jitsi_jvb_1        /usr/local/bin/entry.sh /u ...   Up (healthy)   0.0.0.0:10000->10000/udp                                
jitsi_prosody_1    /init                            Up (healthy)                                                           
jitsi_turn_1       entry.sh log-file=stdout ...     Up (healthy)   3478/tcp, 0.0.0.0:3478->3478/udp, 0.0.0.0:5349->5349/tcp
jitsi_web_1        /init                            Up (healthy)   0.0.0.0:8289->80/tcp                                    

```
# configure letsencrypt certificate for turn
get renew_turn_cert.sh from  [sample](/sample/) to /usr/local/sbin/and make it executable
```
chmod 755 /usr/local/sbin/renew_turn_cert.sh
root@debian10:/my_containers/jitsi# certbot certonly -d myturndomain.somewhere.nu --deploy-hook /usr/local/sbin/renew_turn_cert.sh
Saving debug log to /var/log/letsencrypt/letsencrypt.log

How would you like to authenticate with the ACME CA?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: Nginx Web Server plugin (nginx)
2: Spin up a temporary webserver (standalone)
3: Place files in webroot directory (webroot)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-3] then [enter] (press 'c' to cancel): 1
Plugins selected: Authenticator nginx, Installer None
Obtaining a new certificate
Running deploy-hook command: /usr/local/sbin/renew_turn_cert.sh
Output from renew_turn_cert.sh:
jitsi_turn_1
```
