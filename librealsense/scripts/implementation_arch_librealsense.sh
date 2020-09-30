#!/usr/bin/env bash

# This script prepares a build system suitable for developing with the Intel LibRealSense SDK on Arch Linux.

set -eux

mkdir -pv /scratch_base
cd /scratch_base

# Prepare alternative mirrors.
curl -o /etc/pacman.d/mirrorlist "https://www.archlinux.org/mirrorlist/?country=all&protocol=http&ip_version=4&use_mirror_status=on"
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist

# Disable signature checking.
#
# Note: This may not be needed -- it is only sometimes needed for very old base images.
sed -i -e 's/SigLevel[ ]*=.*/SigLevel = Never/g' \
       -e 's/.*IgnorePkg[ ]*=.*/IgnorePkg = archlinux-keyring/g' /etc/pacman.conf

# Install build dependencies.
#pacman -Sy --noconfirm archlinux-keyring
pacman -Syu --noconfirm --needed \
  base-devel \
  git \
  cmake \
  gcc \
  vim \
  gdb \
  screen \
  ` # Needed for an AUR helper ` \
  sudo \
  pyalpm \
  wget \
  rsync
rm -f /var/cache/pacman/pkg/*


# Create an unprivileged user for building packages.
# 
# Note: The 'archlinux' Docker container currently contains user 'aurbuild' and has yay installed already.
#       It won't hurt to add a new build user in case it is missing.
useradd -r -d /var/empty builduser
mkdir -p /var/empty/.config/yay
chown -R builduser:builduser /var/empty
printf '\n''builduser ALL=(ALL) NOPASSWD: ALL''\n' >> /etc/sudoers


# Download an AUR helper in case it is needed later.
#
# Note: `su - builduser -c "yay -S --noconfirm packageA packageB ..."`
if ! command -v yay &>/dev/null ; then
    cd /tmp
    wget 'https://github.com/Jguer/yay/releases/download/v10.0.2/yay_10.0.2_x86_64.tar.gz'
    tar -axf yay_*tar.gz
    mv yay_*/yay /tmp/
    rm -rf yay_*
    chmod 777 yay
    su - builduser -c "cd /tmp && ./yay -S --mflags --skipinteg --nopgpfetch --noconfirm yay-bin"
    rm -rf /tmp/yay
fi


# Install frequently-used dependencies.
pacman -S --noconfirm --needed  \
  gcc-libs \
  gsl \
  eigen \
  boost-libs \
  gnu-free-fonts \
  zlib \
  asio \
  nlopt \
  bash-completion \
  patchelf 
rm -f /var/cache/pacman/pkg/*


# Download the librealsense library.
#
# Note: see https://aur.archlinux.org/packages/librealsense/ for more information.
su - builduser -c "cd /tmp && yay -S --mflags --skipinteg --nopgpfetch --noconfirm librealsense"
#su - builduser -c "cd /tmp && yay -S --mflags --skipinteg --nopgpfetch --noconfirm librealsense-git"


