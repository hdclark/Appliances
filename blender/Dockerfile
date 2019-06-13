
FROM archlinux/base

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized Blender."


# Prepare alternative mirrors.
RUN printf -- 'Server = http://mirror.cedille.club/archlinux/$repo/os/$arch\n' > /etc/pacman.d/mirrorlist \
    printf -- 'Server = http://mirrors.xmission.com/archlinux/$repo/os/$arch\n' >> /etc/pacman.d/mirrorlist \
    printf -- 'Server = http://archlinux.mirror.rafal.ca/$repo/os/$arch\n' >> /etc/pacman.d/mirrorlist


# Install build dependencies.
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu --noconfirm --needed \
      base-devel \
      blender && \
    rm -f /var/cache/pacman/pkg/*

WORKDIR /scratch
CMD ["/bin/bash"]


