#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>



#include "aa_ddtr_plan.hpp"
#include "aa_ddtr_strategy.hpp"
#include "aa_filterbank_metadata.hpp"
#include "aa_permitted_pipelines_generic.hpp"
#include "aa_pipeline_api.hpp"
#include "aa_device_info.hpp"
#include "aa_params.hpp"
#include "aa_log.hpp"
#include "aa_host_fake_signal_generator.hpp"

#include "aa_sigproc_input.hpp"
#include "aa_timelog.hpp"
#include "aa_dedisperse.hpp"

using namespace astroaccelerate;

int main() {

//plan for processing more telescopes param sets without recompiling thus imporoving time

//Still To Do:
    // figure out a way to generate and read from correct ddplan 
        //probably more hash defines like for the other one, :sigh: nope
        // also random pertebations for the ddplan tings done
    //change all referances to hash defines to be correct for the struct
    // change output log file names to include telescope params somehow to prevent overwriting

//Done:
    // 1. struct to store telescope params, easier to read code :)
    // 2.get line to read from and read from there
        // 2.0 hash define number of lines to do at a time?? -- J_INPUTS_PER_RUN
        // 2.0 and where to start -- J_INPUT_LINE_START
        // 2.1 keep track of where you are within the run
    //store straight into the relevant vectors and surround other code in the reading code

// struct Telescope_Params
// {
//     float central_freq;
//     float bandwidth;
//     float time_sampling;
//     int chans;
//};

float jcentral_freq;
float jbandwidth;
float jtime_sampling;
int jchans;

std::vector<float> central_freq;
std::vector<float> bandwidth;
std::vector<float> time_sampling;
std::vector<int> chans;

// read offset sets which line to start reading from
// int read_offset = J_INPUTS_PER_RUN * J_INPUT_LINE_START ;

// open hard coded input_file location - could #define this maybe
std::ifstream input_file("/home/josch/HPC-AI-4YP/branch/astro-accelerate/build/input_data.txt");
// check input_file read successful
if (!input_file.is_open())
{
    std::cout << "error reading \"input_file\" :( - this is truely excellent error handling" << std::endl;
    return 1;
}
//create string line
std::string line;

//loop through each line in the input_file individually
//while (std::getline(input_file,line))

for (int t = 0; t < J_INPUT_LINE_START ; t++)
{
    std::string throw_away;
    std::getline(input_file, throw_away);
}

for (int tt = 0; tt < J_INPUTS_PER_RUN ; tt++)
{
    //Telescope_Params telescope;
    

    std::getline(input_file, line);
    // check if string is too small to remove square brackets (something has gone wrong if we hit this)

    // send to string stream for processing
    std::stringstream ss(line);
    //temp float val holds value read from string
    float tele_val;
    int tele_tracker = 0;
    while (ss.good())
    {
        
        // string to store number
        std::string substring;
        // split using commas
        std::getline(ss, substring, ',');
        // convert to float and store in temp float val
        tele_val = std::stof(substring);
        // push value into one long vector
        switch (tele_tracker)
        {
        case 0:
            jcentral_freq = tele_val;
            break;
        case 1:
            jbandwidth = tele_val;
            break;
        case 2:
            break;
        case 3:
            jtime_sampling = tele_val;
            break;
        case 4:
            jchans = static_cast<int>(tele_val);
            break;
        default:
            std::cout << "Something went wrong with the tracker, tele_tracker = " << tele_tracker << std::endl;
            return 1; //exelent error handling as always :)
        }
        tele_tracker++;
    }




//super dodgey read from file code 

    std::vector<double> data_in;
    std::vector<std::string> num;
    // open hard coded file location - could #define this maybe
    std::string ddplan_file_name = "/home/josch/HPC-AI-4YP/branch/astro-accelerate/build/";
    ddplan_file_name.append(std::to_string(tt));
    ddplan_file_name.append(".dat");
    //std::ifstream ddplan_file("/home/josch/HPC-AI-4YP/branch/astro-accelerate/build/ddplan.dat");
    std::ifstream ddplan_file(ddplan_file_name);
    // check file read successful
    if (!ddplan_file.is_open())
    {
        std::cout<<"error reading file :( - this is truely excellent error handling"<<std::endl;
        return 1;
    }
    //create string line
    std::string line;
    
    //loop through each line in the file individually
    //while (std::getline(file,line)) 
    
    for (int t = 0; t < 7; t++)
    {
     std::getline(ddplan_file,line);
     // check if string is too small to remove square brackets (something has gone wrong if we hit this)
        if (line.size()<2){
            std::cout<<"string too small"<<std::endl;
            std::cout<<"Something probably went wrong with DDplan.py"<<std::endl;
        }
        else
        {
            // Remove square brackets from string 
            line = line.substr(1,(line.size() -2));
            // send to string stream for processing
            std::stringstream ss(line);
            //temp float val holds value read from string
            float val;
            while (ss.good())
            {
                // string to store number
                std::string substring;
                // split using commas
                std::getline(ss,substring,',');
                // convert to float and store in temp float val
                val = std::stof(substring);
                // push value into one long vector
                data_in.push_back(val);
            }
        }
    }
    //close file
    ddplan_file.close();


        int length = data_in.size();
        int num_cols = (length + 1) / 7;

        std::vector<float> dm_step_vector(data_in.begin(),(data_in.begin() + num_cols)); // = {0.1, 0.2, 0.5, 1.0, 2.0};
        std::vector<float> fch1_vector = { jcentral_freq + ( jbandwidth / 2 )};
//      std::vector<double> tsamp_vector = {6.4e-5, 12.8e-5, 25.6e-5, 51.2e-5, 102.4e-5};
//        std::vector<double> tsamp_vector = {25.6e-5};

        // JTSAMP = time samp in micro seconds hence    \/  defined using #define
        float ten_e_6 = 0.000001;
        std::vector<float> tsamp_vector = { jtime_sampling * ten_e_6 };
//        std::vector<int> nchans_vector = {512, 1024, 2048, 4096, 8192};
//        std::vector<int> ndmtrials_vector = {500, 1000, 1500, 2000, 2500};
//        std::vector<unsigned int> nsamples_vector = {468750}; //for tsamp of 64microseconds covering ~30secs


        unsigned int nsamples_int = ( 20 / ten_e_6 / jtime_sampling ) ;
        std::vector<unsigned int> nsamples_vector = { nsamples_int }; //nsamps for ~20
//      std::vector<unsigned int> nsamples_vector = {78125,156250,468750,9375000};

//      std::vector<float> dm_step_vector = {0.1};
//      std::vector<double> fch1_vector = {1550};
//      std::vector<double> tsamp_vector = {6.4e-5};
        std::vector<int> nchans_vector = { jchans };
        std::vector<int> ndmtrials_vector(num_cols);
        std::vector<int> subcalls((data_in.begin() + 4 * num_cols), (data_in.begin() + 5 * num_cols)); //= {500};
        std::vector<int> num_subcalls((data_in.begin() + 5 * num_cols), (data_in.begin() + 6 * num_cols));
        std::vector<float> low_vector((data_in.begin() + 2 * num_cols), (data_in.begin() + 3 * num_cols));
        std::vector<int> downsampling((data_in.begin() + 3 * num_cols), (data_in.begin() + 4 * num_cols));
        std::vector<float> r_dm_steps((data_in.begin() + 6 * num_cols), (data_in.begin() + 7 * num_cols));
//      std::vector<unsigned int> nsamples_vector = {28125000};
        
//        std::vector<int> split_ndmtrials_vector;

        for (int i = 0; i < num_cols; i++){
                ndmtrials_vector[i]=subcalls[i]*num_subcalls[i];

//                std::cout<<"  subcalls[i]: "<<subcalls[i]<<"  numsubcalls[i]: "<<num_subcalls[i]<<std::endl;
//std::cout<<" low_vector[i]: "<<low_vector[i]<<"  downsampling[i]: "<<downsampling[i]<<"  dm_step_vector[i]:"<<dm_step_vector[i]<<"  ndmtrials_vector[i]: "<<ndmtrials_vector[i]<<std::endl;

        }

/*
        // Keep track of how big the new vector is
        int vector_tracker = 0;
        // Loop over all original 
        for (int i = 0; i < num_cols; i++){

                int num_splits = ndmtrials_vector[i] / JCHANS;
                int ndms = ndmtrials_vector[i];
                        if num_splits > 0 {
                                int 
                                for (int ii = 0; ii <= num_splits; ii++){
                                        if ndms > JCHANS{
                                                split_ndmtrials_vector[vector_tracker+ii] = JCHANS
                                                ndms = ndms - JCHANS
                                        }
                                        else if JCHANS
                                        
                                        vector_tracker++;
                                }

                
                        }

        }

*/
// if(true){
//         std::cout<<"we got here g"<<tt<<std::endl;
        
//         std::cout<<nsamples_int<<std::endl;
//         std::cout<<nsamples_vector[0]<<std::endl;
//         std::cout<<jcentral_freq<<std::endl;
//         std::cout<<fch1_vector[0]<<std::endl;
//         std::cout<<jchans<<std::endl;
//         std::cout<<nchans_vector[0]<<std::endl;
//         std::cout<<jtime_sampling<<std::endl;
//         std::cout<<tsamp_vector[0]<<std::endl;
//         return 1;
// }
        for (unsigned int comp_nsamples : nsamples_vector){
        for (double fch1 : fch1_vector){
        for (int nchans : nchans_vector){
        for (double tsamp : tsamp_vector){
//        for (float dm_step : dm_step_vector){
//        for (int ndmtrials : ndmtrials_vector){

//if reverting change vectors of ndmtrials and 


//sanity check
//std::cout<<"  subcalls[i]: "<<subcalls[i]<<"  numsubcalls[i]: "<<num_subcalls[i]<<std::endl;
//std::cout<<" low_vector[i]: "<<low_vector[i]<<"  downsampling[i]: "<<downsampling[i]<<"  dm_step_vector[i]:"<<dm_step_vector[i]<<"  ndmtrials_vector[i]: "<<ndmtrials_vector[i]<<std::endl;
// std::cout<<"we got here g1"<<std::endl;

        //-----------------------  Init the GPU card
 
        aa_device_info& device_info = aa_device_info::instance();
        if(device_info.check_for_devices()) {
                LOG(log_level::notice, "Checked for devices.");
        }
        else {
                LOG(log_level::error, "Could not find any devices.");
        }

        aa_device_info::CARD_ID selected_card = 0;
        aa_device_info::aa_card_info selected_card_info;
        if(device_info.init_card(selected_card, selected_card_info)) {
                LOG(log_level::notice, "init_card complete. Selected card " + std::to_string(selected_card) + ".");
        }
        else {
                LOG(log_level::error, "init_card incomplete.");
        }

        aa_device_info::print_card_info(selected_card_info);
        //-------------------------------------------
// std::cout<<"we got here g2"<<std::endl;
        //-------- Define user DM plan 
        aa_ddtr_plan ddtr_plan;
                        // --- start add dm loop ---
                //for (int i = 0; i < num_cols; i++){  
               while(downsampling[0] != 1){
                        for(int s = 0; s < num_cols; s++){
                                downsampling[s] = (int)downsampling[s] / 2;
                        }
               }
                for (int i = 0; i < num_cols ; i++){                          
                        float low;
                        low = low_vector[i];
                        
                        float high;
                        high = low + dm_step_vector[i]*(float)ndmtrials_vector[i];
                                           
                        
                        //ddtr_plan.add_dm(low, high, dm_step_vector[i], downsampling[i], downsampling[i]); // Add dm_ranges: dm_low, dm_high, dm_step, inBin, outBin (unused).
                        ddtr_plan.add_dm(low, high, r_dm_steps[i], downsampling[i], downsampling[i]);
                }
                        // -- end loop --
                        // Filterbank metadata
                        const double tstart = 50000;
                        const double total_bandwidth = jbandwidth;
                        const double nbits = 8;
//                      const unsigned int nsamples = 30.0/tsamp;
                        const unsigned int nsamples = comp_nsamples;
                        const double foff = -total_bandwidth/nchans;
                        // params needed by the fake signal function
                        double dm_position = 250.0; // at what dm put the signal
                        const int func_width = 1/(tsamp*25); // width of the signal in terms of # of samples;
                        const int signal_start = 0.2/tsamp; // position of the signal in samples; mean the position of the peak;
                        bool dump_signal_to_disk = false; // this option writes the generated signal to a file 'fake_signal.dat'
                        const float sigma = 0.5;
                        //---------------------------------------------------------------------------

                        // setting the signal metadata
                        aa_filterbank_metadata metadata(tstart, tsamp, nbits, nsamples, fch1, foff, nchans);
                        // setting the metadata for running fake generator
                        aa_fake_signal_metadata f_meta(dm_position, signal_start, func_width, sigma);

                        const size_t free_memory = selected_card_info.free_memory; // Free memory on the GPU in bytes
                        bool enable_analysis = false;

                        aa_ddtr_strategy strategy(ddtr_plan, metadata, free_memory, enable_analysis);
                        if(!(strategy.ready())) {
                                std::cout << "There was an error" << std::endl;
                                return 0;
                        }

                        // creating the signal -------------------------
                        aa_fake_signal_generator signal;
                        signal.create_signal(strategy, f_meta, metadata, dump_signal_to_disk);
                        if(!(signal.ready())) {
                              std::cout << "Error in creating fake signal" << std::endl;
                              return 0;
                        }
                        std::vector<unsigned short> input_data;
                        input_data = signal.signal_data();
                        //-----------------------------------------------

                        aa_pipeline::pipeline pipeline_components;
                        pipeline_components.insert(aa_pipeline::component::dedispersion);

                        aa_pipeline::pipeline_option pipeline_options;

                        aa_pipeline_api<unsigned short> runner(pipeline_components, pipeline_options, metadata, input_data.data(), selected_card_info);
                        runner.bind(ddtr_plan);

                        if (runner.ready()) {
                                LOG(log_level::notice, "Pipeline is ready.");
                        }
                        else {
                                LOG(log_level::notice, "Pipeline is not ready.");
                        }

                        //------------- Run the pipeline
                                aa_pipeline_runner::status status_code;
                                while(runner.run(status_code)){
                                }
                        //-------------<

                        int ndms = strategy.ndms(0);

                        LogKernel id;
                        TimeLog timelog;
                        TimeLog::maptype times;
                        size_t nTprocessed = strategy.nProcessedTimesamples();//        
                        timelog.print_to_file_all(fch1 - total_bandwidth/2.0, tsamp, nchans, total_bandwidth, ndms, nTprocessed, UNROLLS, SNUMREG, SDIVINT, SDIVINDM, id.get());

                        signal.print_info(f_meta);
                        strategy.print_info(strategy);

                        LOG(log_level::notice, "Finished. " + std::to_string(id.get()));
                        LOG(log_level::notice, "----------------------------------------------------------------------------------------------------------");


//                }// ndmtrials 
//	        } // dm_step
       // } //i (cols)
        } //tsamp
        } //nchans
        } // fch1
        } // comp_nsamples
}
//close input_file
input_file.close();
        return 0;
}

