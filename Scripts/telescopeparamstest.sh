#!/bin/bash


for cf in 300 800 1400; do
# central freq - mhz
    for bw in 50 200 400; do
# bandwidth - mhz
        for tsamp in 64 256 1024; do
# time sampling - microseconds
            for chans in 2024 4096; do
# number of chans
                echo " ------ Running cf:$cf  bw:'$bw  tsamp:$tsamp  chans:$chans ------"
                #local $t = $tsamp * 0.000001

                # code to run astro accelerate with these params goes here
                # 1. generate ddplan probably by executing ddplan.py with params -n -b -t -f as the corresponding values -w to write to a file
                python3 DDplan.py -f $cf -b $bw -t $tsamp -n $chans -w >> testing.txt 
# local $ddplan

#                for dDM, dsubDM, dmspercall, downsamp, subcall, startDM in zip(dDMs, dsubDMs, dmspercalls, downsamps, subcalls, startDMs):
                    # Loop over the number of calls
#                    for ii in range(subcall):
#                        subDM = startDM + (ii+0.5)*dsubDM
#                        loDM = startDM + ii*dsubDM


		            # 2.import telescope params into c file somehow
	            	# 3. import ddplan into astro accelerate somehow
		            # 4. profit
		            # 5. run jan's script to check possible combinations of hpc params
		             # ./profiling-autotune.sh chans-profile.txt

      # 6. save data somewhere usefull with unique names for each run
                # change directory to data storage
#                cd ~/HPC-AI-4YP/branch/4YP/HPCAI.Data/raw_data || exit
                #create new folder to store data in, if one already exits append the name with -copy to avoid writing over files
#               [ ! -d ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" ] && mkdir cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || mkdir cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
               # copy profile results folder to data
#                cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
               # copy time.log file to data folder
#                cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
               # change back to build directory 
#                cd ~/HPC-AI-4YP/branch/astro-accelerate/build || exit
               
            done
        done
    done
done



