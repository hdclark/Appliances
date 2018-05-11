
#FROM debian:stable
#FROM debian:testing
FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized DICOM anonymizer."

EXPOSE 22/tcp \
       80/tcp    443/tcp \
       104/tcp   104/udp \
       2761/tcp  2761/udp \
       2762/tcp  2762/udp \
       11112/tcp 11112/udp

WORKDIR /resources
ADD . /resources
ADD ./scripts/anonymize /usr/bin
ADD ./scripts/anonymize_partial /usr/bin

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
      `# ` \
      `# GDCM binaries, development, and runtime libraries. ` \
      gdcm-doc \
      libgdcm-cil \
      libgdcm-tools \
      libgdcm2-dev \
      python-gdcm \
      `# ` \
      `# DCMTK binaries, development, and runtime libraries. ` \
      dcmtk \
      dcmtk-doc \
      libdcmtk-dev \
      libodil0 \
      libodil0-dev \
      libodil0-doc


WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

