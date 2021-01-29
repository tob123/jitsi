ARG REGISTRY
FROM ${REGISTRY}/library/debian:10-slim
ARG S6_VERSION=a.b.c.
ARG S6_URL=https://github.com/just-containers/s6-overlay/releases/download
ENV GPG_S6="DB30 1BA3 F6F8 07E0 D0E6 CCB8 6101 B278 3B2F D161"
RUN set -x ;\
    apt-get update ; \
    apt-get -y --no-install-recommends install \ 
    apt-utils \
    ca-certificates \
    gpg \
    wget \
    curl ; \
    curl https://keybase.io/justcontainers/key.asc | gpg --import ; \
    wget -O /tmp/s6-overlay.tar.gz ${S6_URL}/${S6_VERSION}/s6-overlay-amd64.tar.gz ; \
    wget -O /tmp/s6-overlay.tar.gz.sig ${S6_URL}/${S6_VERSION}/s6-overlay-amd64.tar.gz.sig ; \
    FINGERPRINT="$(LANG=C gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz 2>&1 \
    | sed -n "s#Primary key fingerprint: \(.*\)#\1#p" | sed 's/  / /')";\
    echo $FINGERPRINT ;\
    if [ "${FINGERPRINT}" != "${GPG_S6}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi ;\
    tar xzf /tmp/s6-overlay.tar.gz -C / ; \
    ls /init ; \
    rm /tmp/s6-overlay.tar.gz /tmp/s6-overlay.tar.gz.sig; \
    apt-get remove -y --autoremove curl gpg apt-utils ca-certificates wget ; \
    apt-get clean ; \
    rm -rf /var/cache/apt /var/lib/apt/lists/* \
    "/var/log/dpkg.log" \
    "/var/log/apt/term.log" \
    "/root/.gnupg/pubring.kbx" \
    "/var/log/apt/history.log" \
    "/root/.gnupg/trustdb.gpg" \
    "/root/.wget-hsts" \
    "/var/cache/ldconfig/aux-cache" \
    "/root/.gnupg/pubring.kbx~"
ENTRYPOINT [ "/init" ]
