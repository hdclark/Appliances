
#FROM debian:stable
#FROM debian:testing
FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized ffmpeg."

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
      `# FFmpeg. ` \
      ffmpeg \
      ffmpeg-doc \
      `# ` \
      `# Playback and conversion. ` \
      mplayer \
      mpv \
      `# ` \
      `# Misc other. ` \
      atomicparsley \
      libimage-exiftool-perl \
      exiv2 \
      youtube-dl 


WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

