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
deepspeech -h


find ./ -mindepth 1 -maxdepth 1 -type f \
  \( -iname '*ogg' -o -iname '*opus' -o -iname '*mp3' -o -iname '*flac' \) \
  -exec ffmpeg -i '{}' -sample_fmt s16 -ar 16000 -ac 1 '{}'_FOR_RECOGNITION.wav \;


find ./ -mindepth 1 -maxdepth 1 -type f \
  -iname '*_FOR_RECOGNITION.wav' \
  -exec deepspeech --model /deepspeech/models/output_graph.pbmm \
                   --alphabet /deepspeech/models/alphabet.txt \
                   --lm /deepspeech/models/lm.binary \
                   --trie /deepspeech/models/trie \
                   --audio '{}' \; \
  2> >(sed $'s,.*,\e[31m&\e[m,'>&2)  # Colour all stderr red.


find ./ -mindepth 1 -maxdepth 1 -type f \
  -iname '*_FOR_RECOGNITION.wav' \
  -exec deepspeech --model /deepspeech/models/output_graph.pbmm \
                   --alphabet /deepspeech/models/alphabet.txt \
                   --audio '{}' \; \
  2> >(sed $'s,.*,\e[31m&\e[m,'>&2)  # Colour all stderr red.


find ./ -mindepth 1 -maxdepth 1 -type f \
  -iname '*_FOR_RECOGNITION.wav' \
  -delete


## Clean up, if necessary (usually not).
#kill $xpid

