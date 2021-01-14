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
    ftp

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)"

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
ENV PATH="${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}:${WORKDIR}/proftpd"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1

RUN mkdir $WORKDIR && \
    mkdir /home/ubuntu/ftpshare && \
    chown -R ubuntu:ubuntu /home/ubuntu/ftpshare && \
    pip install gcovr

COPY --chown=ubuntu:ubuntu basic.conf ${WORKDIR}/
COPY --chown=ubuntu:ubuntu in-ftp ${WORKDIR}/in-ftp
COPY --chown=ubuntu:ubuntu ftp.dict ${WORKDIR}/ftp.dict
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu clean.sh ${WORKDIR}/clean
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script

# Set up ProFTPD for fuzzing
RUN cd ${WORKDIR} && \
    git clone https://github.com/proftpd/proftpd.git && \
    cd proftpd && \
    git checkout 4017eff8 && \
    CC="afl-clang-fast" CXX="afl-clang-fast++" ./configure --enable-devel=nodaemon:nofork && \
    make

# Set up ProFTPD for coverage analysis
RUN cd ${WORKDIR} && \
    git clone https://github.com/proftpd/proftpd.git proftpd-gcov && \
    cd proftpd-gcov && \
    git checkout 4017eff8 && \
    CFLAGS="-fprofile-arcs -ftest-coverage" CPPFLAGS="-fprofile-arcs -ftest-coverage" CXXFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" ./configure --enable-devel=nodaemon:nofork && \
    make

# Switch default user to root
USER root
WORKDIR /home/ubuntu

RUN pip install gcovr

