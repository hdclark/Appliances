
FROM debian:stable
#FROM debian:testing
#FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized document processing tools."

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
      pdftk \
      `# ` \
      `# TeXlive stuff. ` \
      texlive-latex-base \
      texlive-latex-base-doc \
      texlive-latex-extra \
      texlive-latex-extra-doc \
      texlive-latex-recommended \
      texlive-latex-recommended-doc \
      `# ` \
      `# Pandoc. ` \
      pandoc \
      pandoc-citeproc \
      `# ` \
      `# Asciidoc. ` \
      asciidoc \
      asciidoc-dblatex \
      vim-asciidoc \
      `# ` \
      `# Some suggested packages for Pandoc/Asciidoc. ` \
      source-highlight \
      dot2tex \
      `# ` \
      `# Misc TeX-related tooling. ` \
      vim-latexsuite \
      texify \
      texvc \
      tralics \
      tth \
      ttm \
      untex \
      chktex \
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
      latexml \
      `# ` \
      `# Misc. ` \
      fonts-noto \
      lmodern


WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

