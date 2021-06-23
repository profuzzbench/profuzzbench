#!/bin/bash

export NUM_CONTAINERS=4
export TIMEOUT=3600
export SKIPCOUNT=5

export TARGET=$1
export FUZZER=$2

if [[ "x$TARGET" == "x" ]] || [[ "x$FUZZER" == "x" ]]
then
    echo "Usage: $0 TARGET FUZZER"
    exit 1
fi



##### FTP #####

if [[ $TARGET == "lightftp" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-lightftp

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh lightftp $NUM_CONTAINERS results-lightftp aflnet out-lightftp-aflnet "-P FTP -D 10000 -q 3 -s 3 -E -K -c ./ftpclean.sh -m none" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh lightftp $NUM_CONTAINERS results-lightftp aflnwe out-lightftp-aflnwe "-D 10000 -K -c ./ftpclean.sh" $TIMEOUT $SKIPCOUNT
    fi

fi


if [[ $TARGET == "bftpd" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-bftpd

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh bftpd $NUM_CONTAINERS results-bftpd aflnet out-bftpd-aflnet "-t 1000+ -m none -P FTP -D 10000 -q 3 -s 3 -E -K -c clean" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh bftpd $NUM_CONTAINERS results-bftpd aflnwe out-bftpd-aflnwe "-t 1000+ -m none -D 10000 -K -c clean" $TIMEOUT $SKIPCOUNT
    fi

fi


if [[ $TARGET == "proftpd" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-proftpd

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh proftpd $NUM_CONTAINERS results-proftpd aflnet out-proftpd-aflnet "-t 1000+ -m none -P FTP -D 10000 -q 3 -s 3 -E -K -c clean" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh proftpd $NUM_CONTAINERS results-proftpd aflnwe out-proftpd-aflnwe "-t 1000+ -m none -D 10000 -K -c clean" $TIMEOUT $SKIPCOUNT
    fi

fi

if [[ $TARGET == "pure-ftpd" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-pure-ftpd

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh pure-ftpd $NUM_CONTAINERS results-pure-ftpd aflnet out-pure-ftpd-aflnet "-t 1000+ -m none -P FTP -D 10000 -q 3 -s 3 -E -K -c clean" $TIMEOUT $SKIPCOUNT
        fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh pure-ftpd $NUM_CONTAINERS results-pure-ftpd aflnwe out-pure-ftpd-aflnwe "-t 1000+ -m none -D 10000 -K -c clean" $TIMEOUT $SKIPCOUNT
        fi

fi


##### SMTP #####

if [[ $TARGET == "exim" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-exim

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh exim $NUM_CONTAINERS results-exim aflnet out-exim-aflnet "-P SMTP -D 10000 -q 3 -s 3 -E -K -W 100" $TIMEOUT $SKIPCOUNT
        fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh exim $NUM_CONTAINERS results-exim aflnwe out-exim-aflnwe "-D 10000 -K -W 100" $TIMEOUT $SKIPCOUNT
        fi

fi



##### DNS #####

if [[ $TARGET == "dnsmasq" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-dnsmasq

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh dnsmasq $NUM_CONTAINERS results-dnsmasq aflnet out-dnsmasq-aflnet "-P DNS -D 10000 -K -R -q 3 -s 3 -E" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh dnsmasq $NUM_CONTAINERS results-dnsmasq aflnwe out-dnsmasq-aflnwe "-D 10000 -K" $TIMEOUT $SKIPCOUNT
    fi

fi


##### RTSP #####

if [[ $TARGET == "live555" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-live555

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh live555 $NUM_CONTAINERS results-live555 aflnet out-live555-aflnet "-P RTSP -D 10000 -q 3 -s 3 -E -K -R" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh live555 $NUM_CONTAINERS results-live555 aflnwe out-live555-aflnwe "-D 10000 -K" $TIMEOUT $SKIPCOUNT
    fi

fi


##### SIP #####

if [[ $TARGET == "kamailio" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-kamailio

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh kamailio $NUM_CONTAINERS results-kamailio aflnet out-kamailio-aflnet "-m none -t 3000+ -P SIP -l 5061 -D 50000 -q 3 -s 3 -E -K -c run_pjsip" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh kamailio $NUM_CONTAINERS results-kamailio aflnwe out-kamailio-aflnwe "-m none -t 3000+ -D 50000 -K -c run_pjsip" $TIMEOUT $SKIPCOUNT
    fi

fi


##### SSH #####

if [[ $TARGET == "openssh" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-openssh

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh openssh $NUM_CONTAINERS results-openssh aflnet out-openssh-aflnet "-P SSH -D 10000 -q 3 -s 3 -E -K -W 10" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
        then
        profuzzbench_exec_common.sh openssh $NUM_CONTAINERS results-openssh aflnwe out-openssh-aflnwe "-D 10000 -K -W 10" $TIMEOUT $SKIPCOUNT
    fi

fi


##### TLS #####

if [[ $TARGET == "openssl" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-openssl

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh openssl $NUM_CONTAINERS results-openssl aflnet out-openssl-aflnet "-P TLS -D 10000 -q 3 -s 3 -E -K -R -W 100 -m none" $TIMEOUT $SKIPCOUNT &
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh openssl $NUM_CONTAINERS results-openssl aflnwe out-openssl-aflnwe "-D 10000 -K -W 100" $TIMEOUT $SKIPCOUNT
    fi

fi


##### DTLS #####

if [[ $TARGET == "tinydtls" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-tinydtls

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh tinydtls $NUM_CONTAINERS results-tinydtls aflnet out-tinydtls-aflnet "-P DTLS12 -D 10000 -q 3 -s 3 -E -K -W 30" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh tinydtls $NUM_CONTAINERS results-tinydtls aflnwe out-tinydtls-aflnwe "-D 10000 -K -W 30" $TIMEOUT $SKIPCOUNT
    fi

fi

##### DICOM #####

if [[ $TARGET == "dcmtk" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-dcmtk

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh dcmtk $NUM_CONTAINERS results-dcmtk aflnet out-dcmtk-aflnet "-P DICOM -D 10000 -E -K" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh dcmtk $NUM_CONTAINERS results-dcmtk aflnwe out-dcmtk-aflnwe "-D 10000 -K" $TIMEOUT $SKIPCOUNT
    fi

fi


##### DAAPD #####

if [[ $TARGET == "forked-daapd" ]] || [[ $TARGET == "all" ]]
then

    cd $PFBENCH
    mkdir results-forked-daapd

    if [[ $FUZZER == "aflnet" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh forked-daapd $NUM_CONTAINERS results-forked-daapd aflnet out-forked-daapd-aflnet "-P HTTP -D 200000 -m none -t 10000+ -q 3 -s 3 -E -K" $TIMEOUT $SKIPCOUNT
    fi

    if [[ $FUZZER == "aflnwe" ]] || [[ $FUZZER == "all" ]]
    then
        profuzzbench_exec_common.sh forked-daapd $NUM_CONTAINERS results-forked-daapd aflnwe out-forked-daapd-aflnwe "-D 200000 -m none -t 10000+ -K" $TIMEOUT $SKIPCOUNT
    fi

fi



