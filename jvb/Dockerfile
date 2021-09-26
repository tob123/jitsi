ARG REGISTRY
FROM ${REGISTRY}/library/debian:11-slim
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
    "/var/log/apt/term.log" \
    "/var/log/apt/history.log" \
    "/var/log/apt/*" \
    "/var/cache/ldconfig/aux-cache" \
    "/var/log/alternatives.log" \
    "/etc/jitsi/videobridge/config" \
    "/etc/jitsi/videobridge/sip-communicator.properties" \
    "/var/cache/debconf/passwords.dat" ; \
    chmod +x /usr/local/bin/entry.sh /usr/local/bin/remove_setuid.sh ; \
    /usr/local/bin/remove_setuid.sh
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    JVB_ENABLE_APIS=rest,colibri
    
USER jvb
ENTRYPOINT [ "/usr/local/bin/entry.sh" ]

#CMD [ "/usr/share/jitsi-videobridge/jvb.sh", "--apis=${JVB_ENABLE_APIS:='none'}" ]
CMD [ "/usr/share/jitsi-videobridge/jvb.sh" ]
HEALTHCHECK CMD curl -f localhost:8080/about/health || exit 1

    
