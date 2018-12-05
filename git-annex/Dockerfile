
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


# Setup a non-authentication sshd.
RUN sed -i -e 's/^[#]*PermitRootLogin.*/PermitRootLogin yes/' \
           -e 's/^[#]*Port.*/Port 22/' \
           -e 's/^[#]*PermitEmptyPasswords.*/PermitEmptyPasswords yes/' \
           -e 's/^[#]*UsePAM.*/UsePAM yes/' \
    /etc/ssh/sshd_config


# Create a non-root user, but do not default to it so we can launch sshd with root.
RUN ( groupadd --gid 985 --non-unique users 2>/dev/null || \
      groupmod --gid 985 --non-unique users 2>/dev/null ) && \
    useradd -m -s /bin/bash -u 1000 -g users hal

# Disable the password so we can login without credentials.
#
# NOTE: This is convenient for local-only installations, but dangerous!
#RUN passwd -d hal # No password!

WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

