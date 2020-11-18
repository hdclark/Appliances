#!/usr/bin/env bash

#deepspeech -h

find ./ -mindepth 1 -maxdepth 1 -type f \
  \(    -iname '*ogg' \
     -o -iname '*opus' \
     -o -iname '*mp3' \
     -o -iname '*aac' \
     -o -iname '*flac' \
     -o \(       -iname '*wav'  \
           -a \! -iname '*_FOR_RECOGNITION.wav' \
         \) \
  \) \
  -exec bash -c '
    f_in="$0"
    f_txt="${f_in}.txt"
    f_tmp="${f_in}_FOR_RECOGNITION.wav"

    # Pre-process audio files to the required format.
    ffmpeg -hide_banner \
           -loglevel warning \
           -i "${f_in}" \
           -nostats \
           -sample_fmt s16 \
           -ar 16000 \
           -ac 1 \
           -af lowpass=3000,highpass=200 \
           "${f_tmp}"

    # Perform the inference.
    deepspeech --model /deepspeech/models.pbmm \
               --scorer /deepspeech/models.scorer \
               --audio "${f_tmp}" >> "${f_txt}" 2>/dev/null
    cat "${f_txt}"

    # Tidy up the temp file.
    rm "${f_tmp}"
  ' '{}' \;

