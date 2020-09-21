
FROM archlinux

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized Blender."


# Prepare alternative mirrors.
RUN curl -o /etc/pacman.d/mirrorlist "https://www.archlinux.org/mirrorlist/?country=all&protocol=http&ip_version=4&use_mirror_status=on" && \
    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist

# Install build dependencies.
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu --noconfirm --needed \
      base-devel \
      blender && \
    rm -f /var/cache/pacman/pkg/*

WORKDIR /scratch
CMD ["/bin/bash"]


