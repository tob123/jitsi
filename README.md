# jitsi #
github repo for jitsi customized container builts

The code in this repository has been heavily based on the work of the jitsi team itself: https://github.com/jitsi/docker-jitsi-meet
Goal of this repo is to have something in place for single host / vm deployments in a NAT environment to run jitsi self-hosted behind one public IP and offer max compatibility in terms of firewalling for participants and try to keep the amount of variables to configure small.
At the same time this config allows run other webservices on the same host /vm.
If code from this repo could go to the original repo part of jitsi I would be all for it.
A few things are added compared to the original docker jitsi setup:
## coturn server integration##
coturn is useful in case of firewall issues for conference clients. see also here:
https://jitsi.github.io/handbook/docs/devops-guide/turn
Running turn in docker helps in terms of isolating coturn from the rest of the network and services that run on the vm / host.
## automatic building ##
All containers needed for jitsi are rebuilt on a daily basis using gitlab ci/cd: this helps to update dependencies / identify and fix CVE's.
# overview of services / ports
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
            +-->+ jitsi web   +--------------------------+      |  
            8289|  (nginx)    |                                 |
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
root@debian10:/my_containers/jitsi# 
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
get **renew_turn_cert.sh** from  [sample](/sample/) to /usr/local/sbin/and make it executable
<pre>
chmod 755 /usr/local/sbin/renew_turn_cert.sh
root@debian10:/my_containers/jitsi# <b>certbot certonly -d myturndomain.somewhere.nu --deploy-hook /usr/local/sbin/renew_turn_cert.sh</b>
Saving debug log to /var/log/letsencrypt/letsencrypt.log

How would you like to authenticate with the ACME CA?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: Nginx Web Server plugin (nginx)
2: Spin up a temporary webserver (standalone)
3: Place files in webroot directory (webroot)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-3] then [enter] (press 'c' to cancel): <b>1</b>
Plugins selected: Authenticator nginx, Installer None
Obtaining a new certificate
Running deploy-hook command: /usr/local/sbin/renew_turn_cert.sh
Output from renew_turn_cert.sh:
jitsi_turn_1
</pre>

# daemons on the host

## nginx, letsencrypt
get the nginx jitsi.conf to /etc/nginx/sites-available/jitsi.conf from  [sample](/sample/) and adjust the domain name so it matches your domain:
<pre>
  server {
    server_name <b>myjitsi.somewhere.nu</b>;
    access_log /var/log/nginx/$host.log;
    location ^ /colibri-ws {
        proxy_pass http://localhost:8289/colibri-ws;
        proxy_http_version 1.1;
        proxy_set_header Connection "upgrade";
        proxy_set_header Upgrade $http_upgrade;
        tcp_nodelay on;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
      add_header X-Content-Type-Options nosniff;
      add_header X-XSS-Protection "1; mode=block";
      add_header Referrer-Policy "strict-origin-when-cross-origin";
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_pass          http://localhost:8289;
      add_header Strict-Transport-Security "max-age=63072000; includeSubdomains;";
      gzip off;
    }

    location = /xmpp-websocket {
    proxy_pass http://localhost:8289/xmpp-websocket?$args;
    proxy_http_version 1.1;
    proxy_set_header Connection "Upgrade";
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Host $host;
    proxy_read_timeout 900s;
    }
    listen 4443 ssl http2;

}
server {
    listen 80;
    server_name <b>myjitsi.somewhere.nu</b>;
}

</pre>
activate the config
 ```
root@debian10:/etc/nginx/sites-available# ln -s /etc/nginx/sites-available/jitsi.conf /etc/nginx/sites-enabled/jitsi.conf
root@debian10:/etc/nginx/sites-available# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@debian10:/etc/nginx/sites-available# systemctl restart nginx.service 
```
afterwards run certbot, activate ceritifcate for your jitsi domain and restart nginx again.
```
certbot
...
```
## go-mmproxy
go-mmproxy is in the debian bullseye release. get it by activating the repository for bullseye or just download / install it:
```
root@debian10:# wget http://ftp.de.debian.org/debian/pool/main/g/go-mmproxy/go-mmproxy_2.0-1+b3_amd64.deb
root@debian10:# dpkg -i go-mmproxy_2.0-1+b3_amd64.deb
```
get go-mmproxy-ssl.service from [sample](/sample/) and save it in in directory /etc/systemd/system
create a user and activate,enable the service
```
root@debian10:/etc/systemd/system# adduser --system mmproxy
root@debian10:/etc/systemd/system# systemctl enable go-mmproxy-ssl.service
root@debian10:/etc/systemd/system# systemctl start go-mmproxy-ssl.service
```
## haproxy
adjust haproxy config:
<pre>
frontend main
        mode    tcp
        bind 0.0.0.0:443 tfo
        option tcplog
        tcp-request inspect-delay 2s
        # "TLS / ssl turn"
        acl is_turn req_ssl_sni -i <b>myturndomain.somewhere.nu</b>
        acl is_local src 127.0.0.1/8 <b>192.168.B.C</b>
        acl is_ssl req_ssl_ver 1:4
        tcp-request content accept if is_ssl
        use_backend ssl-local if is_local is_ssl
        use_backend turn if is_turn
        default_backend ssl
backend turn
        mode tcp
        server turn 127.0.0.1:5349
backend ssl
        mode tcp
        server ssl 127.0.0.1:4444 send-proxy
backend ssl-local
        mode tcp
        server ssl 127.0.0.1:4443
</pre>
note: adjust 192.168.b.c to the local ip adress of the host / vm. backend ssl-local is used in order to be able to bypass go-mmproxy in case traffic is sent from the host itself to https based webservices offered on the host itself.
check the config is valid and restart the service.
<pre>
root@debian10:/etc/haproxy# haproxy -c -f /etc/haproxy/haproxy.cfg 
Configuration file is valid
root@debian10:/etc/haproxy# systemctl restart haproxy.service 
</pre>
