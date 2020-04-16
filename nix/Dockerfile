
FROM nixos/nix

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized Nix, with some development tools preinstalled."


RUN nix-channel --add 'https://nixos.org/channels/nixpkgs-unstable' nixpkgs && \
    nix-channel --update

#RUN nix-shell ...
#RUN nix-build ...


## Create a temporary user.
#RUN useradd -r -d /var/empty auser  && \
#    mkdir -p /var/empty/ && \
#    chown -R auser:auser /var/empty/ && \
#    printf '\n''auser ALL=(ALL) NOPASSWD: ALL''\n' >> /etc/sudoers
#
#RUN su - auser -c "cd /yay && makepkg --syncdeps --install --clean --needed --noconfirm --rmdeps" && \


WORKDIR /scratch
CMD ["/bin/sh"]


