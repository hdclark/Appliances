#!/usr/bin/env bash

deepspeech -h

# Prepare any audio files in the pwd.
find ./ -mindepth 1 -maxdepth 1 -type f \
  \(    -iname '*ogg' \
     -o -iname '*opus' \
     -o -iname '*mp3' \
     -o -iname '*flac' \
     -o \(       -iname '*wav'  \
           -a \! -iname '*_FOR_RECOGNITION.wav' \
         \) \
  \) \
  -exec ffmpeg -i '{}' \
               -sample_fmt s16 \
               -ar 16000 \
               -ac 1 \
               -af lowpass=3000,highpass=200 \
               '{}'_FOR_RECOGNITION.wav \;


# Perform the inference.
find ./ -mindepth 1 -maxdepth 1 -type f \
  -iname '*_FOR_RECOGNITION.wav' \
  -exec deepspeech --model /deepspeech/models.pbmm \
                   --scorer /deepspeech/models.scorer \
                   --audio '{}' \; \
  2> >(sed $'s,.*,\e[31m&\e[m,'>&2)  # Colour all stderr red.


# Tidy up the temp files.
find ./ -mindepth 1 -maxdepth 1 -type f \
  -iname '*_FOR_RECOGNITION.wav' \
  -delete

