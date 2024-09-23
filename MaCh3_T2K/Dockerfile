#To run use: docker build --secret id=tokens,src=tokens.txt -t mach3t2k .

#docker tag localhost/mach3t2k:latest ghcr.io/t2k-software/mach3/mach3t2k:alma9latest
#docker login ghcr.io
#docker push ghcr.io/t2k-software/mach3/mach3t2k:alma9latest
FROM ghcr.io/mach3-software/mach3:alma9latest AS mach3t2k_build

ENV MACH3_T2K_VERSION="develop"
ENV MACH3_T2K_WORK_DIR=/opt/MaCh3T2K/
ENV MACH3_T2K_INSTALL_DIR=${MACH3_T2K_WORK_DIR}/build

ARG GITHUB_TOKEN
ARG GITLAB_TOKEN

RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    echo "GITHUB_TOKEN=$GITHUB_TOKEN" && \
    echo "GITLAB_TOKEN=$GITLAB_TOKEN"

RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    git clone https://KSkwarczynski:${GITHUB_TOKEN}@github.com/t2k-software/MaCh3.git ${MACH3_T2K_WORK_DIR}

WORKDIR ${MACH3_T2K_WORK_DIR}
RUN git checkout ${MACH3_T2K_VERSION}

#KS: Get inputs
RUN ./setup_inputs.sh

RUN mkdir -p ${MACH3_T2K_INSTALL_DIR}
WORKDIR ${MACH3_T2K_INSTALL_DIR}

#KS Terrible hack calling NIWG RW setup and cmake allows to find NWIG RW without problems
RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    export GITHUB_TOKEN=${GITHUB_TOKEN} && \
    export GITLAB_TOKEN=${GITLAB_TOKEN} && \
    cmake ../

RUN make -j4 && make install
