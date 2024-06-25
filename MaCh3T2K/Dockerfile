#To run use:  docker build --secret id=tokens,src=tokens.txt -t mach3t2k .
FROM ghcr.io/mach3-software/mach3:alma9latest AS mach3t2k_build

ENV MACH3_T2K_VERSION="feature_T2K_refactor_ND_updates"
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

#Get NIWG RW
RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    git clone https://KSkwarczynski:${GITHUB_TOKEN}@github.com/t2k-software/NIWGReWeight
RUN ./setup_niwgreweight.sh
ENV NIWG_ROOT=${MACH3_T2K_WORK_DIR}/NIWGReWeight/build/
ENV PATH=${NIWG_ROOT}/Linux/bin:${PATH} \
    LD_LIBRARY_PATH=${NIWG_ROOT}/Linux/lib:${LD_LIBRARY_PATH}

#KS: Get inputs
RUN ./setup_inputs.sh

#Get psyche
RUN ln -s $(which python3) /usr/local/bin/python

WORKDIR ${MACH3_T2K_WORK_DIR}/psychestuff/
RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    git clone https://oauth2:${GITLAB_TOKEN}@git.t2k.org/nd280/pilot/nd280SoftwarePilot.git nd280SoftwarePilot

RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    git clone https://oauth2:${GITLAB_TOKEN}@git.t2k.org/nd280/highland2Software/highland2SoftwarePilot.git


WORKDIR ${MACH3_T2K_WORK_DIR}
RUN mkdir -p ${MACH3_T2K_WORK_DIR}/psychestuff

RUN ./setup_psyche.sh

RUN mkdir -p ${MACH3_T2K_INSTALL_DIR}
WORKDIR ${MACH3_T2K_INSTALL_DIR}

#KS Terrible hack calling NIWG RW setup and cmake allows to find NWIG RW without problems
RUN source ${NIWG_ROOT}/Linux/bin/setup.NIWG.sh \
            && cd ${MACH3_T2K_WORK_DIR}/psychestuff/nd280SoftwarePilot \
            && ./configure.sh \
            && cd  ${MACH3_T2K_INSTALL_DIR} \
            && source ${MACH3_T2K_WORK_DIR}/psychestuff/nd280SoftwarePilot/nd280SoftwarePilot.profile \
            && source ${MACH3_T2K_WORK_DIR}/psychestuff/highland2SoftwarePilot/highland2SoftwarePilot.profile \
            && source ${MACH3_T2K_WORK_DIR}psychestuff/psycheMaster_*/Linux*/setup.sh \
            && cmake ../

RUN make && make install
