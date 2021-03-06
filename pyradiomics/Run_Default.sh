#!/usr/bin/env bash

# This script will act like a simplistic init process inside the container, setting up the runtime environment and
# launching necessary programs. It is invoked by default, but can be overridden when launching the container.

## Prepare the environment.
##
## Note: can also be done in the Dockerfile if expected to always be needed.
#export MPLBACKEND=agg
#export LC_ALL=C.UTF-8
#export LANG=C.UTF-8

## Launch a dummy X server.
#/usr/bin/Xorg \
#  -noreset \
#  +extension GLX \
#  +extension RANDR \
#  +extension RENDER \
#  -depth 24 \
#  -logfile ./xdummy.log \
#  -config /etc/X11/xorg.conf \
#  :1 &
#xpid=$!
#
#sleep 5
#export DISPLAY=:1

# Run a service or perform an operation.
pyradiomics --help

## Clean up, if necessary (usually not).
#kill $xpid

