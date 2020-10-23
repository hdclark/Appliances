
#FROM debian:stable
#FROM debian:testing
FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized document processing tools."

WORKDIR /resources
ADD . /resources

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get --yes update && \
    apt-get --yes --no-install-recommends install \
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
      wget \
      patch \
      less \
      zip \
      bzip2 \
      file \
      xz-utils \
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
      `# ` \
      `# Note: The following package results in a massive container. ` \
      `#       Enable if something out of the ordinary is needed.` \
      `# texlive-full ` \
      texlive-latex-base \
      texlive-latex-base-doc \
      texlive-latex-extra \
      texlive-latex-extra-doc \
      texlive-latex-recommended \
      texlive-latex-recommended-doc \
      texlive-xetex \
      texlive-pstricks \
      texlive-pstricks-doc \
      texlive-fonts-extra \
      texlive-font-utils \
      texlive-extra-utils `# <-- includes pdfjam ` \
      `# ` \
      `# Misc TeX-related tooling. ` \
      vim-latexsuite \
      texify \
      `# texvc ` \
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
      `# Markdown, Pandoc, Asciidoc, etc. ` \
      pandoc \
      pandoc-citeproc \
      cmark-gfm \
      grip \
      markdown \
      mkdocs \
      mkdocs-doc \
      python3-pandocfilters \
      asciidoc \
      asciidoc-dblatex \
      vim-asciidoc \
      source-highlight \
      dot2tex \
      `# ` \
      `# Libreoffice and related. ` \
      `# Note: these pull in lots of dependencies (e.g., apparmor, openjdk, mesa, ...). ` \
      `# libreoffice ` \
      `# unoconv ` \
      `# ` \
      `# Misc. ` \
      pdftk \
      ps2eps \
      dvisvgm \
      fonts-liberation \
      fontconfig \
      fonts-noto \
      fonts-noto-color-emoji \
      fonts-noto-extra \
      fonts-noto-mono \
      fonts-noto-ui-core \
      fonts-noto-ui-extra \
      fonts-noto-unhinted \
      lmodern \
      fonts-dejavu-core \
      fonts-dejavu-extra \
      hunspell \
      hunspell-en-ca \
      xlsx2csv \
      binfmt-support

# Install Firefox Fire fonts for Beamer's Metropolis theme.
WORKDIR /extras
#RUN  sed -i -e 's/main$/main contrib non-free/g' /etc/apt/sources.list && \
#     apt-get update
#RUN git clone 'https://github.com/eddelbuettel/pkg-fonts-fira' && \
#      cd pkg-fonts-fira && \
#RUN git clone 'https://github.com/mozilla/Fira.git' Fira && \
RUN wget 'https://github.com/mozilla/Fira/archive/master.zip' -O Fira.zip && \
      unzip -d Fira Fira.zip && \
      cd Fira/Fira-master && \
      chmod 644 otf/* ttf/* && \
      mv otf/* ttf/* /usr/local/share/fonts/ && \
      fc-cache && \
      cd / && rm -rf /extras


WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

