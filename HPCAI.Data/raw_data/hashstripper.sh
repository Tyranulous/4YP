#!/bin/bash
for d in ./*/; do
  cd "$d"
  pwd
  #sed '/^#/d' time.log > ./timenohash.txt
  for file in *.dat ; do
    #echo test
    #echo "$file"
    grep "Real-time speedup factor:" "$file" | tail -1 | tee -a ./speedup.txt
    grep "Number of samples processed:" "$file" | tail -1 | tee -a ./num_samples.txt
  done
  cd ../
done
