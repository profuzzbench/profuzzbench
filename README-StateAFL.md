# StateAFL: A Coverage-Driven (Greybox) Fuzzer for Stateful Network Protocols

StateAFL is a fuzzer designed for network servers. It extends the original idea of the AFL fuzzer, which automatically evolves fuzz inputs to maximize code coverage. In addition to code coverage, StateAFL seeks to maximize protocol state coverage. StateAFL automatically infers the current protocol state of the server, by taking snapshots of long-lived data within process memory, and by applying fuzzy hashing to map the in-memory state to a unique protocol state.

For more information about StateAFL, please check the repository at <https://github.com/stateafl/stateafl>

# Running StateAFL with ProFuzzBench

ProFuzzBench comes with Dockerfiles and scripts to run StateAFL with the benchmark.
Every target includes a `Dockerfile-stateafl` that builds the StateAFL fuzzer, and a re-builds the target to be run with StateAFL. This Dockerfile builds on top of the default Dockerfile for the target.

To build a target for StateAFL:
```bash
cd $PFBENCH
cd subjects/FTP/LightFTP
docker build . -t lightftp
docker build . -f Dockerfile-stateafl -t lightftp-stateafl
```

To build all targets for all fuzzers, you can run the script [profuzzbench_build_all.sh](scripts/execution/profuzzbench_build_all.sh). To run the fuzzers on all targets, you can use the script [profuzzbench_exec_all.sh](scripts/execution/profuzzbench_exec_all.sh).

You can fuzz an individual target with StateAFL in the same way of other fuzzers. For example:
```bash
cd $PFBENCH
mkdir results-lightftp

profuzzbench_exec_common.sh lightftp-stateafl 4 results-lightftp stateafl out-lightftp-stateafl "-P FTP -D 10000 -q 3 -s 3 -E -K -m none -t 1000" 3600 5
```

Please see the main [README.md](README.md) for more information about how to run and analyze experiments with ProFuzzBench.

