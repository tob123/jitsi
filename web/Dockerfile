ARG REGISTRY
ARG PROJECT
ARG S6_VERSION
ARG BUILD_REGISTRY_PRD
FROM ${BUILD_REGISTRY_PRD}/${PROJECT}/s6-base:${S6_VERSION}
ARG JITSI_DEB_VERSION=x.y.z
COPY rootfs /
RUN set -ex; \
    apt-get update ; \
    apt-get --no-install-recommends install -y \
    curl \
    ca-certificates \
    gnupg ; \
    curl https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/jitsi-keyring.gpg ; \
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/jitsi-keyring.gpg] https://download.jitsi.org stable/' | tee /etc/apt/sources.list.d/jitsi-stable.list ; \
    apt-get update ; \
    apt-get --no-install-recommends install -y \
    jitsi-meet-web nginx-extras; \
    apt-get --no-install-recommends -d install -y jitsi-meet-web-config=${JITSI_DEB_VERSION}; \
    dpkg -x /var/cache/apt/archives/jitsi-meet-web-config*.deb /tmp/pkg && \
    mv /tmp/pkg/usr/share/jitsi-meet-web-config/config.js /defaults && \
	rm -f /etc/nginx/conf.d/default.conf && \
    # test with up2date npm based packages
#    apt-get remove -y --autoremove jitsi-meet-web; \
#    dpkg -i /root/jitsi-meet-web*;\
    chmod +x /etc/cont-init.d/10-config ; \
    apt-get remove -y --autoremove ca-certificates gnupg ; \
    apt-get clean ; \
	rm -rf /tmp/pkg /var/cache/apt /var/lib/apt/lists/* \
    "/var/log/dpkg.log" \
    "/var/log/apt/term.log" \
    "/var/cache/ldconfig/aux-cache" \
    "/var/log/apt/history.log" \
    "/var/log/alternatives.log"
#    adduser --shell /bin/bash --gecos 'admin user' --uid 2000 --disabled-password jitsiadmin ; \
#    chown -R jitsiadmin /etc/cont-init.d ; \
#    chown -R jitsiadmin:prosody /etc/prosody
#ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ENTRYPOINT [ "/init" ]
HEALTHCHECK CMD curl -f http://localhost | grep jitsi || exit 1
