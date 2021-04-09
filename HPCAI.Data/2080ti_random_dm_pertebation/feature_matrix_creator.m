%norm_data_preparer

% 1-unrolls
% 2-numreg -2 /14
% 3-divint -4 /60
% 4-divindm -10 /118
% 5-central freq -250 /1500
% 6-time sampling
% 7-nchans
% 8-bw
% 9-min_dm_step
% 10-max_dm_step
% 11-max_dm
% 12-ndm_ranges

%-----Normalising values to use------
%unrolls_const
unrolls = 4;

numreg_offset = 2;
numreg_div = 14;

divint_offset = 6;
divint_div = 60;

divindm_offset = 10;
divindm_div = 118;

cf_offset = 250;
cf_div = 1500;

tsamp_offset = 32;
tsamp_div = 992;

nchans_offset = 512;
nchans_div = 3584;

bw_offset = 50;
bw_div = 500;
%----------------------------------

percentage = 30;

[training_datain,holdback_datain] = holdback(datain,percentage);
%[training_datain_271,holdback_datain_271] = holdback_271_only(datain,percentage);

%calculate the total number of observations and telescopes
trainingTable = featureTable(training_datain);
holdbackTable = featureTable(holdback_datain);
training_table_271 = featureTable271(training_datain);
holdback_table_271 = featureTable271(holdback_datain);

table = [trainingTable;holdbackTable];


clear unrolls numreg_offset numreg_div divint_offset divint_div divindm_offset divindm_div tsamp_offset tsamp_div nchans_offset bw_div bw_offset cf_div cf_offset nchans_div

%holdback data


