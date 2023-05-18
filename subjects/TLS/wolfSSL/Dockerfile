FROM ubuntu:20.04

# Install common dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y install sudo \ 
    apt-utils \
    build-essential \
    openssl \
    clang \
    graphviz-dev \
    git \
    autoconf \
    libgnutls28-dev \
    libssl-dev \
    llvm \
    python3-pip \
    nano \
    net-tools \
    vim \
    gdb \
    netcat \
    strace \
    libtool \
    wget

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

RUN chmod 777 /tmp

RUN pip3 install gcovr==6.0
RUN apt-get -y install jq

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up environment variables
ENV WORKDIR="/home/ubuntu/experiments"

# Ignore that coredump collector is enabled
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1

RUN mkdir $WORKDIR

COPY --chown=ubuntu:ubuntu flush-exit.patch ${WORKDIR}/flush-exit.patch

# Set up environment variables for ASAN
env ASAN_OPTIONS='abort_on_error=1:symbolize=0:detect_leaks=0:detect_stack_use_after_return=1:detect_container_overflow=0:poison_array_cookie=0:malloc_fill_byte=0:max_malloc_fill_size=16777216'

# Download and compile wolfSSL for coverage analysis
RUN cd ${WORKDIR} && \
    git clone --depth 1 --single-branch --branch v5.3.0-stable https://github.com/wolfSSL/wolfssl wolfssl-gcov
RUN cd ${WORKDIR}/wolfssl-gcov && \
    autoreconf --install && \
    patch -p1 < ${WORKDIR}/flush-exit.patch && \
    CC="clang" CFLAGS="-DWOLFSSL_GENSEED_FORTEST -DWC_RNG_SEED_CB -fprofile-arcs -ftest-coverage -w -g -O0 -fno-omit-frame-pointer -DHAVE_EX_DATA -DWOLFSSL_CALLBACKS -g -fPIC" LDFLAGS="-fprofile-arcs -ftest-coverage" ./configure "--disable-shared" "--enable-static" "--enable-debug" "--enable-opensslall" "--enable-opensslextra" "--enable-context-extra-user-data" "--enable-keygen" "--enable-certgen" "--enable-tls13" "--enable-dtls" "--enable-sp" "--enable-dtls-mtu" "--disable-sha3" "--enable-curve25519" "--enable-secure-renegotiation" "--enable-psk" "--enable-intelasm" "--enable-sp-asm" "--enable-aesni" "--enable-postauth" && \
    make $MAKE_OPT

ENV PATH="${PATH}:${WORKDIR}"

COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
