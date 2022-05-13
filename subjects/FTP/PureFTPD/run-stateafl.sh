#!/bin/bash

export TARGET_DIR="pure-ftpd-stateafl"

source $WORKDIR/blacklist.sh

export INPUTS=${WORKDIR}/in-ftp-replay
