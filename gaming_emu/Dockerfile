
FROM archlinux/base

RUN sed -i -e 's/^[#]*SigLevel[ \t]*=.*/SigLevel = Never/g' \
           -e 's/^[#]*LocalFileSigLevel[ \t]*=.*/LocalFileSigLevel = Never/g' \
           -e 's/^[#]*RemoteFileSigLevel[ \t]*=.*/RemoteFileSigLevel = Never/g' /etc/pacman.conf && \
    pacman -Syu --noconfirm --needed \
      git \
      xorg-xserver \
      xf86-video-fbdev \
      retroarch \
      libretro && \
    rm -f /var/cache/pacman/pkg/*


## Create a temporary user for building AUR packages.
#RUN useradd -r -d /var/empty aurbuild  && \
#    mkdir -p /var/empty/ && \
#    chown -R aurbuild:aurbuild /var/empty/ && \
#    printf '\n''aurbuild ALL=(ALL) NOPASSWD: ALL''\n' >> /etc/sudoers
#
#
## Install an AUR helper.
#WORKDIR /yay
#RUN git clone https://aur.archlinux.org/yay-bin.git . && \
#    chown -R aurbuild:aurbuild . && \
#    su - aurbuild -c "cd /yay && makepkg --syncdeps --install --clean --needed --noconfirm --rmdeps" && \
#    rm -rf /yay
#
#
### Install AUR packages.
#RUN mkdir -p /var/empty/.config && chown aurbuild /var/empty/.config
#
#
#RUN su - aurbuild -c "yay -S --noconfirm --needed --afterclean --aur meshlab-git freecad" && \
#    rm -f /var/cache/pacman/pkg/*
#

WORKDIR /scratch
CMD ["/bin/retroarch"]


