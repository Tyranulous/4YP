function [tableOut] = featureTable(data)
telescopes = length(data);
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
    features_matrix(locs,1:7) = data(t).time_logs(:,2:8);
    %bandwidth
    features_matrix(locs,8) = data(t).bw;
    
    %---dm Data---
    dmplan = data(t).dmplan;
    %dimensions of dm plan for easier reading in of values
    dmplan_shape = size(dmplan,1,2);
    
    %min dm step
    features_matrix(locs,9) = dmplan(1,1);
    %max dm step
    features_matrix(locs,10) = dmplan(1,dmplan_shape(2));
    %max_dm                           start              +
    features_matrix(locs,11) = dmplan(2,dmplan_shape(2)) + dmplan(1,dmplan_shape(2)) * dmplan(4,dmplan_shape(2));
    features_matrix(locs,12) = dmplan_shape(2);
    %total num of dms?
    features_matrix(locs,13) = sum(dmplan(4,:));
    
    nan_time1(locs) = data(t).corrected_time(:)./data(t).samples(:);
    nan_time2(locs) = jnormaliser(data(t).corrected_time(:)./data(t).samples(:));
    nan_time4(locs) = normalize(data(t).corrected_time(:)./data(t).samples(:));
end


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


features_matrix(:,2) = jnormaliser(features_matrix(:,2),numreg_offset,numreg_div);
features_matrix(:,3) = jnormaliser(features_matrix(:,3),divint_offset,divint_div);
features_matrix(:,4) = jnormaliser(features_matrix(:,4),divindm_offset,divindm_div);
features_matrix(:,5) = jnormaliser(features_matrix(:,5),cf_offset,cf_div);
features_matrix(:,6) = jnormaliser(features_matrix(:,6),tsamp_offset,tsamp_div);
features_matrix(:,7) = jnormaliser(features_matrix(:,7),nchans_offset,nchans_div);
features_matrix(:,8) = jnormaliser(features_matrix(:,8),bw_offset,bw_div);

features_matrix(:,9) = jnormaliser(features_matrix(:,9));
features_matrix(:,10) = jnormaliser(features_matrix(:,10));
features_matrix(:,11) = jnormaliser(features_matrix(:,11));
features_matrix(:,12) = jnormaliser(features_matrix(:,12));
features_matrix(:,13) = jnormaliser(features_matrix(:,13));
%nan_time = jnormaliser(nan_time);
nan_time3 = normalize(nan_time1);

tableOut = array2table([features_matrix,nan_time4],'VariableNames',{'unrolls','numreg','divint','divindm','cf','tsamp','nchans','bw','max_dm_step','min_dm_step','max_dm','ndm_ranges','num_dm_samples','time_per_sample'});
%features_table = array2table(features_matrix,'VariableNames',{'unrolls','numreg','divint','divindm','cf','tsamp','nchans','bw','max_dm_step','min_dm_step','max_dm','ndm_ranges'});
%features_table = to_table(features_matrix,creected_time);

end