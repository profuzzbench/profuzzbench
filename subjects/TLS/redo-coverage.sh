#!/bin/bash


redo_coverage () {
    for ID in {1..10}
    do
        INPUT_RESULTS=$1
        OUTPUT_RESULTS=redone-$1-$ID

        IMAGE=$2
        FUZZER=$3
        OUTDIR=$4
        TARGET_DIR=$5 # based on fuzzer

        echo "Redoing coverage for $IMAGE:$ID"

        container=$(docker build $INPUT_RESULTS -q -f Dockerfile-coverage --build-arg IMAGE=$IMAGE --build-arg TARGET_DIR=$TARGET_DIR --build-arg INPUT=${OUTDIR}_$ID/$OUTDIR --build-arg OUTDIR=$OUTDIR)
        echo $container
        profuzzbench_exec_common.sh $container 1 $OUTPUT_RESULTS $FUZZER $OUTDIR "" 0 5 1 &
    done
}

mkdir redone-evaluation

redo_coverage evaluation/results-openssl openssl-aflnet aflnet out-openssl openssl &
redo_coverage evaluation/results-openssl-aflnwe openssl-aflnwe aflnwe out-openssl-aflnwe openssl-aflnwe &
redo_coverage evaluation/results-openssl-stateafl openssl-stateafl stateafl out-openssl-stateafl openssl-stateafl &
redo_coverage evaluation/results-openssl-stateafl-null openssl-stateafl stateafl out-openssl-stateafl-null openssl-stateafl &

redo_coverage evaluation/results-wolfssl wolfssl-aflnet aflnet out-wolfssl wolfssl &
redo_coverage evaluation/results-wolfssl-aflnwe wolfssl-aflnwe aflnwe out-wolfssl-aflnwe wolfssl-aflnwe &
redo_coverage evaluation/results-wolfssl-stateafl wolfssl-stateafl stateafl out-wolfssl-stateafl wolfssl-stateafl &

wait
