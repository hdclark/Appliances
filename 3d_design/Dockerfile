
#FROM debian:unstable
FROM archlinux/base

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
RUN useradd -r -d /var/empty aurbuild  && \
    mkdir -p /var/empty/ && \
    chown -R aurbuild:aurbuild /var/empty/ && \
    printf '\n''aurbuild ALL=(ALL) NOPASSWD: ALL''\n' >> /etc/sudoers


# Install an AUR helper.
WORKDIR /yay
RUN git clone https://aur.archlinux.org/yay-bin.git . && \
    chown -R aurbuild:aurbuild . && \
    su - aurbuild -c "cd /yay && makepkg --syncdeps --install --clean --needed --noconfirm --rmdeps" && \
    rm -rf /yay


## Install AUR packages.
RUN mkdir -p /var/empty/.config && chown aurbuild /var/empty/.config


RUN su - aurbuild -c "yay -S --noconfirm --needed --afterclean --aur meshlab-git freecad" && \
    rm -f /var/cache/pacman/pkg/*


WORKDIR /scratch
CMD ["/bin/bash"]

