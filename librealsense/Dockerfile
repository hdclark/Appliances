
# NOTE: This Dockerfile should be interepretted relative to the Appliances repo root.

FROM archlinux:latest

LABEL maintainer="http://www.halclark.ca" \
      description="Development environment using Arch Linux with LibRealSense."

WORKDIR /scratch_base
COPY librealsense /scratch_base

RUN /scratch_base/scripts/implementation_arch_librealsense.sh

