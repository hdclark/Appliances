
FROM debian:stable
#FROM debian:testing
#FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized rstats."

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
      wget \
      `# ` \
      `# R stuff. ` \
      r-base \
      r-base-core \
      r-base-dev \
      r-base-html \
      r-recommended \
      littler \
      r-cran-dplyr \
      r-cran-crayon \
      r-cran-coin \
      r-cran-cluster \
      r-cran-caret \
      r-cran-formatr \
      r-cran-ggplot2 \
      r-cran-gbm \
      r-cran-gnm \
      r-cran-gsl \
      r-cran-hmisc \
      r-cran-jsonlite \
      r-cran-lazyeval \
      r-cran-lme4 \
      r-cran-lpsolve \
      r-cran-lsmeans \
      r-cran-magrittr \
      r-cran-mass \
      r-cran-mi \
      r-cran-minpack.lm \
      r-cran-minqa \
      r-cran-misctools \
      r-cran-multicore \
      r-cran-nleqslv \
      r-cran-nlme \
      r-cran-nloptr \
      r-cran-nlp \
      r-cran-optparse \
      r-cran-permute \
      r-cran-plyr \
      r-cran-prettyunits \
      r-cran-r.utils \
      r-cran-randomforest \
      r-cran-rcpp \
      r-cran-reshape \
      r-cran-reshape2 \
      r-cran-rjags \
      r-cran-robustbase \
      r-cran-rpostgresql \
      r-cran-rprotobuf \
      r-cran-rsqlite \
      r-cran-tibble \
      r-cran-tidyr \
      r-cran-tm \
      r-cran-uuid \
      r-cran-viridis \
      r-cran-xtable \
      r-cran-yaml \
      r-cran-zoo \
      r-doc-html

# Install Firefox Fire fonts for plots that match Beamer's Metropolis theme.
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

