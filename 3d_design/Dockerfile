
FROM debian:stable

LABEL maintainer="http://www.halclark.ca" \
      description="Containerized tools for 3D design and printing."

RUN apt-get -y update && \
    apt-get -y install \
      inkscape \
      freecad \
      openscad \
      cura \
      gimp \
      vim \
      gedit \
      rsync

WORKDIR /scratch
CMD ["/bin/bash"]


