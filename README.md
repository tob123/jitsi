# jitsi #
github repo for jitsi customized container builts

The code in this repository has been heavily based on the work of the jitsi team itself: https://github.com/jitsi/docker-jitsi-meet
a few things are added (time of writing: 2020-11-15) compared to the original docker jitsi setup:
# coturn server #
coturn is useful in case of firewall issues for conference clients. see also here:
https://jitsi.github.io/handbook/docs/devops-guide/turn
# automatic rebuilts #
all containers needed for jitsi are rebuilt on a daily basis using Travis CI/CD

````
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
