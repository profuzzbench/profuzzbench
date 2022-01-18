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

COPY --chown=ubuntu:ubuntu fuzzing.patch ${WORKDIR}/fuzzing.patch
COPY --chown=ubuntu:ubuntu gcov.patch ${WORKDIR}/gcov.patch

# Set up environment variables for ASAN
env AFL_USE_ASAN=1
env ASAN_OPTIONS='abort_on_error=1:symbolize=0:detect_leaks=0:detect_stack_use_after_return=1:detect_container_overflow=0:poison_array_cookie=0:malloc_fill_byte=0:max_malloc_fill_size=16777216'

# Download and compile Live555 for fuzzing
RUN cd $WORKDIR && \
    git clone https://github.com/rgaufman/live555.git && \
    cd live555 && \
    git checkout ceeb4f4 && \
    patch -p1 < $WORKDIR/fuzzing.patch && \
    ./genMakefiles linux && \
    make clean all $MAKE_OPT || make all

# Disable ASAN for better performance in coverage analysis
env AFL_USE_ASAN=0


# Set up Live555 for fuzzing
RUN cd ${WORKDIR}/live555/testProgs && \
    cp ${AFLNET}/tutorials/live555/sample_media_sources/*.* ./

# Download and compile Live555 for coverage analysis
RUN cd $WORKDIR && \
    git clone https://github.com/rgaufman/live555.git live555-cov && \
    cd live555-cov && \
    git checkout ceeb4f4 && \
    patch -p1 < $WORKDIR/gcov.patch && \
    ./genMakefiles linux && \
    make CFLAGS="-fprofile-arcs -ftest-coverage" CPPFLAGS="-fprofile-arcs -ftest-coverage" CXXFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" clean all

# Set up Live555 for coverage analysis
RUN cd ${WORKDIR}/live555-cov/testProgs && \
    cp ${AFLNET}/tutorials/live555/sample_media_sources/*.* ./

COPY --chown=ubuntu:ubuntu kill-server.sh ${WORKDIR}/kill-server
COPY --chown=ubuntu:ubuntu in-rtsp ${WORKDIR}/in-rtsp
COPY --chown=ubuntu:ubuntu rtsp.dict ${WORKDIR}/rtsp.dict
COPY --chown=ubuntu:ubuntu cov_script.sh ${WORKDIR}/cov_script
COPY --chown=ubuntu:ubuntu run.sh ${WORKDIR}/run
 
