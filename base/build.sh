export S6_VERSION=v2.1.0.2
export S6_VERSION_MAJOR=v2.1
sudo -E docker-compose build s6-base
sudo -E docker tag tob123/s6-base:${S6_VERSION} tob123/s6-base:${S6_VERSION_MAJOR}
sudo -E docker tag tob123/s6-base:${S6_VERSION} tob123/s6-base
sudo -E docker-compose build
