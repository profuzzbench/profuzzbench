#!/bin/bash

folder=$1   #fuzzer result folder
pno=$2      #port number
step=$3     #step to skip running gcovr and outputting data to covfile
            #e.g., step=5 means we run gcovr after every 5 test cases
covfile=$4  #path to coverage file
fmode=$5    #file mode -- structured or not
            #fmode = 0: the test case is a concatenated message sequence -- there is no message boundary
            #fmode = 1: the test case is a structured file keeping several request messages

#delete the existing coverage file
rm $covfile; touch $covfile

#clear gcov data
gcovr --gcov-executable "llvm-cov gcov" -r . -s -d > /dev/null 2>&1

#output the header of the coverage file which is in the CSV format
echo "time,b_abs,b_per,b_total,fn_abs,fn_per,fn_total,l_abs,l_per,l_total" >> $covfile

#files stored in replayable-* folders are structured
#in such a way that messages are separated
if [ $fmode -eq "1" ]; then
  testdir="replayable-queue"
  replayer="aflnet-replay"
else
  testdir="queue"
  replayer="afl-replay"
fi

#process seeds first
for f in $(echo $folder/$testdir/*.raw); do 
  time=$(stat -c %Y $f)
    
  $replayer $f TLS $pno 100 > /dev/null 2>&1 &
  timeout 10s ./examples/server/server -v d -p 4433 -x -d -7 3 > /dev/null 2>&1
  
  wait

  echo "Getting coverage"
  cov_data=$(gcovr --gcov-executable "llvm-cov gcov" -r . -e ".*openssl.*" -e ".*examples.*" -e ".*test.*" --json-summary-pretty)
  echo "$cov_data" | jq "[$time,.branch_covered,.branch_percent,.branch_total,.function_covered,.function_percent,.function_total,.line_covered,.line_percent,.line_total] | @csv" -r >> $covfile

done

#process other testcases
count=0
for f in $(echo $folder/$testdir/id*); do 
  time=$(stat -c %Y $f)
  
  $replayer $f TLS $pno 100 > /dev/null 2>&1 &
  timeout 10s ./examples/server/server -v d -p 4433 -x -d -7 3 > /dev/null 2>&1

  wait
  count=$(expr $count + 1)
  rem=$(expr $count % $step)
  if [ "$rem" != "0" ]; then continue; fi
  echo "Getting coverage"
  cov_data=$(gcovr --gcov-executable "llvm-cov gcov" -r . -e ".*openssl.*" -e ".*examples.*" -e ".*test.*" --json-summary-pretty)
  echo "$cov_data" | jq "[$time,.branch_covered,.branch_percent,.branch_total,.function_covered,.function_percent,.function_total,.line_covered,.line_percent,.line_total] | @csv" -r >> $covfile
done

#ouput cov data for the last testcase(s) if step > 1
if [[ $step -gt 1 ]]
then
  time=$(stat -c %Y $f)
  echo "Getting coverage"
  cov_data=$(gcovr --gcov-executable "llvm-cov gcov" -r . -e ".*openssl.*" -e ".*examples.*" -e ".*test.*" --json-summary-pretty)
  echo "$cov_data" | jq "[$time,.branch_covered,.branch_percent,.branch_total,.function_covered,.function_percent,.function_total,.line_covered,.line_percent,.line_total] | @csv" -r >> $covfile
fi
