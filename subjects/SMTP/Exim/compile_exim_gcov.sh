#!/bin/bash

#Compile and install exim to collect code coverage
cd ${WORKDIR}
git clone https://github.com/Exim/exim exim-gcov
cd exim-gcov
git checkout 38903fb
cd src; mkdir Local; cp src/EDITME Local/Makefile
cd Local; patch -p1 < ${WORKDIR}/exim.patch; cd ..
make CFLAGS="-fprofile-arcs -ftest-coverage" LDFLAGS="-fprofile-arcs -ftest-coverage" LFLAGS+="-lgcov --coverage" clean all install

# Configure exim
#cd /usr/exim
#patch -p1 < ${WORKDIR}/exim.configure.patch
#chmod 1777 /var/mail
