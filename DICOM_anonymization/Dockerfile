
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
ADD ./internal/scripts/anonymize /usr/bin
ADD ./internal/scripts/anonymize_partial /usr/bin

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
      `# Note: The following package is out-of-date and possibly not needed.` \
      `# python-gdcm` \
      libgdcm-cil \
      libgdcm-tools \
      libgdcm2-dev \
      `# ` \
      `# DCMTK binaries, development, and runtime libraries. ` \
      dcmtk \
      dcmtk-doc \
      libdcmtk-dev \
      libodil0 \
      libodil0-dev \
      libodil0-doc


WORKDIR /scratch
CMD ["/bin/bash", "/resources/internal/Run_Default.sh"]

