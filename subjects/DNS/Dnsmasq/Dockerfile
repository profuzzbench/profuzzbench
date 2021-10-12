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
RUN apt-get -y install dnsutils

COPY --chown=ubuntu:ubuntu dnsmasq.patch ${WORKDIR}/dnsmasq.patch

# Download and compile Dnsmasq for fuzzing
RUN cd $WORKDIR && \
    git clone git://thekelleys.org.uk/dnsmasq.git && \
    cd dnsmasq && \
    git checkout v2.73rc6 && \
    patch -p1 < ${WORKDIR}/dnsmasq.patch && \
    CC=afl-clang-fast make $MAKE_OPT

# Download and compile Dnsmasq for coverage analysis
RUN cd $WORKDIR && \
    git clone git://thekelleys.org.uk/dnsmasq.git dnsmasq-gcov && \
    cd dnsmasq-gcov && \
    git checkout v2.73rc6 && \
    patch -p1 < ${WORKDIR}/dnsmasq.patch && \
    make CFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" $MAKE_OPT


COPY --chown=ubuntu:ubuntu in-dns ${WORKDIR}/in-dns
COPY --chown=ubuntu:ubuntu dns.dict ${WORKDIR}/dns.dict
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu dnsmasq.conf ${WORKDIR}/dnsmasq.conf

RUN cp ${WORKDIR}/dnsmasq.conf /etc/ && \
    echo address=/test.com/5.5.5.5 | sudo tee -a /etc/dnsmasq.conf


