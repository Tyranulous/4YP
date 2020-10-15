#!/bin/bash


#josch
for cf in 300 800 1400; do
# central freq - mhz
    for bw in 50 200 400; do
# bandwidth - mhz
        for tsamp in 64 256 1024; do
# time sampling - microseconds
            for chans in 1024 4096; do
# number of chans
                echo "cf:$cf  bw:'$bw  tsamp:$tsamp  chans:$chans"
                
                # code to run astro accelerate with these params goes here
				cd ~/HPC-AI-4YP/branch/astro-accelerate/build/
                # 1. generate ddplan probably by executing ddplan.py with params -n -b -t -f -w as the corresponding values
				./DDplan.py -n "$chans" -b "$bw" -t "$tsamp" -f "$cf" -w
		            
	            	# 3. import ddplan into astro accelerate somehow - handled
		            # 5. run jan's script to check possible combinations of hpc params
		             # ./profiling-autotune.sh chans-profile.txt
#

regcount=0

rm -rf profile_results

mkdir profile_results

while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "Text read from file: $line"
        export $line
					#cd ../build/
					pwd
					rm ../include/aa_params.hpp
					cat ../lib/header > ./params.txt
					echo "#define UNROLLS $unroll" >> ./params.txt
					echo "#define SNUMREG $acc" >> ./params.txt
					echo "#define SDIVINT $divint" >> ./params.txt
					echo "#define SDIVINDM $divindm" >> ./params.txt
					echo "#define SFDIVINDM $divindm.0f" >> ./params.txt
					
					#josch# 2.import telescope params into c file somehow 
					echo "#define JTSAMP $tsamp" >> ./params.txt
					echo "#define JCHANS $chans" >> ./params.txt
					echo "#define JBW $bw" >> ./params.txt
					echo "#define JCF $cf" >> ./params.txt
					#

					echo "} // namespace astroaccelerate" >> ./params.txt
					echo "#endif" >> ./params.txt
					mv params.txt ../include/aa_params.hpp
	
#					make clean
									
					make -j

					cp ../include/aa_params.hpp profile_results/u"$unroll"_a"$acc"_t"$divint"_dm"$divindm"_r"$regcount".h

					./examples/examples_autotune &> profile_results/u"$unroll"_a"$acc"_t"$divint"_dm"$divindm"_r"$regcount".dat
			
echo "unrolls: $unroll	acc: $acc    divint: $divint    divindm: $divindm    reg: $regcount"
done < "$1"

#optimum=$(grep "Real" profile_results/* | awk -F" " '{print $4" "$1}' | sort -n | tail -1 | awk -F" " '{print $2}' | awk -F"." '{print $1".h"}')

#cp $optimum ../include/aa_params.hpp
#pwd
#cd ../build
#make clean
#make -j
#cd ../scripts/

echo "FINISED OPTIMISATION"

#josch
# 6. save data somewhere usefull with unique names for each run
                # change directory to data storage
                cd ~/HPC-AI-4YP/branch/4YP/HPCAI.Data/raw_data || exit
                #create new folder to store data in
               [ ! -d ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" ] && mkdir cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || mkdir cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
                cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
                # cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
               
            done
        done
    done
done
cp ~HPC-AI-4YP/branch/astro-accelerate/build/time.log ~/HPC-AI-4YP/branch/4YP/HPCAI.Data/raw_data/