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

 
%calculate the total number of observations and telescopes
telescopes = length(testdatain);
observations = telescopes*275;

features_matrix = nan(observations,12);
nan_time1 = nan(observations,1);
nan_time2 = nan_time1;
nan_time4 = nan_time1;
for t = 1:telescopes
    
    %calculate and store range to be written to for each telescope
    start_pos = (t-1)*275 + 1;
    end_pos = t*275;
    locs = start_pos:end_pos;
    
    %write data from time logs
    features_matrix(locs,1:7) = testdatain(t).time_logs(:,2:8);
    %bandwidth
    features_matrix(locs,8) = testdatain(t).bw;
    
    %---dm Data---
    dmplan = testdatain(t).dmplan;
    %dimensions of dm plan for easier reading in of values
    dmplan_shape = size(dmplan,1,2);
    
    %min dm step
    features_matrix(locs,9) = dmplan(1,1);
    %max dm step
    features_matrix(locs,10) = dmplan(1,dmplan_shape(2));
    %max_dm                           start              + 
    features_matrix(locs,11) = dmplan(2,dmplan_shape(2)) + dmplan(1,dmplan_shape(2)) * dmplan(4,dmplan_shape(2));
    features_matrix(locs,12) = dmplan_shape(2);

    nan_time1(locs) = testdatain(t).corrected_time(:)./testdatain(t).samples(:);
    nan_time2(locs) = normaliser(testdatain(t).corrected_time(:)./testdatain(t).samples(:));
    nan_time4(locs) = normalize(testdatain(t).corrected_time(:)./testdatain(t).samples(:));
end

features_matrix(:,2) = normaliser(features_matrix(:,2),numreg_offset,numreg_div);
features_matrix(:,3) = normaliser(features_matrix(:,3),divint_offset,divint_div);
features_matrix(:,4) = normaliser(features_matrix(:,4),divindm_offset,divindm_div);
features_matrix(:,5) = normaliser(features_matrix(:,5),cf_offset,cf_div);
features_matrix(:,6) = normaliser(features_matrix(:,6),tsamp_offset,tsamp_div);
features_matrix(:,7) = normaliser(features_matrix(:,7),nchans_offset,nchans_div);
features_matrix(:,8) = normaliser(features_matrix(:,8),bw_offset,bw_div);

features_matrix(:,9) = normaliser(features_matrix(:,9));
features_matrix(:,10) = normaliser(features_matrix(:,10));
features_matrix(:,11) = normaliser(features_matrix(:,11));
features_matrix(:,12) = normaliser(features_matrix(:,12));

%nan_time = normaliser(nan_time);
nan_time3 = normalize(nan_time1);

features_table = array2table([features_matrix,nan_time4],'VariableNames',{'unrolls','numreg','divint','divindm','cf','tsamp','nchans','bw','max_dm_step','min_dm_step','max_dm','ndm_ranges','time_per_sample'});
%features_table = array2table(features_matrix,'VariableNames',{'unrolls','numreg','divint','divindm','cf','tsamp','nchans','bw','max_dm_step','min_dm_step','max_dm','ndm_ranges'});
%features_table = to_table(features_matrix,creected_time);



%{
features_matrix = nan(length(testdatain)*275,50);
values = zeros(length(testdatain)*275,1);
bigi = 1;
norm_vals = [];
valls = [];
fullfeatures_nodm = zeros(length(testdatain)*27,9);
for i = 1:length(testdatain)
    
    for log_i = 1:size(testdatain(i).time_logs,1)
        
        %dm plan
        flatdm = reshape(testdatain(i).dmplan.',1,[]);
        
        %temp features vector to allow for zeros easily
        tempfeatures =  [testdatain(i).time_logs(log_i,6:8), testdatain(i).bw, flatdm];
        tempfeatures2 = [testdatain(i).time_logs(log_i,6:8), testdatain(i).bw,testdatain(i).time_logs(log_i,1:5)];
        fullfeatures(bigi,1:length(tempfeatures)) = tempfeatures;
        fullfeatures_nodm(bigi,1:length(tempfeatures2)) = tempfeatures2;
        
        %add hpc params to features
        fullfeatures(bigi,46:50) = testdatain(i).time_logs(log_i,1:5);
        %normalised_temp(log_i) = testdatain(i).time_logs(log_i,14);
        %values(bigi) = testdatain(i).time(log_i);
        bigi = bigi+1;
    end
    valls = [valls; testdatain(i).time./testdatain(i).time_logs(:,11)];
    norm_vals = [norm_vals; normalize(testdatain(i).time./testdatain(i).time_logs(:,11))];
    %norm_vals = [norm_vals',n
end
%}

% function table = to_table(matrix, times)
%     matrix = [matrix,times
% end

%function to normalisea vector given the offest and divisor (or fa
function norm  = normaliser(input,offset,div)
if exist('input','var')
    if ~exist('offset','var') || ~exist('div','var')
        %warning('No offset or divisor was provided, defaulting to max and min')
        norm = (input - min(input))./(max(input) - min(input));
    else
        norm = (input-offset)./div;
    end
else
    error('No input vector supplied to normaliser function.')
end
end