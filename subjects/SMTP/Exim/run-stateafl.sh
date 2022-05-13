#!/bin/bash

export TARGET_DIR="exim-stateafl"

# Blacklist buffers for logging and for temporary data
export BLACKLIST_GLOBALS=$(blacklist_global.sh $WORKDIR/exim-stateafl/src/build-Linux-x86_64/exim "debug_buffer,debug_prefix_length,debug_ptr,tree_printline")

export BLACKLIST_ALLOC_SITES=$(blacklist_alloc.sh $WORKDIR/exim-stateafl/src/build-Linux-x86_64/exim "smtp_in.c:2289,exim.c:1698,exim.c:1669")

export INPUTS=${WORKDIR}/in-smtp-replay
