#docker build -t ubi9cudaroot63804 .
#docker tag ubi9cudaroot63804:latest kamilskwarczynski/nukamil:ubi9cudaroot63804
#docker push kamilskwarczynski/nukamil:ubi9cudaroot63804
FROM nvidia/cuda:12.6.2-devel-ubi9 AS cuda_build

RUN curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    rpm -Uvh epel-release-latest-9.noarch.rpm && \
    /usr/bin/crb enable && \
    dnf install -y \
        gcc gcc-c++ gcc-gfortran cmake make autoconf automake pkgconfig libtool \
        git wget openssh-clients openssl-devel bzip2 \
        libXpm-devel libxml2-devel gmp-devel log4cpp-devel \
        freetype-devel fftw-devel lz4-devel z3-devel \
        davix-devel libomp-devel \
        hdf5-devel python3-devel python3-numpy vim nano gdb less procps \
        libasan libubsan

ARG ROOT_VERSION=v6-38-04
ARG NCORES=16

RUN git clone --depth 1 --branch ${ROOT_VERSION} https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root/build
RUN cmake /opt/root-src \
    -DCMAKE_CXX_STANDARD=17 \
    -Dminuit2_omp=OFF \
    -Darrow=ON \
    -Dclad=OFF \
    -Dmathmore=ON \
    -Droot7=OFF \
    -Dx11=OFF \
    -Dxrootd=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/root/${ROOT_VERSION}/
RUN make -j ${NCORES}
RUN make install

FROM nvidia/cuda:12.6.2-devel-ubi9

ARG ROOT_VERSION=v6-38-04

COPY --from=cuda_build /opt/root/${ROOT_VERSION}/ /opt/root/${ROOT_VERSION}/

RUN curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    rpm -Uvh epel-release-latest-9.noarch.rpm && \
    /usr/bin/crb enable && \
    dnf install -y \
        gcc gcc-c++ gcc-gfortran cmake make autoconf automake pkgconfig libtool \
        git wget openssh-clients openssl-devel bzip2 \
        libXpm-devel libxml2-devel gmp-devel log4cpp-devel \
        freetype-devel fftw-devel lz4-devel z3-devel \
        davix-devel libomp-devel \
        hdf5-devel python3-devel python3-numpy vim nano gdb less procps \
        libasan libubsan

ENV ROOTSYS=/opt/root/${ROOT_VERSION}
ENV PATH=${ROOTSYS}/bin:${PATH}
ENV LD_LIBRARY_PATH=${ROOTSYS}/lib:${LD_LIBRARY_PATH}
ENV Vdt_ROOT=${ROOTSYS}
