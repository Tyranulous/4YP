function [tableOut] = featureTable271time(data)
telescopes = length(data);

features_matrix = nan(telescopes,17);

for t = 1:telescopes
    
    %calculate and store range to be written to for each telescope
%     start_pos = (t-1)*275 + 1;
%     end_pos = t*275;
%     locs = start_pos:end_pos;
    
    %write data from time logs
    features_matrix(t,1:7) = data(t).time_logs(271,2:8);
    %bandwidth
    features_matrix(t,8) = data(t).bw;
    
    %---dm Data---
    dmplan = data(t).dmplan;
    %dimensions of dm plan for easier reading in of values
    dmplan_shape = size(dmplan,1,2);
    
    %min dm step
    features_matrix(t,9) = dmplan(1,1);
    %max dm step
    features_matrix(t,10) = dmplan(1,dmplan_shape(2));
    %max_dm                           start              +
    features_matrix(t,11) = dmplan(2,dmplan_shape(2)) + dmplan(1,dmplan_shape(2)) * dmplan(4,dmplan_shape(2));
    features_matrix(t,12) = dmplan_shape(2);
    %total num of dms
    features_matrix(t,13) = sum(dmplan(4,:));
    
    %dmthing
%     features_matrix(t,14) = dmplanstepmean(dmplan,dmplan_shape);

% Dm line fit
    [features_matrix(t,14),features_matrix(t,15)] = dmplan_line_fit(dmplan);
    %     features_matrix(t,15) = dmplan_variancer(dmplan);
    
    % min 
    features_matrix(t,16) = data(t).time_logs(271,7) / dmplan(3,end);
    
    norm_telescope_tps = normalize(data(t).corrected_time(:)./data(t).samples(:));
    
%     features_matrix(t,17) = data(t).corrected_time(271)./data(t).samples(271);
     features_matrix(t,17) = norm_telescope_tps(271);
%     nan_time1(locs) = data(t).corrected_time(:)./data(t).samples(:);
%     nan_time2(locs) = normaliser(data(t).corrected_time(:)./data(t).samples(:));
%     nan_time4(locs) = normalize(data(t).corrected_time(:)./data(t).samples(:));
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
features_matrix(:,14) = jnormaliser(features_matrix(:,14));
features_matrix(:,15) = jnormaliser(features_matrix(:,15));
features_matrix(:,16) = jnormaliser(features_matrix(:,16));
%nan_time = jnormaliser(nan_time);
%nan_time3 = normalize(nan_time1);

tableOut = array2table(features_matrix,'VariableNames',{'unrolls','numreg','divint','divindm','cf','tsamp','nchans','bw','max_dm_step','min_dm_step','max_dm','ndm_ranges','num_dm_samples','mean_dm_binning','mean_dm_step','min_sampling_per_binning','time_per_sample'});
%features_table = array2table(features_matrix,'VariableNames',{'unrolls','numreg','divint','divindm','cf','tsamp','nchans','bw','max_dm_step','min_dm_step','max_dm','ndm_ranges'});
%features_table = to_table(features_matrix,creected_time);

end