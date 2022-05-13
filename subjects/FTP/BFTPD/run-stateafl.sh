#!/bin/bash

export TARGET_DIR="bftpd-stateafl"

source $WORKDIR/blacklist_asan.sh

export INPUTS=${WORKDIR}/in-ftp-replay
