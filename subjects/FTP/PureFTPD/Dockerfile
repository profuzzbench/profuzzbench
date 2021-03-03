FROM ubuntu:16.04

RUN chmod 777 /tmp
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
    ftp \
    automake

# Add a new user ubuntu, pass: ubuntu
RUN groupadd ubuntu && \
    useradd -rm -d /home/ubuntu -s /bin/bash -g ubuntu -G sudo -u 1000 ubuntu -p "$(openssl passwd -1 ubuntu)" && \
    useradd -rm -d /home/fuzzing -s /bin/bash -g ubuntu -G sudo -u 1001 fuzzing -p "$(openssl passwd -1 fuzzing)"

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
ENV PATH="${PATH}:${AFLNET}:/home/ubuntu/.local/bin:${WORKDIR}:${WORKDIR}/pure-ftpd"
ENV AFL_PATH="${AFLNET}"
ENV AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 \
    AFL_SKIP_CPUFREQ=1 \
    AFL_NO_AFFINITY=1

RUN mkdir $WORKDIR && \
    pip install gcovr

COPY --chown=ubuntu:ubuntu fuzzing.patch ${WORKDIR}/fuzzing.patch
COPY --chown=ubuntu:ubuntu gcov.patch ${WORKDIR}/gcov.patch
COPY --chown=ubuntu:ubuntu in-ftp ${WORKDIR}/in-ftp
COPY --chown=ubuntu:ubuntu ftp.dict ${WORKDIR}/ftp.dict
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
COPY --chown=ubuntu:ubuntu clean.sh ${WORKDIR}/clean
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script

# Set up PureFTPD for fuzzing
RUN cd ${WORKDIR} && \
    git clone https://github.com/jedisct1/pure-ftpd.git && \
    cd pure-ftpd && \
    git checkout c21b45f && \
    patch -p1 < ${WORKDIR}/fuzzing.patch && \
    autogen.sh && \
    CC="afl-clang-fast" CXX="afl-clang-fast++" ./configure --without-privsep -without-capabilities && \
    make

# Set up PureFTPD for coverage analysis
RUN cd ${WORKDIR} && \
    git clone https://github.com/jedisct1/pure-ftpd.git pure-ftpd-gcov && \
    cd pure-ftpd-gcov && \
    git checkout c21b45f && \
    patch -p1 < ${WORKDIR}/gcov.patch && \
    autogen.sh && \
    CFLAGS="-fprofile-arcs -ftest-coverage" CPPFLAGS="-fprofile-arcs -ftest-coverage" CXXFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" ./configure --without-privsep -without-capabilities && \
    make

# Switch default user to root
USER root
WORKDIR /home/ubuntu

RUN pip install gcovr
