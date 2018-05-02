
FROM debian:stable
#FROM debian:testing
#FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized vim_ide."

EXPOSE 22/tcp \
       80/tcp    443/tcp

WORKDIR /resources
ADD . /resources

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get --yes update && \
    apt-get --yes install \
      `# ` \
      `# Core utilities. ` \
      git \
      rsync \
      sshfs \
      openssh-server \
      man-db \
      screen \
      build-essential \
      gdb \
      `# ` \
      `# Vim binaries and misc. ` \
      vim \
      vim-doc \
      vim-fugitive \
      vim-pathogen \
      vim-syntastic \
      vim-youcompleteme \
      clang \
      clang-format \
      clang-tidy \
      bear \
      afl-clang

# TODO:
# - add https://github.com/JBakamovic/yavide/blob/master/docs/INSTALL.md
# - add clangd when available.
# - add rtags (? emacs-only ?).



WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

