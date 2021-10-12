#!/bin/bash

DOCKERFILES=$(find $PFBENCH -name Dockerfile)
FILTER=$1

if [ ! -z "$FILTER" ]
then
        DOCKERFILES=$(echo "${DOCKERFILES[@]}" | grep -E -i $FILTER)
fi


echo "${DOCKERFILES[@]}" | while read DOCKERFILE
do
    perl -p -i -e 'if(/stateafl.git/) { print "RUN touch \$WORKDIR/.random-'$RANDOM'\n"; }' $DOCKERFILE
done


profuzzbench_build_all.sh


echo "${DOCKERFILES[@]}" | while read DOCKERFILE
do
    perl -n -i -e 'print unless /\.random/' $DOCKERFILE
done

