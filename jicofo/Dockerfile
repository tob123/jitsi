ARG REGISTRY
FROM ${REGISTRY}/library/debian:11-slim
ARG JICOFO_DEB_VERSION=x.y.z
COPY rootfs /
RUN set -ex ; \
    apt-get update ; \
    apt-get upgrade -y ; \
    apt-get --no-install-recommends install -y \
    curl \
    ca-certificates \
    gnupg ; \
    curl https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/jitsi-keyring.gpg ; \
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/jitsi-keyring.gpg] https://download.jitsi.org stable/' | tee /etc/apt/sources.list.d/jitsi-stable.list ; \
    mkdir -p /usr/share/man/man1 ; \
    apt-get update ; \
    apt-get --no-install-recommends install -y \
    jicofo=${JICOFO_DEB_VERSION} ; \
    chown jicofo /config ; \
    chmod 700 /config ; \
    chmod +x /usr/local/bin/entry.sh ; \
    apt-get remove --autoremove -y gnupg ; \
#    adduser --shell /bin/bash --gecos 'admin user' --uid 2000 --disabled-password jitsiadmin ; \
#    chown -R jitsiadmin /etc/cont-init.d ; \
#    chown -R jitsiadmin:prosody /etc/prosody
    apt-get clean ; \
   rm -rf /var/cache/apt /var/lib/apt/lists/* \
    rm -rf /var/cache/apt /var/lib/apt/lists/* \
    "/var/log/dpkg.log" \
    "/var/log/apt/term.log" \
    "/var/log/apt/history.log" \
    "/var/log/apt/*" \
    "/root/.gnupg/pubring.kbx" \
    "/var/log/alternatives.log" \
    "/root/.gnupg/trustdb.gpg" \
    "/root/.wget-hsts" \
    "/var/cache/ldconfig/aux-cache" \
    "/etc/jitsi/jicofo/config" \
    "/var/cache/debconf/passwords.dat" \
    "/root/.gnupg/pubring.kbx~"
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
USER jicofo

ENTRYPOINT [ "/usr/local/bin/entry.sh" ]
#CMD [ "/usr/share/jicofo/jicofo.sh", "--domain=meet.jitsi", "--host=xmpp.meet.jitsi", "--user_name=focus", "--user_domain=auth.meet.jitsi" ]
CMD [ "/usr/share/jicofo/jicofo.sh" ]
HEALTHCHECK CMD curl -f http://localhost:8888/about/health || exit 1
