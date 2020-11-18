#!/usr/bin/env bash

# This script uses sox to record the speaker until 3s of silence is detected,
# uses deepspeech to transcribe the audio, and then uses xdotool to emit
# keyboard presses mimicing the transcribed text.

set -u

# Create a working directory.
tmpdir="$(mktemp -d)"
trap "{ rmdir '${tmpdir}' &>/dev/null ; }" EXIT 

# Record audio in the working directory.
export SOX_OPTS="-V0"
timeout 60s \
  rec -V0 "${tmpdir}"/audio.flac rate 16k silence  1 0.1 '1%'  1 5.0 '10%' 1>&2

# Debugging...
#mplayer "${tmpdir}"/audio.flac

# Transcribe the audio file.
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"
(
  cd "${tmpdir}/"
  text="$( "${script_dir}"/Run_Container.sh )"

  # Debugging...
  text="$( cat "${tmpdir}/"*txt )"

  printf '%s ' "${text}"
  #xdotool type "${text}"
)

rm -rf "${tmpdir}/"*{flac,txt}

