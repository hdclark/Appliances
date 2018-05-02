
FROM debian:stable
#FROM debian:testing
#FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized texlive."

EXPOSE 22/tcp \
       80/tcp    443/tcp \
       104/tcp   104/udp \
       2761/tcp  2761/udp \
       2762/tcp  2762/udp \
       11112/tcp 11112/udp

WORKDIR /resources
ADD . /resources

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get --yes update && \
    apt-get --yes install \
      `# ` \
      `# Core utilities. ` \
      vim \
      git \
      rsync \
      sshfs \
      openssh-server \
      man-db \
      cmake \
      screen \
      `# ` \
      `# Image conversion support tooling ` \
      poppler-utils \
      poppler-data \
      libpoppler-cpp-dev \
      libpoppler-dev \
      libpoppler-cil \
      libpoppler-cil-dev \
      imagemagick \
      ghostscript \
      ghostscript-doc \
      `# ` \
      `# TeXlive stuff. ` \
      texlive-latex-base \
      texlive-latex-base-doc \
      texlive-latex-extra \
      texlive-latex-extra-doc \
      texlive-latex-recommended \
      texlive-latex-recommended-doc \
      `# ` \
      `# Misc TeX-related tooling. ` \
      vim-latexsuite \
      texify \
      texvc \
      tralics \
      tth \
      ttm \
      untex \
      mathtex \
      mimetex \
      rubber \
      biber \
      csv2latex \
      hevea \
      jabref \
      lacheck \
      latex-make \
      latex-mk \
      latexmk \
      latex2html \
      latex2rtf \
      latex2rtf-doc \
      latexdiff \
      latexml


WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

