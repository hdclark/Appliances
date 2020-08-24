#!/usr/bin/env bash

# Launch a software X server capable of emulating OpenGL.
/usr/bin/Xorg \
  -noreset \
  +extension GLX \
  +extension RANDR \
  +extension RENDER \
  -depth 24 \
  -logfile ./xdummy.log \
  -config /etc/X11/xorg.conf \
  :1 &
xpid=$!

sleep 5
export DISPLAY=:1


cd "$EGS_HOME"
make
egs_app -i slab.egsinp
egs_view slab.egsinp slab.ptracks


# Terminate the X server in case the container will be re-used.
kill $xpid

