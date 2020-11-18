#!/usr/bin/env bash

#deepspeech -h

find ./ -mindepth 1 -maxdepth 1 -type f \
  `# Prepare any audio files in the pwd.` \
  \(    -iname '*ogg' \
     -o -iname '*opus' \
     -o -iname '*mp3' \
     -o -iname '*aac' \
     -o -iname '*flac' \
     -o \(       -iname '*wav'  \
           -a \! -iname '*_FOR_RECOGNITION.wav' \
         \) \
  \) \
  -exec ffmpeg -hide_banner \
               -loglevel warning \
               -i '{}' \
               -nostats \
               -sample_fmt s16 \
               -ar 16000 \
               -ac 1 \
               -af lowpass=3000,highpass=200 \
               '{}'_FOR_RECOGNITION.wav \; \
  \
  `# Perform the inference.` \
  -exec bash -c '
    deepspeech --model /deepspeech/models.pbmm \
               --scorer /deepspeech/models.scorer \
               --audio "$@"_FOR_RECOGNITION.wav >> "$@".txt
    ' '{}' \; \
  \
  `# Tidy up the temp files.` \
  -exec rm '{}'_FOR_RECOGNITION.wav \;

