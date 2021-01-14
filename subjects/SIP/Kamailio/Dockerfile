FROM ubuntu:16.04

# Install common dependencies
RUN apt-get -y update && \
    apt-get -y install sudo \ 
    apt-utils \
    build-essential \
    openssl \
    clang \
    graphviz-dev \
    git \
    libgnutls-dev \
    python-pip \
    nano \
    net-tools \
    vim \
    bison \
    flex

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Download and compile AFLNet
ENV LLVM_CONFIG="llvm-config-3.8"

# Set up fuzzers
RUN git clone https://github.com/profuzzbench/aflnet.git && \
    cd aflnet && \
    make clean all && \
    cd llvm_mode && make

RUN git clone https://github.com/profuzzbench/aflnwe.git && \
    cd aflnwe && \
    make clean all && \
    cd llvm_mode && make

# Set up environment variables for AFLNet
ENV WORKDIR="/home/ubuntu/experiments"
ENV AFLNET="/home/ubuntu/aflnet"
ENV PATH="${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1

RUN mkdir $WORKDIR && \
    pip install gcovr

COPY --chown=ubuntu:ubuntu in-sip ${WORKDIR}/in-sip
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu run_pjsip.sh ${WORKDIR}/run_pjsip
COPY --chown=ubuntu:ubuntu kamailio.patch ${WORKDIR}/kamailio.patch
COPY --chown=ubuntu:ubuntu pjsip.patch ${WORKDIR}/pjsip.patch
COPY --chown=ubuntu:ubuntu kamailio-basic.cfg ${WORKDIR}/kamailio-basic.cfg
COPY --chown=ubuntu:ubuntu StarWars3.wav ${WORKDIR}/StarWars3.wav

# Download and compile Kamalio for fuzzing
RUN cd $WORKDIR && \
    git clone https://github.com/kamailio/kamailio.git && \
    cd kamailio && \
    git checkout 2648eb3 && \
    patch -p1 < $WORKDIR/kamailio.patch && \
    CC=afl-clang-fast make cfg && \
    CC=afl-clang-fast make all

RUN cd $WORKDIR && \
    git clone https://github.com/pjsip/pjproject.git && \
    cd pjproject && \
    git checkout bba95b8 && \
    patch -p1 < $WORKDIR/pjsip.patch && \
    ./configure && \
    make dep && make clean && make

# Download and compile Kamalio for code coverage analysis
RUN cd $WORKDIR && \
    git clone https://github.com/kamailio/kamailio.git kamailio-gcov && \
    cd kamailio-gcov && \
    git checkout 2648eb3 && \
    patch -p1 < $WORKDIR/kamailio.patch && \
    make CC_EXTRA_OPTS="-fprofile-arcs -ftest-coverage" LD_EXTRA_OPTS="-fprofile-arcs -ftest-coverage" cfg && \
    make CC_EXTRA_OPTS="-fprofile-arcs -ftest-coverage" LD_EXTRA_OPTS="-fprofile-arcs -ftest-coverage" all
