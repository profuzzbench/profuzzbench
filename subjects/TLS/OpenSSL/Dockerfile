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
    wget

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

RUN chmod 777 /tmp

RUN pip3 install gcovr==6.0

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

# Set up environment variables for AFLNet
ENV WORKDIR="/home/ubuntu/experiments"

ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1

RUN mkdir $WORKDIR

COPY --chown=ubuntu:ubuntu key.pem ${WORKDIR}/key.pem
COPY --chown=ubuntu:ubuntu cert.pem ${WORKDIR}/cert.pem
COPY --chown=ubuntu:ubuntu rand.patch ${WORKDIR}/rand.patch

# Set up environment variables for ASAN
env ASAN_OPTIONS='abort_on_error=1:symbolize=0:detect_leaks=0:detect_stack_use_after_return=1:detect_container_overflow=0:poison_array_cookie=0:malloc_fill_byte=0:max_malloc_fill_size=16777216'

# Download and compile OpenSSL for coverage analysis
RUN cd ${WORKDIR} && \
    git clone --depth 1 --single-branch --branch OpenSSL_1_1_1j https://github.com/openssl/openssl.git openssl-gcov && \
    cd openssl-gcov && \
    cp ${WORKDIR}/*.pem ./ && \
    patch -p1 < ${WORKDIR}/rand.patch && \
    CC="clang" CFLAGS="-fprofile-arcs -ftest-coverage -O0" LDFLAGS="-fprofile-arcs -ftest-coverage" ./config no-shared --with-rand-seed=none && \
    CC="clang" CFLAGS="-fprofile-arcs -ftest-coverage -O0" LDFLAGS="-fprofile-arcs -ftest-coverage" make $MAKE_OPT

ENV PATH="${PATH}:${WORKDIR}"

COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
