
FROM base/archlinux

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized Arch Linux, with some development tools preinstalled."


# Prepare alternative mirrors.
RUN printf -- 'Server = http://mirror.cedille.club/archlinux/$repo/os/$arch\n' > /etc/pacman.d/mirrorlist \
    printf -- 'Server = http://mirrors.xmission.com/archlinux/$repo/os/$arch\n' >> /etc/pacman.d/mirrorlist \
    printf -- 'Server = http://archlinux.mirror.rafal.ca/$repo/os/$arch\n' >> /etc/pacman.d/mirrorlist


# Install build dependencies.
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu --noconfirm --needed \
      base-devel \
      git \
      cmake \
      gcc \
      vim \
      gdb \
      screen \
      openssh \
    ` # Needed for an AUR helper ` \
    sudo pyalpm wget rsync && \
    rm -f /var/cache/pacman/pkg/*


# Create a temporary user for building AUR packages.
RUN useradd -r -d /var/empty aurbuild  && \
    mkdir -p /var/empty/ && \
    chown -R aurbuild:aurbuild /var/empty/ && \
    printf '\n''aurbuild ALL=(ALL) NOPASSWD: ALL''\n' >> /etc/sudoers


# Install an AUR helper.
WORKDIR /yay
RUN git clone https://aur.archlinux.org/yay.git . && \
    chown -R aurbuild:aurbuild . && \
    su - aurbuild -c "cd /yay && makepkg --syncdeps --install --clean --needed --noconfirm --rmdeps" && \
    rm -rf /yay


## Install AUR packages.
#RUN mkdir -p /var/empty/.config && chown aurbuild /var/empty/.config
#
#RUN su - aurbuild -c "yay -S --noconfirm --needed --afterclean --aur browsh-bin" && \
#    rm -f /var/cache/pacman/pkg/*


# Default to launching the webserver.
WORKDIR /scratch
CMD ["/bin/bash"]


