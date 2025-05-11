#docker build -t rocky9cudalatest .
#docker tag rocky9cudalatest kamilskwarczynski/nukamil
#docker push kamilskwarczynski/nukamil:rocky9cudalatest
FROM nvidia/cuda:12.6.2-cudnn-devel-rockylinux9 AS cuda_build

# Install essential dependencies for ROOT and CUDA
RUN dnf -y update \
    && dnf -y install dnf-plugins-core ca-certificates \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y update \
    && dnf -y install  gcc gcc-c++ gcc-gfortran cmake3 make imake autoconf automake pkgconfig libtool \
                       git wget subversion openssh-clients openssl-devel bzip2 cvs \
                       xorg-x11-utils \
                       libXt-devel libXpm-devel libXaw-devel libXft-devel libXext-devel libAfterImage-devel graphviz-devel \
                       libuuid-devel xrootd-client-devel xrootd-devel xrootd-server-devel krb5-devel \
                       mesa-libGLU-devel mesa-libGLw glew-devel motif-devel libpng-devel libjpeg-turbo-devel ftgl-devel \
                       libxml2-devel gmp-devel gsl-devel log4cpp-devel bzip2-devel pcre-devel xz-devel zlib-devel \
                       freetype-devel fftw-devel blas-devel lapack-devel lz4-devel z3-devel xz-devel libnsl2-devel \
                       davix-devel libomp-devel \
                       fmt-devel spdlog-devel eigen3-devel \
                       libzip-devel protobuf-devel protobuf-compiler \
                       libarrow-devel libarrow-python-devel \
                       boost-devel boost-filesystem tbb-devel hdf5-devel sqlite-devel \
                       platform-python-devel python3-numpy \
                       vim nano gdb csh tcsh ed quota patch procmail less tmux task-spooler procps \
                       libasan libubsan gperftools

ARG ROOT_VERSION=v6-30-04
ARG NCORES=16

RUN git clone --depth  1 --branch ${ROOT_VERSION} https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root/build
RUN cmake /opt/root-src \
    -DCMAKE_CXX_STANDARD=17 \
    -Dminuit2=ON \
    -Dminuit2_omp=ON \
    -Darrow=ON \
    -Dclad=OFF \
    -Dmathmore=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/root/${ROOT_VERSION}/ \
    -Droot7=OFF
RUN make -j ${NCORES}
RUN make install

ARG ROOT_VERSION=v6-30-04

ENV ROOTSYS=/opt/root/${ROOT_VERSION}
ENV PATH=${ROOTSYS}/bin:${PATH} \
    LD_LIBRARY_PATH=${ROOTSYS}/lib:${LD_LIBRARY_PATH} \
    Vdt_ROOT=${ROOTSYS}
