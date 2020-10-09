#!/bin/bash

for cf in 300 800 1400; do
# central freq - mhz
    for bw in 50 200 400; do
# bandwidth - mhz
        for tsamp in 64 256 1024; do
# time sampling - microseconds
            for chans in 2024 4096; do
# number of chans
                echo "cf:$cf  bw:'$bw  tsamp:$tsamp  chans:$chans"
                # code to run astro accelerate with these params goes here
                # 1. generate ddplan probably by executing ddplan.py with params -n -b -t -f as the corresponding values
		# 2.import telescope params into c file somehow
		# 3. import ddplan into astro accelerate somehow
		# 4. profit
		# 5. run jan's script to check possible combinations of hpc params
		# 6. save data somewhere usefull with unique names for each run
            done
        done
    done
done



