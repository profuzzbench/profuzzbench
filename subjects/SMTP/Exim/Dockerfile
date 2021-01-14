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
    autoconf \
    libssl-dev \
    libpcre3-dev \
    pkg-config \
    libdb-dev \
    libgdbm-dev \
    nano \
    net-tools \
    vim \
    python-pip

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

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
ENV PATH="/usr/exim/bin:${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1

RUN mkdir $WORKDIR && \
    pip install gcovr

COPY --chown=ubuntu:ubuntu in-smtp ${WORKDIR}/in-smtp
COPY --chown=ubuntu:ubuntu smtp.dict ${WORKDIR}/smtp.dict
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu exim.patch ${WORKDIR}/exim.patch
COPY --chown=ubuntu:ubuntu exim.configure.patch ${WORKDIR}/exim.configure.patch
COPY --chown=ubuntu:ubuntu compile_exim_gcov.sh ${WORKDIR}/compile_exim_gcov.sh

# Download, compile and install Exim for fuzzing
RUN cd ${WORKDIR} && \
    git clone https://github.com/Exim/exim && \
    cd exim && \
    git checkout 38903fb && \
    cd src; mkdir Local; cp src/EDITME Local/Makefile && \
    cd Local; patch -p1 < ${WORKDIR}/exim.patch; cd .. && \
    make CC=afl-clang-fast clean all install

# Configure exim
RUN cd /usr/exim && \
    patch -p1 < ${WORKDIR}/exim.configure.patch && \
    chmod 1777 /var/mail
