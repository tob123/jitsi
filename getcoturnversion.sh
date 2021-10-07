#!/bin/bash
curl -s https://git.alpinelinux.org/aports/plain/community/coturn/APKBUILD?h=3.14-stable | grep pkgver\= | awk -F '=' {'print $2'}
