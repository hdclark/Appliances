#!/bin/bash

# This script will act like a simplistic init process inside the container, setting up the runtime environment and
# launching necessary programs. It is invoked by default, but can be overridden when launching the container.

## Prepare the environment.
#export XYZ="..."

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
printf '\n'
printf '=====================\n'
printf 'gdcmanon version\n'
printf '=====================\n'
gdcmanon --version

printf '\n'
printf '=====================\n'
printf 'gdcmanon version\n'
printf '=====================\n'
dcmdump --version 

printf '\n'
printf 'To anonymize you must invoke one of:\n'
printf '  /resources/internal/Run_anonymize.sh\n'
printf 'or\n'
printf '  /resources/internal/Run_anonymize_partial.sh\n'
printf 'The top-level directories mapped to /artifacts/ will each be anonymized.\n'

## Clean up, if necessary (usually not).
#kill $xpid

