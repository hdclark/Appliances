
#FROM debian:unstable
FROM archlinux

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized tools for 3D design and printing."


#RUN pacman-key --populate && \
#RUN pacman-key --refresh-keys && \
#    pacman -Sy --noconfirm archlinux-keyring && \
RUN sed -i -e 's/^SigLevel[ \t]*=.*/SigLevel = TrustAll/g' /etc/pacman.conf && \
    pacman -Syu --noconfirm --needed \
      base-devel \
      git \
      inkscape \
      openscad \
      cura \
      gimp \
      vim \
      gedit \
      rsync && \
    rm -f /var/cache/pacman/pkg/*


# Create a temporary user for building AUR packages.
RUN useradd -r -d /var/empty builduser  && \
    mkdir -p /var/empty/ && \
    chown -R builduser:builduser /var/empty/ && \
    printf '\n''builduser ALL=(ALL) NOPASSWD: ALL''\n' >> /etc/sudoers


# Install an AUR helper unless one is already present.
WORKDIR /yay
RUN if ! command -v yay ; then git clone https://aur.archlinux.org/yay-bin.git . && \
    chown -R builduser:builduser . && \
    su - builduser -c "cd /yay && makepkg --syncdeps --install --clean --needed --noconfirm --rmdeps" && \
    rm -rf /yay ; fi

#RUN mkdir -p /var/empty/.config && chown builduser /var/empty/.config

## Install AUR packages.
RUN su - builduser -c "yay -S --noconfirm --needed --afterclean --aur meshlab-git freecad" && \
    rm -f /var/cache/pacman/pkg/*


WORKDIR /scratch
CMD ["/bin/bash"]


