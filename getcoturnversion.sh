#!/bin/bash
curl -s https://git.alpinelinux.org/aports/plain/community/coturn/APKBUILD?h=3.12-stable | grep pkgver\= | awk -F '=' {'print $2'}
