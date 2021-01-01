
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
RUN sed -i \
      -e 's/^[#]*Port.*/Port 22/' \
      -e 's/^[#]*PasswordAuthentication.*/PasswordAuthentication no/' \
      -e 's/^[#]*PubkeyAuthentication.*/PubkeyAuthentication yes/' \
      -e 's/^[#]*PermitEmptyPasswords.*/PermitEmptyPasswords no/' \
      -e 's/^[#]*PermitRootLogin.*/PermitRootLogin prohibit-password/' \
      -e 's/^[#]*UsePAM.*/UsePAM yes/' \
      -e 's/^[#]*StrictModes.*/StrictModes no/' \
    /etc/ssh/sshd_config

# Create a non-root user, but do not default to it so we can launch sshd with root.
RUN ( groupadd --gid 1000 --non-unique users 2>/dev/null || \
      groupmod --gid 1000 --non-unique users 2>/dev/null ) && \
    useradd -m -s /bin/bash -u 1000 -g users hal

# Configure ssh connections.
RUN mkdir -p /home/hal/.ssh/sockets && \
    ( printf '\n\n' ; \
      printf '%s\n' 'Host *' ; \
      printf '%s\n' '    ControlMaster auto' ; \
      printf '%s\n' '    ControlPath ~/.ssh/sockets/%r@%h-%p' ; \
      printf '%s\n' '    ControlPersist 4h' ; \
      printf '\n\n' ) > /home/hal/.ssh/config && \
    chown --recursive hal:users /home/hal/.ssh

WORKDIR /scratch
CMD ["/bin/bash", "/resources/Run_Default.sh"]

