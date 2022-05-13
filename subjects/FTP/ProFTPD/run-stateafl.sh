#!/bin/bash

export TARGET_DIR="proftpd-stateafl"

# Blacklist allocations from main() -- they only hold initialization data, no session state
export BLACKLIST_ALLOC_SITES=$(objdump -t $WORKDIR/${TARGET_DIR}/proftpd |awk '($6=="main"){print "0x"$1"-"$5}')

source $WORKDIR/blacklist.sh

export INPUTS=${WORKDIR}/in-ftp-replay
