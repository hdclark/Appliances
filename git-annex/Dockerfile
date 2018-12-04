
#FROM debian:stable
#FROM debian:testing
FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized git-annex."

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
      wget \
      `# ` \
      `# Git-Annex ` \
      git-annex \
      magic-wormhole


WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

