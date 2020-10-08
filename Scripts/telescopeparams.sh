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
            done
        done
    done
done



