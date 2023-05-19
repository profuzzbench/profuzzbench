# ProFuzzBench fork

* seed-creation - Contains the raw WireShark recordings. Contains tools to covert to the required formats. Also contains scripts for verifying seeds.
* asan/ - Results for a 24h ASAN run
* evaluation/ - Results for the fuzzing runs
* redone-evaluation-redo - Same as evaluation/ but was updated using ./redo-coverage.sh


## Build

```
export MAKE_OPT="-j32"
cd OpenSSL
docker build . -t openssl-profuzzbench --build-arg MAKE_OPT
docker build . -f Dockerfile-stateafl -t openssl-stateafl-profuzzbench --build-arg MAKE_OPT
docker build . -f Dockerfile-aflnet -t openssl-aflnet-profuzzbench --build-arg MAKE_OPT
docker build . -f Dockerfile-aflnwe -t openssl-aflnwe-profuzzbench --build-arg MAKE_OPT
docker build . -f Dockerfile-stateafl-null -t openssl-stateafl-null-profuzzbench --build-arg MAKE_OPT

cd ..
cd wolfSSL
docker build . -t wolfssl-profuzzbench --build-arg MAKE_OPT
docker build . -f Dockerfile-stateafl -t wolfssl-stateafl-profuzzbench --build-arg MAKE_OPT
docker build . -f Dockerfile-aflnet -t wolfssl-aflnet-profuzzbench --build-arg MAKE_OPT
docker build . -f Dockerfile-aflnwe -t wolfssl-aflnwe-profuzzbench --build-arg MAKE_OPT
cd ..
```

## Evaluation

Make sure to add the execution scripts to your path:

```
export PATH="$PATH:/local-unsafe/mammann/profuzzbench/scripts/execution"
```

```bash
export TIME=86400
export INSTANCES=10

## wolfSSL

# StateAFL
profuzzbench_exec_common.sh wolfssl-stateafl-profuzzbench $INSTANCES results-wolfssl-stateafl stateafl out-wolfssl-stateafl "-P TLS -D 10000 -q 3 -s 3 -E -m none -t 1000" $TIME 5 &
# ALFNet
profuzzbench_exec_common.sh wolfssl-aflnet-profuzzbench $INSTANCES results-wolfssl aflnet out-wolfssl "-P TLS -D 10000 -q 3 -s 3 -E -R -W 100 -m none -K" $TIME 5 &
# AFLnwe
profuzzbench_exec_common.sh wolfssl-aflnwe-profuzzbench $INSTANCES results-wolfssl-aflnwe aflnwe out-wolfssl-aflnwe "-D 10000 -W 100 -K -m none" $TIME 5 &

## OpenSSL

# StateAFL
profuzzbench_exec_common.sh openssl-stateafl-profuzzbench $INSTANCES results-openssl-stateafl stateafl out-openssl-stateafl "-P TLS -D 10000 -q 3 -s 3 -E -m none -t 1000" $TIME 5 &
# StateAFL (null cipher)
profuzzbench_exec_common.sh openssl-stateafl-null-profuzzbench $INSTANCES results-openssl-stateafl-null stateafl out-openssl-stateafl-null "-P TLS -D 10000 -q 3 -s 3 -E -m none -t 1000" $TIME 5 &
# AFLNet
profuzzbench_exec_common.sh openssl-aflnet-profuzzbench $INSTANCES results-openssl aflnet out-openssl "-P TLS -D 10000 -q 3 -s 3 -E -R -W 100 -m none -K" $TIME 5 &
# AFLnwe
profuzzbench_exec_common.sh openssl-aflnwe-profuzzbench $INSTANCES results-openssl-aflnwe aflnwe out-openssl-aflnwe "-D 10000 -W 100 -K -m none" $TIME 5 &
```

Checkout a container:

```
docker run -ti  --entrypoint=/bin/bash openssl-profuzzbench
```

## Caveats

* DO NOT USE -K WITH STATEAFL! The StateAFL instrumentation can not handle SIGTERMs!
* OOM because missing -m none:
```
[-] Whoops, the target binary crashed suddenly, before receiving any input
    from the fuzzer! Since it seems to be built with ASAN and you have a
    restrictive memory limit configured, this is expected; please read
    docs/notes_for_asan.txt for help.

[-] PROGRAM ABORT : Fork server crashed with signal 6
         Location : init_forkserver(), afl-fuzz.c:3064

#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007ffff7c55859 in __GI_abort () at abort.c:79
#2  0x00000000004b33c7 in __sanitizer::Abort() ()
#3  0x000000000049dcc4 in __asan::ReserveShadowMemoryRange(unsigned long, unsigned long, char const*) ()
#4  0x000000000049dd74 in __asan::InitializeShadowMemory() ()
#5  0x000000000049d4b7 in __asan::AsanInitInternal() ()
#6  0x00007ffff7fe0cf6 in _dl_init (main_map=0x7ffff7ffe190, argc=10, argv=0x7fffffffe3c8, env=0x7fffffffe420) at dl-init.c:104
#7  0x00007ffff7fd013a in _dl_start_user () from /lib64/ld-linux-x86-64.so.2
```

# Generating seeds

First see seed-creation.

### Convert to aflnet-replay

```
nix-shell -p python310Packages.pyshark
python3 convert-pcap-replay-format.py --input ~/wolfssl_2_wireshark.pcap --server-port 44333 --output in-tls-replay/wolfssl13_2.stateafl.raw
aflnet-replay in-tls-replay/wolfssl13_2.stateafl.raw TLS 44333
```

### Convert to afl-replay

https://github.com/aflnet/aflnet#step-1-prepare-message-sequences-as-seed-inputs