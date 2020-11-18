
#FROM debian:stable
#FROM debian:testing
FROM debian:unstable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized Mozilla DeepSpeech."

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
      sox \
      `# ` \
      `# Python. ` \
      python3 \
      python3-venv \
      python3-pip 

WORKDIR /deepspeech
#RUN python3 -m venv $HOME/tmp/deepspeech-venv/ && \
#      source $HOME/tmp/deepspeech-venv/bin/activate

RUN pip3 install deepspeech

#RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.1.1/deepspeech-0.1.1-models.tar.gz
#RUN  wget https://github.com/mozilla/DeepSpeech/releases/download/v0.4.0/deepspeech-0.4.0-models.tar.gz && \
#RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.4.1/deepspeech-0.4.1-models.tar.gz && \
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.1/deepspeech-0.9.1-models.pbmm   -O /deepspeech/models.pbmm && \
    wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.1/deepspeech-0.9.1-models.scorer -O /deepspeech/models.scorer 


WORKDIR /scratch
CMD ["/bin/bash", "/resources/internal/Run_Default.sh"]

