#docker build -t alma9icpxroot64000 .
#docker tag alma9icpxroot64000:latest kamilskwarczynski/nukamil:alma9icpxroot64000
#docker push kamilskwarczynski/nukamil:alma9icpxroot64000

########################################
# Stage 0: Base utilities (shared)
########################################
FROM almalinux:9 AS base

RUN dnf -y update && \
    dnf -y install epel-release dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf -y install \
        wget git gl2ps gl2ps-devel \
        gcc gcc-c++ gcc-gfortran \
        make cmake openssl-devel \
        perl giflib-devel xrootd-devel xrootd-client-devel \
        which findutils procps-ng  libSM-devel libICE-devel \
        ncurses ncurses-compat-libs libuuid-devel \
        tar gzip xz unzip krb5-devel fontconfig-devel \
        platform-python-devel python3-numpy python3-pyyaml python3-root libarrow-python-devel \
        python3-matplotlib python3-pyarrow python3-setuptools \
        python3 python3-pip python3-devel python3-numpy python3-pyyaml \
        openssh-clients fftw-devel gsl-devel gmp-devel hdf5-devel cfitsio-devel graphviz-devel \
        libX11-devel libXpm-devel libXft-devel libXext-devel libXt-devel libXaw-devel \
        mesa-libGLU-devel glew-devel motif-devel \
        libpng-devel libjpeg-turbo-devel freetype-devel \
        sqlite-devel libxml2-devel davix-devel \
        lz4-devel zlib-devel xz-devel pcre-devel \
        tbb-devel protobuf-devel protobuf-compiler \
        vim nano less tmux && \
    dnf clean all && rm -rf /var/cache/dnf

########################################
# Stage 1: Build ROOT
########################################
FROM base AS root-builder

ARG ROOT_VERSION=v6-40-00
ARG NCORES=16

RUN git clone --depth 1 --branch ${ROOT_VERSION} \
    https://github.com/root-project/root.git /tmp/root-src

RUN mkdir /tmp/root-build

WORKDIR /tmp/root-build

RUN cmake /tmp/root-src \
    -DCMAKE_INSTALL_PREFIX=/opt/root/${ROOT_VERSION} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17 \
    -Dminuit2_omp=OFF \
    -Darrow=ON \
    -Dmathmore=ON \
    -Dclad=OFF \
    -Dbuiltin_zstd=ON \
    -Droot7=OFF \
    -DPython3_EXECUTABLE=/usr/bin/python3
RUN make -j${NCORES} && make install


########################################
# Stage 2: Intel oneAPI build
########################################
FROM base AS oneapi-builder

RUN dnf -y install ncurses tar gzip xz perl && \
    dnf clean all

RUN wget -O /tmp/oneapi.sh \
    https://registrationcenter-download.intel.com/akdlm/IRC_NAS/bd1d0273-a931-4f7e-ab76-6a2a67d646c7/intel-oneapi-base-toolkit-2025.2.0.592.sh

RUN chmod +x /tmp/oneapi.sh

# IMPORTANT: force non-interactive safe environment
RUN TERM=xterm bash /tmp/oneapi.sh \
    -a --silent --cli --eula accept


########################################
# Stage 3: Final runtime image
########################################
FROM base AS final

ARG ROOT_VERSION=v6-40-00

# copy ROOT
COPY --from=root-builder /opt/root/${ROOT_VERSION} /opt/root/${ROOT_VERSION}

# copy Intel oneAPI
COPY --from=oneapi-builder /opt/intel /opt/intel

# environment
ENV ROOTSYS=/opt/root/${ROOT_VERSION}
ENV PATH=/opt/root/${ROOT_VERSION}/bin:/opt/intel/oneapi/compiler/latest/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/root/${ROOT_VERSION}/lib
ENV ONEAPI_ROOT=/opt/intel/oneapi

SHELL ["/bin/bash", "-c"]

# verify toolchains
RUN source /opt/intel/oneapi/setvars.sh && \
    icpx --version && \
    root-config --version

CMD ["/bin/bash"]
