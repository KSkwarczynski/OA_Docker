#To run use:  docker build --secret id=tokens,src=tokens.txt -t mach3t2k .
FROM kamilskwarczynski/mach3:latest AS mach3t2k_build

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
    git clone https://oauth2:${GITLAB_TOKEN}@git.t2k.org/t2k-sk/t2ksk-common T2KSKTools
RUN ./setup_T2KSKTools.sh

#Get NIWG RW
RUN --mount=type=secret,id=tokens \
    source /run/secrets/tokens && \
    git clone https://KSkwarczynski:${GITHUB_TOKEN}@github.com/t2k-software/NIWGReWeight
RUN ./setup_niwgreweight.sh
ENV NIWG_ROOT=${MACH3_T2K_WORK_DIR}/NIWGReWeight/build/
ENV PATH=${NIWG_ROOT}/Linux/bin:${PATH} \
    LD_LIBRARY_PATH=${NIWG_ROOT}/Linux/lib:${LD_LIBRARY_PATH}

RUN mkdir -p ${MACH3_T2K_INSTALL_DIR}
WORKDIR ${MACH3_T2K_INSTALL_DIR}

#KS Terrible hack calling NIWG RW setup and cmake allows to find NWIG RW without problems
RUN source ${NIWG_ROOT}/Linux/bin/setup.NIWG.sh && cmake ../
#-D CMAKE_FIND_DEBUG_MODE=ON

RUN make && make install

RUN source ${MACH3_T2K_INSTALL_DIR}/bin/setup.MaCh3T2K.sh
