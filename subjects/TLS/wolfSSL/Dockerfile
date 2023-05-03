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

# Use ubuntu as default username
USER ubuntu
WORKDIR /home/ubuntu

# Import environment variable to pass as parameter to make (e.g., to make parallel builds with -j)
ARG MAKE_OPT

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

#COPY --chown=ubuntu:ubuntu rand.patch ${WORKDIR}/rand.patch

# Set up environment variables for ASAN
env ASAN_OPTIONS='abort_on_error=1:symbolize=0:detect_leaks=0:detect_stack_use_after_return=1:detect_container_overflow=0:poison_array_cookie=0:malloc_fill_byte=0:max_malloc_fill_size=16777216'

# Download and compile wolfSSL for fuzzing
RUN cd ${WORKDIR} && \
    git clone https://github.com/wolfSSL/wolfssl wolfssl
RUN cd ${WORKDIR}/wolfssl && \
    git checkout v5.3.0-stable && \
#    patch -p1 < ${WORKDIR}/rand.patch && \
    autoreconf --install && \
    CFLAGS="-DWOLFSSL_GENSEED_FORTEST -DWC_RNG_SEED_CB -Wno-error=warnings" AFL_USE_ASAN=1 CC=afl-clang-fast ./configure --disable-shared --enable-static --enable-tls13 --enable-session-ticket --enable-sp && \
    make $MAKE_OPT



# Download and compile wolfSSL for coverage analysis
RUN cd ${WORKDIR} && \
    git clone https://github.com/wolfSSL/wolfssl wolfssl-gcov
RUN cd ${WORKDIR}/wolfssl-gcov && \
    git checkout v5.3.0-stable && \
#    patch -p1 < ${WORKDIR}/rand.patch && \
    autoreconf --install && \
    CFLAGS="-DWOLFSSL_GENSEED_FORTEST -DWC_RNG_SEED_CB -fprofile-arcs -ftest-coverage -w -g" LDFLAGS="-fprofile-arcs -ftest-coverage" ./configure --disable-shared --enable-static --enable-tls13 --enable-session-ticket --enable-sp && \
    make $MAKE_OPT

COPY --chown=ubuntu:ubuntu in-tls ${WORKDIR}/in-tls
COPY --chown=ubuntu:ubuntu tls.dict ${WORKDIR}/tls.dict
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
