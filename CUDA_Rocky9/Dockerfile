#docker build -t rocky9cudaroot63612 .
#docker tag rocky9cudaroot63612:latest kamilskwarczynski/nukamil:rocky9cudaroot63612
#docker push kamilskwarczynski/nukamil:rocky9cudaroot63612
FROM nvidia/cuda:12.6.2-cudnn-devel-rockylinux9 AS cuda_build

# Install essential dependencies for ROOT and CUDA
RUN dnf -y install dnf-plugins-core ca-certificates \
    && dnf config-manager --set-enabled crb \
    && dnf -y install \
        gcc gcc-c++ gcc-gfortran \
        cmake3 make git \
        openssl-devel bzip2-devel zlib-devel \
        libxml2-devel pkgconf-pkg-config \
        xz-devel libuuid-devel \
        libX11-devel libXext-devel libXpm-devel libXft-devel \
        freetype-devel \
        mesa-libGL-devel \
        libpng-devel libjpeg-turbo-devel \
        fftw-devel gsl-devel \
        sqlite-devel \
        python3-numpy

ARG ROOT_VERSION=v6-36-12
ARG NCORES=16

RUN git clone --depth 1 --branch ${ROOT_VERSION} \
    https://github.com/root-project/root.git /opt/root-src

WORKDIR /opt/root/build

RUN cmake /opt/root-src \
    -DCMAKE_CXX_STANDARD=17 \
    -Dminuit2_omp=OFF \
    -Darrow=ON \
    -Dclad=OFF \
    -Dmathmore=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/root/${ROOT_VERSION}/ \
    -Droot7=OFF

RUN make -j ${NCORES}
RUN make install

FROM nvidia/cuda:12.6.2-cudnn-devel-rockylinux9

ARG ROOT_VERSION=v6-36-12

COPY --from=cuda_build /opt/root/${ROOT_VERSION}/ /opt/root/${ROOT_VERSION}/

RUN dnf -y install dnf-plugins-core ca-certificates \
    && dnf config-manager --set-enabled crb \
    && dnf -y install \
        gcc gcc-c++ gcc-gfortran \
        cmake3 make git \
        openssl-devel bzip2-devel zlib-devel \
        libxml2-devel pkgconf-pkg-config \
        xz-devel libuuid-devel \
        libX11-devel libXext-devel libXpm-devel libXft-devel \
        freetype-devel \
        mesa-libGL-devel \
        libpng-devel libjpeg-turbo-devel \
        fftw-devel gsl-devel \
        sqlite-devel \
        python3-numpy

ENV ROOTSYS=/opt/root/${ROOT_VERSION}
ENV PATH=${ROOTSYS}/bin:${PATH}
ENV LD_LIBRARY_PATH=${ROOTSYS}/lib:${LD_LIBRARY_PATH}
ENV Vdt_ROOT=${ROOTSYS}
