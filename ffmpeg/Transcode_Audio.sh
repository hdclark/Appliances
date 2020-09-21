#!/usr/bin/env bash

apt-get update -y
apt-get install -y sox

in_file="in.opus"
normalized_file="in_normalized.wav"
silenced_file="in_silenced.wav"
out_file="out.mp3"

#NOISE_TOLERANCE="1dB"
#ffmpeg -i "$in_file" -af silenceremove=0:0:0:-1:1:"${NOISE_TOLERANCE}" -ac 1 "$normalized_file" -y

ffmpeg -i "$in_file" -filter:a loudnorm -ac 1 "$normalized_file" -y
ffmpeg -i "$normalized_file" -filter:a volumedetect -f null /dev/null

#sox "$normalized_file" "$silenced_file" silence -l 1 0.3 1% -1 2.0 1%
sox "$normalized_file" "$silenced_file" silence 1 0.1 0.5% -1 0.1 0.5%

ffmpeg -i "$silenced_file" -ac 1 "$out_file"
