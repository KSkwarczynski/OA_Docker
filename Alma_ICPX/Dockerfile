# Get ROOT 6.26.10 on AlmaLinux 9 as base
FROM picker24/root_v6_26_10:alma9 AS mach3_build

# Install necessary tools
RUN dnf install -y wget dnf-utils curl --allowerasing && dnf clean all

# Download Intel oneAPI Base Toolkit offline installer
RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/bd1d0273-a931-4f7e-ab76-6a2a67d646c7/intel-oneapi-base-toolkit-2025.2.0.592.sh -O /tmp/intel-oneapi-base-toolkit.sh

# Make installer executable
RUN chmod +x /tmp/intel-oneapi-base-toolkit.sh

# Run silent installation and accept license
RUN sh /tmp/intel-oneapi-base-toolkit.sh -a --silent --cli --eula accept

# Remove installer to reduce image size
RUN rm -f /tmp/intel-oneapi-base-toolkit.sh

# Set environment variables and use bash as shell
ENV ONEAPI_ROOT=/opt/intel/oneapi
SHELL ["/bin/bash", "-c"]

# Check Intel compiler version to verify installation
RUN source ${ONEAPI_ROOT}/setvars.sh && icpx --version
