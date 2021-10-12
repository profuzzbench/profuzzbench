#!/bin/bash

#export NO_CACHE="--no-cache"
#export MAKE_OPT="-j4"

cd $PFBENCH
cd subjects/FTP/LightFTP
docker build . -t lightftp --build-arg MAKE_OPT $NO_CACHE
docker build . -t lightftp-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/FTP/BFTPD
docker build . -t bftpd --build-arg MAKE_OPT $NO_CACHE
docker build . -t bftpd-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/FTP/ProFTPD
docker build . -t proftpd --build-arg MAKE_OPT $NO_CACHE
docker build . -t proftpd-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/FTP/PureFTPD
docker build . -t pure-ftpd --build-arg MAKE_OPT $NO_CACHE
docker build . -t pure-ftpd-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/SMTP/Exim
docker build . -t exim --build-arg MAKE_OPT $NO_CACHE
docker build . -t exim-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/DNS/Dnsmasq
docker build . -t dnsmasq --build-arg MAKE_OPT $NO_CACHE
docker build . -t dnsmasq-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/RTSP/Live555
docker build . -t live555 --build-arg MAKE_OPT $NO_CACHE
docker build . -t live555-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/SIP/Kamailio
docker build . -t kamailio --build-arg MAKE_OPT $NO_CACHE
docker build . -t kamailio-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/SSH/OpenSSH
docker build . -t openssh --build-arg MAKE_OPT $NO_CACHE
docker build . -t openssh-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/TLS/OpenSSL
docker build . -t openssl --build-arg MAKE_OPT $NO_CACHE
docker build . -t openssl-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/DTLS/TinyDTLS
docker build . -t tinydtls --build-arg MAKE_OPT $NO_CACHE
docker build . -t tinydtls-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/DICOM/Dcmtk
docker build . -t dcmtk --build-arg MAKE_OPT $NO_CACHE
docker build . -t dcmtk-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

cd $PFBENCH
cd subjects/DAAP/forked-daapd
docker build . -t forked-daapd --build-arg MAKE_OPT $NO_CACHE
docker build . -t forked-daapd-stateafl -f Dockerfile-stateafl --build-arg MAKE_OPT $NO_CACHE

