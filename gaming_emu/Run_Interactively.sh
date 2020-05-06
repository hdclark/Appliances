#!/bin/bash

# This script launches a Docker image that can pass-through X11 and OpenGL windows.
#
# It might fail! Especially if .Xauthority files are used.
#
# Idea re-implemented from http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/ .
# See the comments on that page for ideas if this fails.
# Other options include VNC and ssh forwarding.
#
# See https://github.com/jessfraz/dockerfiles/issues/359 for info about the MIT-SHM (X_ShmPutImage) error fix.
#

set -eu

if [ "$EUID" -eq 0 ] ; then
    printf "This script should not be run as root. Refusing to continue.\n" 1>&2
    exit 1
fi

# Create a simple 'init' script that can be run from inside the container.
#
# All arguments sent to the present script are forwarded to this internal script.
#
internal_run_script="$(mktemp)"
trap "{ rm '${internal_run_script}' ; }" EXIT  # Remove the temp file on exit.

# The calling user's username on the host, which we will re-use inside the container.
uname=$(id -u -n)
gname=$(id -g -n)
uid=$(id -u)
gid=$(id -g)

cat > "${internal_run_script}" <<EOF
#!/bin/bash

# Copy host files to facilitate easier interoperation.
#cp /etc/passwd_prototype /etc/passwd
#cp /etc/group_prototype  /etc/group
#cp /etc/shadow_prototype /etc/shadow

# Create a user with the same credentials as the host user.
groupadd -g ${gid} -f ${gname} || true
useradd -g ${gname} -u ${uid} -G video -m -d '/home/container_${uname}' -s /bin/bash ${uname}

# Copy host Xauth file.
cp /etc/Xauthority_prototype /home/container_${uname}/.Xauthority || true
chown ${uname}:${gname} /home/container_${uname}/.Xauthority || true

# Install additional packages.
#apt-get -y update
#apt-get -y install firefox-esr

#
printf 'export PS1="${uname}@container> "\n' >> /home/${uname}/.bashrc

# Pass-through any arguments sent to the run script (not this script, the script that created this script).
all_args='$@'

if [ -z "\$all_args" ] ; then 
    printf '### Entering interactive bash shell now... ###\n'
    runuser -u ${uname} -- /bin/bash -i

else # Pass the command through.
    runuser -u ${uname} -- \$all_args

fi

EOF
chmod 777 "${internal_run_script}"


# Launch the container.
sudo \
  docker run \
    -it --rm \
    --network=host \
    `# Avoid a (potential) X error involving the MIT-SHM extension (X_ShmPutImage) by disabling IPC namespacing.` \
    --ipc=host \
    -e DISPLAY \
    \
    `# Map X-related host locations into the container. ` \
    `# -v /tmp/.X11-unix:/tmp/.X11-unix:rw ` \
    -v /tmp/:/tmp/:rw \
    -v "$HOME"/.Xauthority:/etc/Xauthority_prototype:ro \
    -v /dev/null:/dev/input/js0:ro \
    -v /dev/null:/dev/input/js1:ro \
    -v /dev/null:/dev/input/js2:ro \
    -v "${internal_run_script}":/x11_launch_script.sh:ro \
    \
    `# Map various locations from host into the container prospectively. ` \
    -v /:/host_root/:ro \
    -v /media/:/media/:ro \
    -v "$(pwd)":/start/:rw \
    -w /start/ \
    \
    gaming_emu:latest \
    \
    /x11_launch_script.sh

#    debian:stable \
#    -v /etc/passwd:/etc/passwd_prototype:ro \
#    -v /etc/group:/etc/group_prototype:ro \
#    -v /etc/shadow:/etc/shadow_prototype:ro \
