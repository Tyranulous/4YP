#!/bin/bash

#print date time
echo "start time"
date +"%D %T"
make clean

filename='input_data.txt'
nn=1
linesperrun=10
linestart=0
#while IFS=, read -r cf bw d tsamp chans; do
for x in {0..149}; do
#cf=1200
#bw=250
#tsamp=80
#d=2400

#josch
#for cf in 300 800 1400; do
# central freq - mhz
#    for bw in 50 200 400; do
# bandwidth - mhz
#        for tsamp in 64 256 1024; do
# time sampling - microseconds
#            for chans in 1024 4096; do
# numbe of chans
#for cf in 2000 14000 800 300
#	if cf ==
#chans=4096
#chans


                #echo "cf: $cf  bw: $bw  tsamp: $tsamp  chans: $chans  d:$d"
                
                # code to run astro accelerate with these params goes here
				cd ~/HPC-AI-4YP/branch/astro-accelerate/build/
                # 1. generate ddplan probably by executing ddplan.py with params -n -b -t -f -w as the corresponding values
		touch inputs.dat
		echo "cf bw tsamp chans" >> inputs.dat
		for xx in {0..9}; do
			xm=$((xx+1))
			#cf bw d tsamp chans
			xmn=$((xx+1+(x*10)))
			toarray=$(sed -n "$xmn p" $filename)
            IFS=, read -r -a content <<< "$toarray"
			python3 	./DDplan_rand_edit.py -n "${content[4]}" -b "${content[1]}" -t "${content[3]}" -f "${content[0]}" -d "${content[2]}" -w "$xx"
			echo "${content[0]},${content[1]},${content[3]},${content[4]}" >> ./inputs.dat
			#echo $content
		done       
	            	# 3. import ddplan into astro accelerate somehow - handled
		            # 5. run jan's script to check possible combinations of hpc params
		             # ./profiling-autotune.sh chans-profile.txt
#
cd ../build

regcount=0
rm time.log
rm -rf profile_results
rm ./make_logs/*
mkdir profile_results
 
while IFS='' read -r line || [[ -n "$line" ]]; do
	
        echo "Text read from file: $line"
        export $line
 	#for unroll in	4 8 16 32; do

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
					# echo "#define JTSAMP $tsamp" >> ./params.txt
					# echo "#define JCHANS $chans" >> ./params.txt
					# echo "#define JBW $bw" >> ./params.txt
					# echo "#define JCF $cf" >> ./params.txt
					#
					echo "#define J_INPUTS_PER_RUN $linesperrun" >> ./params.txt
					echo "#define J_INPUT_LINE_START $linestart" >> ./params.txt

					echo "} // namespace astroaccelerate" >> ./params.txt
					echo "#endif" >> ./params.txt
					mv params.txt ../include/aa_params.hpp
	
					make clean
									
					make -j -l 8  &> make_logs/u"$unroll"_a"$acc"_t"$divint"_dm"$divindm"_r"$regcount".makelog
 #					make -j -l 6
 #echo "--------"
 #echo "cpu temp check 1:"
 #                                        cat /sys/class/hwmon/hwmon1/*_input
 #               echo "-------"             

					cp ../include/aa_params.hpp profile_results/u"$unroll"_a"$acc"_t"$divint"_dm"$divindm"_r"$regcount".h

					./examples/examples_autotune &> profile_results/u"$unroll"_a"$acc"_t"$divint"_dm"$divindm"_r"$regcount".dat

 #echo "cpu temp check2:"			
 #cat /sys/class/hwmon/hwmon1/*_input
 #nvidia-smi -q -d temperature


	echo "unrolls: $unroll	acc: $acc    divint: $divint    divindm: $divindm    reg: $regcount"
 #done #unrolls
	
done < "$1"

#optimum=$(grep "Real" profile_results/* | awk -F" " '{print $4" "$1}' | sort -n | tail -1 | awk -F" " '{print $2}' | awk -F"." '{print $1".h"}')

#cp $optimum ../include/aa_params.hpp
#pwd
#cd ../build
#make clean
#make -j
#cd ../scripts/

echo "FINISHED OPTIMISATION"

#josch
# 6. save data somewhere usefull with unique names for each run
                # change directory to data storage
                cd ~/HPC-AI-4YP/branch/4YP/HPCAI.Data/raw_data_2080ti_constant_multiplier_1500ts || exit
                #create new folder to store data in
            #    [ ! -d ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" ] && mkdir cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || mkdir cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
            #     cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
            #      cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans" || cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"$cf"__bw-"$bw"__tsamp-"$tsamp"__chans-"$chans"_copy
			   
[ ! -d ./cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}" ] && mkdir cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}" || mkdir cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}"_copy
                cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}" || cp -a ~/HPC-AI-4YP/branch/astro-accelerate/build/profile_results/. ./cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}"_copy
                 cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}" || cp ~/HPC-AI-4YP/branch/astro-accelerate/build/time.log ./cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}"_copy

			   #copy ddplan files (and inputs file)
			   cp ~/HPC-AI-4YP/branch/astro-accelerate/build/*.dat ./cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}" || cp ~/HPC-AI-4YP/branch/astro-accelerate/build/*.dat ./cf-"${content[0]}"__bw-"${content[1]}"__tsamp-"${content[3]}"__chans-"${content[4]}"_copy
          
cd ~/HPC-AI-4YP/branch/astro-accelerate/build/ || exit
rm time.log
rm ./profile_results/*
rm ./make_logs/*
rm *.dat
echo "end time:"
date +"%D %T"

linestart=$((linestart+linesperrun))

done

#done < $filename

#  done
#        done
#    done
#done
#cp ~HPC-AI-4YP/branch/astro-accelerate/build/time.log ~/HPC-AI-4YP/branch/4YP/HPCAI.Data/raw_data/

#print end date time
echo "end time"
date +"%D %T"
