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
    libgnutls-dev \
    libssl-dev \
    python-pip \
    nano \
    net-tools \
    vim \
    gdb \
    netcat \
    strace \
    wget

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

RUN chmod 777 /tmp

RUN pip install gcovr==4.2

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Download and compile AFLNet
ENV LLVM_CONFIG="llvm-config-3.8"

# Set up fuzzers
RUN git clone https://github.com/profuzzbench/aflnet.git && \
    cd aflnet && \
    make clean all $MAKE_OPT && \
    cd llvm_mode && make $MAKE_OPT

RUN git clone https://github.com/profuzzbench/aflnwe.git && \
    cd aflnwe && \
    make clean all $MAKE_OPT && \
    cd llvm_mode && make $MAKE_OPT

# Set up environment variables for AFLNet
ENV WORKDIR="/home/ubuntu/experiments"
ENV AFLNET="/home/ubuntu/aflnet"
ENV PATH="${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1


RUN mkdir $WORKDIR

USER root
RUN apt-get -y install sshpass


COPY --chown=ubuntu:ubuntu rand.patch ${WORKDIR}/rand.patch
COPY --chown=ubuntu:ubuntu rand.inc ${WORKDIR}/rand.inc

# Set up environment variables for ASAN
env ASAN_OPTIONS='abort_on_error=1:symbolize=0:detect_leaks=0:detect_stack_use_after_return=1:detect_container_overflow=0:poison_array_cookie=0:malloc_fill_byte=0:max_malloc_fill_size=16777216'


# Download and compile OpenSSH for fuzzing
RUN cd ${WORKDIR} && \
    git clone https://github.com/vegard/openssh-portable.git openssh && \
    cd openssh && \
    git checkout 7cfea58 && \
    cp ${WORKDIR}/rand.inc . && \
    patch -p1 < ${WORKDIR}/rand.patch && \
    autoreconf && \
    ./configure \
    CC="afl-clang-fast" \
    CFLAGS="-g -O3" \
    --prefix=$PWD/install \
    --with-privsep-path=$PWD/var-empty \
    --with-sandbox=no \
    --with-privsep-user=ubuntu && \
    AFL_USE_ASAN=1 make $MAKE_OPT && \
    make install

# Download and compile OpenSSH for coverage analysis
RUN cd ${WORKDIR} && \
    git clone https://github.com/vegard/openssh-portable.git openssh-gcov && \
    cd openssh-gcov && \
    git checkout 7cfea58 && \
    cp ${WORKDIR}/rand.inc . && \
    patch -p1 < ${WORKDIR}/rand.patch && \
    autoreconf && \
    ./configure \
    CC="gcc" \
    CFLAGS="-g -O3 -fprofile-arcs -ftest-coverage" \
    LDFLAGS="-fprofile-arcs -ftest-coverage" \
    --prefix=$PWD/install \
    --with-privsep-path=$PWD/var-empty \
    --with-sandbox=no \
    --with-privsep-user=ubuntu && \
    make $MAKE_OPT && \
    make install

COPY --chown=ubuntu:ubuntu in-ssh ${WORKDIR}/in-ssh
COPY --chown=ubuntu:ubuntu ssh.dict ${WORKDIR}/ssh.dict
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run

