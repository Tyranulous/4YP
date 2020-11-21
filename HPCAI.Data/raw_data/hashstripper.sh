#!/bin/bash
for d in ./*/; do
  cd "$d"
  pwd
  #sed '/^#/d' time.log > ./timenohash.txt
#  for file in *.dat ; do
    #echo test
    #echo "$file"
#    grep "Real-time speedup factor:" "$file" | tail -1 | tee -a ./speedup.txt
#    grep "Number of samples processed:" "$file" | tail -1 | tee -a ./num_samples.txt
#  done
  

  while IFS='' read -r line || [[ -n "$line" ]]; do
    export $line
    grep "Real-time speedup factor:" u"$unroll"_a"$acc"_t"$divint"_dm"$divindm"_r0.dat | tail -1 | tee -a ./speedup2.txt
    grep "Number of samples processed:" u"$unroll"_a"$acc"_t"$divint"_dm"$divindm"_r0.dat | tail -1 | tee -a ./num_samples2.txt
  done < "$1"
  cd ../
done
