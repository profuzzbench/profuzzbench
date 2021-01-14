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
    sshpass \
    python-pip \
    nano \
    net-tools \
    vim

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
ENV PATH="${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1

RUN mkdir $WORKDIR && \
    pip install gcovr

COPY --chown=ubuntu:ubuntu in-ssh ${WORKDIR}/in-ssh
COPY --chown=ubuntu:ubuntu ssh.dict ${WORKDIR}/ssh.dict
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run

# Download and compile OpenSSH for fuzzing
RUN cd ${WORKDIR} && \
    git clone https://github.com/vegard/openssh-portable.git openssh && \
    cd openssh && \
    git checkout 7cfea58 && \
    autoreconf && \
    ./configure \
    CC="afl-clang-fast" \
    CFLAGS="-g -O3" \
    --prefix=$PWD/install \
    --with-privsep-path=$PWD/var-empty \
    --with-sandbox=no \
    --with-privsep-user=ubuntu && \
    make && \
    make install

# Download and compile OpenSSH for coverage analysis
RUN cd ${WORKDIR} && \
    git clone https://github.com/vegard/openssh-portable.git openssh-gcov && \
    cd openssh-gcov && \
    git checkout 7cfea58 && \
    autoreconf && \
    ./configure \
    CC="gcc" \
    CFLAGS="-g -O3 -fprofile-arcs -ftest-coverage" \
    LDFLAGS="-fprofile-arcs -ftest-coverage" \
    --prefix=$PWD/install \
    --with-privsep-path=$PWD/var-empty \
    --with-sandbox=no \
    --with-privsep-user=ubuntu && \
    make && \
    make install

# Run sshd and ssh once before fuzzing
RUN cd ${WORKDIR}/openssh && \
    ./sshd -d -e -p 22 -r -f sshd_config > /dev/null 2>&1 & sleep 5; sshpass -p "ubuntu" ssh -oStrictHostKeyChecking=no ubuntu@127.0.0.1 -p 22
    
