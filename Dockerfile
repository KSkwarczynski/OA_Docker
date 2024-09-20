#dnf install -y podman
#To run use:  podman build --secret id=tokens,src=tokens.txt -t mach3t2k .
#docker push ghcr.io/t2k-software/MaCh3/mach3t2k:alma9latest

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

#Get T2K SK Tool
RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    git clone https://oauth2:${GITLAB_TOKEN}@git.t2k.org/t2k-sk/t2ksk-common.git T2KSKTools
RUN ./setup_T2KSKTools.sh


#KS: Get inputs
RUN ./setup_inputs.sh

RUN mkdir -p ${MACH3_T2K_INSTALL_DIR}
WORKDIR ${MACH3_T2K_INSTALL_DIR}

#KS Terrible hack calling NIWG RW setup and cmake allows to find NWIG RW without problems
RUN  cmake ../

RUN make && make install
