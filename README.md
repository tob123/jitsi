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
#container setup"

