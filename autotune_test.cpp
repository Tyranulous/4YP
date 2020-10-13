#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>



int main() {

//super dodgey read from file code :/

    std::vector< std::vector<float> > float_array;
    std::vector<std::string> num;
    std::vector<float> pusher;

std::vector<float> temp_idea;

    std::ifstream file("/home/josch/HPC-AI-4YP/branch/4YP/Scripts/test.dat");
    // Check if object is valid
    if (!file.is_open())
    {
        std::cout<<"error reading file sad"<<std::endl;
        return 1;
    }
    //create string line
    std::string line;
    
    //loop through each line in the file individually
    while (std::getline(file,line)) 
    {
     
     // check if string is too small to remove square brackets (something has gone wrong if we hit this)
        if (line.size()<2){
            std::cout<<"string too small"<<std::endl;
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
std::cout<<substring<<std::endl;
                // cast to type val
                val = std::stof(substring);
                //push to pusher for pushing into vector array - this is maybe lazieness because i cba copy pasting this 6 times which in retrospect might have been easier
                temp_idea.push_back(val);
            }
            // push vector to vector
           // float_array.push_back(pusher);
        }
    }
    //close file
    file.close();
    

        int length = temp_idea.size();
        int num_cols = (length + 1) / 6;
        std::cout<<"length:"<<length<<"  numcols:"<<num_cols<<std::endl; 

        std::vector<float> dm_step_vector(temp_idea.begin(),(temp_idea.begin() + num_cols));  //float_array[0]; // = {0.1, 0.2, 0.5, 1.0, 2.0};
        std::vector<double> fch1_vector = {1550};
//      std::vector<double> tsamp_vector = {6.4e-5, 12.8e-5, 25.6e-5, 51.2e-5, 102.4e-5};
        std::vector<double> tsamp_vector = {25.6e-5};
//        std::vector<int> nchans_vector = {512, 1024, 2048, 4096, 8192};
//        std::vector<int> ndmtrials_vector = {500, 1000, 1500, 2000, 2500};
        std::vector<unsigned int> nsamples_vector = {468750};
//      std::vector<unsigned int> nsamples_vector = {78125,156250,468750,9375000};

//      std::vector<float> dm_step_vector = {0.1};
//      std::vector<double> fch1_vector = {1550};
//      std::vector<double> tsamp_vector = {6.4e-5};
      std::vector<int> nchans_vector = {4096};
//      std::vector<float> tempvec = float_array[4];
      std::vector<int> ndmtrials_vector((temp_idea.begin() + 4 * num_cols),(temp_idea.begin() + 5 * num_cols));//(float_array[3].end(), float_array[4].end()); //= {500};
//      std::vector<unsigned int> nsamples_vector = {28125000};


   for (int ndmtrials : ndmtrials_vector){
                std::cout<<"ndmtrials:"<<ndmtrials<<std::endl;
   }
   /*    
        for (unsigned int comp_nsamples : nsamples_vector){
        for (double fch1 : fch1_vector){
        for (int nchans : nchans_vector){
        for (double tsamp : tsamp_vector){
        for (float dm_step : dm_step_vector){
        for (int ndmtrials : ndmtrials_vector){
                std::cout<<"ndmtrials:"<<ndmtrials;
                std::cout<<"  dm_step:"<<dm_step;
                std::cout<<"  tsamp:"<<tsamp<<std::endl;
        }}}}}}
 /*       //-----------------------  Init the GPU card
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
                LOG(log_level::error, "init_card incomplete.")
        }

        aa_device_info::print_card_info(selected_card_info);
        //-------------------------------------------

        //-------- Define user DM plan 

                        aa_ddtr_plan ddtr_plan;
                        float high;
                        high = dm_step*(float)ndmtrials;
                        ddtr_plan.add_dm(0, high, dm_step, 1, 1); // Add dm_ranges: dm_low, dm_high, dm_step, inBin, outBin (unused).

                        // Filterbank metadata
                        const double tstart = 50000;
                        const double total_bandwidth = 300.0f;
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
                        size_t nTprocessed = strategy.nProcessedTimesamples();
                        timelog.print_to_file_all(fch1 - total_bandwidth/2.0, tsamp, nchans, dm_step, ndms, nTprocessed, UNROLLS, SNUMREG, SDIVINT, SDIVINDM, id.get());

                        signal.print_info(f_meta);
                        strategy.print_info(strategy);

                        LOG(log_level::notice, "Finished. " + std::to_string(id.get()));
                        LOG(log_level::notice, "----------------------------------------------------------------------------------------------------------");
                }// ndmtrials 
	        } // dm_step
        } //tsamp
        } //nchans
        } // fch1
        } // comp_nsamples
*/
        return 0;
}

