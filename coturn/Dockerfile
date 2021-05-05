ARG REGISTRY
FROM ${REGISTRY}/library/alpine:3.13
COPY rootfs /
RUN apk add --no-cache \
    curl \
    coturn ; \
    chmod +x /usr/local/bin/entry.sh \
             /usr/local/bin/containercheck.sh \
             /usr/local/bin/detect-external-ip.sh ; \
    mkdir /var/run/coturn ; \
    chown turnserver /var/lib/coturn /var/run/coturn
USER turnserver
ENTRYPOINT ["entry.sh"]

CMD ["--log-file=stdout", "--external-ip=$(detect-external-ip.sh)", "--allowed-peer-ip=$XMPP_SERVER_IP", "--allowed-peer-ip=$JVB_SERVER_IP", "--allowed-peer-ip=$TURN_SERVER_IP", "-c ${TURN_CONFIG}", "-r $TURN_DOMAIN", "--listening-ip=$TURN_SERVER_IP"]
HEALTHCHECK CMD /usr/local/bin/containercheck.sh 

EXPOSE 3478 3478/udp 5349


    
