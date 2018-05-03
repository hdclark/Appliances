
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
      `# ` \
      `# Building utilities. ` \
      build-essential \
      g++ \
      gdb \
      clang \
      clang-format \
      clang-tidy \
      bear \
      afl-clang \
      valgrind \
      libtsan0 \
      `# ` \
      `# Vim binaries and misc. ` \
      vim \
      vim-doc \
      vim-fugitive \
      vim-pathogen \
      vim-syntastic \
      vim-youcompleteme

# TODO:
# - add https://github.com/JBakamovic/yavide/blob/master/docs/INSTALL.md
# - add clangd when available.
# - add rtags (? emacs-only ?).
# - add cquery (github: cquery-project/cquery).



WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

