#!/bin/bash

export TARGET_DIR="kamailio-stateafl"

# Blacklisting the (unused) memory pool of the qm_malloc custom memory allocator
export BLACKLIST_ALLOC_SITES=$(objdump -t $WORKDIR/${TARGET_DIR}/src/kamailio |awk '($6=="qm_malloc_init_pkg_manager"){print "0x"$1"-"$5}')

export INPUTS=${WORKDIR}/in-sip-replay
