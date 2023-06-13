ARG BUILD_REGISTRY_PRD
ARG PROJECT
ARG S6_VERSION
#FROM ${BUILD_REGISTRY_PRD}/proxy-cache/jitsi/prosody:stable-7001 as JITSI_PROSODY
ARG BUILD_REGISTRY_PRD
ARG PROJECT
ARG S6_VERSION
FROM ${BUILD_REGISTRY_PRD}/${PROJECT}/s6-base:${S6_VERSION}
ARG JITSI_VERSION_GITHUB=X.Y.Z
#COPY --from=JITSI_PROSODY /usr/local/lib/lua /usr/local/lib/lua
#COPY --from=JITSI_PROSODY /usr/local/share/lua /usr/local/share/lua
RUN set -ex; \
    apt-get update ; \
    apt-get --no-install-recommends install -y \
    curl \
    ca-certificates \
    gpg-agent \
    gpg ; \
#    curl https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/jitsi-keyring.gpg ; \
    curl https://prosody.im/files/prosody-debian-packages.key | apt-key add - ; \
    echo deb http://packages.prosody.im/debian stable main | tee -a /etc/apt/sources.list ; \
    apt-get update 
RUN    apt-get --no-install-recommends install -y \
    lua5.2 \
    lua-unbound \
    lua-cjson \
    lua-luaossl \
    prosody \
    libssl1.1 \
    sasl2-bin \
    libsasl2-modules-ldap \
    lua-basexx \
    lua-ldap \
    lua-sec ; \
    mkdir -p /jitsi/prosody-plugins ; \
    cd /jitsi/prosody-plugins ; \
    curl -L --output - https://github.com/jitsi/jitsi-meet/archive/oldstable/jitsi-meet_${JITSI_VERSION_GITHUB}.tar.gz | tar zxf - --wildcards "*/resources/prosody-plugins" --strip-components=3 ;\
    mkdir /etc/prosody/conf.d ; \
    ln -s /var/lib/prosody/auth.meet.jitsi.crt /etc/prosody/certs/auth.meet.jitsi.crt ; \
    ln -s /var/lib/prosody/auth.meet.jitsi.key /etc/prosody/certs/auth.meet.jitsi.key ; \
    ln -s /var/lib/prosody/meet.jitsi.crt /etc/prosody/certs/meet.jitsi.crt ; \
    ln -s /var/lib/prosody/meet.jitsi.key /etc/prosody/certs/meet.jitsi.key ; \
    mkdir /var/run/prosody ; \
    chown -R prosody:prosody /etc/prosody/certs /var/run/prosody ; \
    chmod 700 /etc/prosody/certs ; \
    apt-get remove --autoremove -y gpg gpg-agent ca-certificates ; \
    apt-get clean ; \
    find /etc/ssl/certs -type l -exec rm {} \; ; \
    rm -rf  /var/cache/apt /var/lib/apt/lists/* \
    /etc/sasldb2 \
    "/etc/prosody/certs/localhost.key" \
    "/etc/prosody/certs/localhost.crt" \
    "/etc/ssl/private/ssl-cert-snakeoil.key" \
    "/var/log/dpkg.log" \
    "/var/log/apt/*" \
    "/var/log/apt/term.log" \
    "/var/log/apt/history.log" \
    "/var/cache/ldconfig/aux-cache" \
    "/var/log/alternatives.log"
COPY rootfs /
RUN chmod +x /usr/local/bin/checkcontainer.sh
#    adduser --shell /bin/bash --gecos 'admin user' --uid 2000 --disabled-password jitsiadmin ; \
#    chown -R jitsiadmin /etc/cont-init.d ; \
#    chown -R jitsiadmin:prosody /etc/prosody
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PROSODY_LOG_LEVEL=info \
    JWT_APP_ID=jitsi
#USER jitsiadmin
HEALTHCHECK CMD /usr/local/bin/checkcontainer.sh
ENTRYPOINT [ "/init" ]

    
