ARG REGISTRY
FROM ${REGISTRY}/library/debian:10-slim
ARG JVB_DEB_VERSION=z.b.c
COPY rootfs /
RUN set -ex ; \
    apt-get update ; \
    apt-get --no-install-recommends install -y \
    curl \
    ca-certificates \
    gnupg ; \
    curl https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/jitsi-keyring.gpg ; \
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/jitsi-keyring.gpg] https://download.jitsi.org stable/' | tee /etc/apt/sources.list.d/jitsi-stable.list ; \
    apt-get update ; \
    mkdir -p /usr/share/man/man1 ; \
    apt-get --no-install-recommends install -y \
    jitsi-videobridge2=${JVB_DEB_VERSION} ; \
    apt-get remove --autoremove -y gnupg ; \
    apt-get clean ; \
    rm -rf /var/cache/apt /var/lib/apt/lists/* \
    "/var/log/dpkg.log" \
    "/var/log/apt/*" \
    "/var/cache/ldconfig/aux-cache" \
    "/var/log/alternatives.log" \
    "/etc/jitsi/videobridge/config" \
    "/etc/jitsi/videobridge/sip-communicator.properties" \
    "/var/cache/debconf/passwords.dat" ; \
    chmod +x /usr/local/bin/entry.sh /usr/local/bin/remove_setuid.sh ; \
    /usr/local/bin/remove_setuid.sh
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PUBLIC_URL_DOMAIN=bla.nu.me \
    ENABLE_TURN=1 \
    TURN_DOMAIN=turn.bla.me \
    JVB_PORT=10000 \
    XMPP_SERVER=xmpp.meet.jitsi \
    XMPP_AUTH_DOMAIN=auth.meet.jitsi \
    JVB_AUTH_USER=jvb \
    XMPP_INTERNAL_MUC_DOMAIN=internal-muc.meet.jitsi \
    DOCKER_HOST_ADDRESS= \
    JVB_ENABLE_APIS=rest,colibri \
    JVB_STUN_SERVER=bla.stun.now \
    XMPP_SERVER=xmpp.meet.jitsi
    
USER jvb
ENTRYPOINT [ "/usr/local/bin/entry.sh" ]

#CMD [ "/usr/share/jitsi-videobridge/jvb.sh", "--apis=${JVB_ENABLE_APIS:='none'}" ]
CMD [ "/usr/share/jitsi-videobridge/jvb.sh" ]
HEALTHCHECK CMD curl -f localhost:8080/about/health || exit 1

    
