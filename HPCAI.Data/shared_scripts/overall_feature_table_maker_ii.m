function [table, current_num_features] = overall_feature_table_maker_ii(data)

num_telescopes = length(data);
current_num_features = 12;

%matrix = nan(num_telescopes,current_num_features);


for t = 1:num_telescopes
    tlocs = ((t-1)*275 + 1):t*275;
    
    % hashdefines and failsafe
    matrix(tlocs,1:3) = data(t).time_logs(:,3:5);
    %matrix(tlocs,4) = data(t).time_logs(:,1);
    matrix(tlocs,4) = data(t).failsafe_scores(:);
    % chans bw time_sampling
    matrix(tlocs,5:6) = data(t).time_logs(:,7:8); 
    matrix(tlocs,7) = data(t).bw;
    matrix(tlocs,8) = data(t).central_freq;
    
    % DM plan features
    dmplan = data(t).dmplan;
    dmsperrange_binning = dmplan(4,:)./dmplan(3,:);
    plan_length = size(dmplan,2);
%     step_mean = mean(dmsperrange_binning);
%     step_median = median(dmsperrange_binning);
%     step_mode = mode(dmsperrange_binning);
%     step_sd = std(dmsperrange_binning);
    step_skew = skewness(dmsperrange_binning);
    step_kurtosis = kurtosis(dmsperrange_binning);
%     step_skew2 = 
    
    matrix(tlocs,9) = step_skew;
    matrix(tlocs,10) = step_kurtosis;
    [~,matrix(tlocs,11)] = dmplan_line_fit(dmplan);
    matrix(tlocs,12) = data(t).time_logs(:,7) ./ dmplan(3,plan_length);
%     matrix(tlocs,1) = 
%     matrix(tlocs,1) = 
    
    
    
%{  
%     matrix(tlocs,1:6) = data(t).time_logs(:,3:8);
%     matrix(tlocs,7) = data(t).bw;
%     
%     dmplan = data(t).dmplan;
%     plan_length = size(dmplan,2);
%     adjusted_dmsum = sum(dmplan(4,:)./dmplan(3,:));
%     
%     matrix(tlocs,8) = dmplan(1,1);
%     %matrix(tlocs,9) = dmplan(1,plan_length);
%     matrix(tlocs,9) = dmplan(4,1)./adjusted_dmsum;
%     matrix(tlocs,10) = dmplan(2,plan_length) + dmplan(1,plan_length) * ...
%                         dmplan(4,plan_length);
%     matrix(tlocs,11) = plan_length;
%     matrix(tlocs,12) = adjusted_dmsum;
%     %matrix(tlocs,12) = sum(dmplan(4,:));
%     
%     [matrix(tlocs,13),matrix(tlocs,14)] = dmplan_line_fit(dmplan);
%     
%     matrix(tlocs,15) = data(t).time_logs(:,7) ./ dmplan(3,plan_length);
%     matrix(tlocs,16) = dmplan(4,1);
%     matrix(tlocs,17) = data(t).time_logs(:,1);
%     
%     
%     dmsperrange_binning = dmplan(4,:)./dmplan(3,:);
%     step_mean = mean(dmsperrange_binning);
%     step_median = median(dmsperrange_binning);
%     step_mode = mode(dmsperrange_binning);
%     step_sd = std(dmsperrange_binning);
%     step_skew = skewness(dmsperrange_binning);
%     step_kurtosis = kurtosis(dmsperrange_binning);
%     matrix(tlocs,18) = step_mean;
%     matrix(tlocs,19) = step_median;
%     matrix(tlocs,20) = step_mode;
%     matrix(tlocs,21) = step_sd;
%     matrix(tlocs,22) = step_skew;
%     matrix(tlocs,23) = step_kurtosis;
%       
%     
%}


%     matrix(tlocs,13) = normalize(data(t).corrected_time(:) ./ ...
%         data(t).samples(:));

matrix(tlocs,13) = normalize(data(t).corrected_time(:) ./ sum(data(t).dmplan(4,:)./data(t).dmplan(3,:)));
end


for i = 1:size(matrix,2)-1
    if i ~= 4
        matrix(:,i) = jnormaliser(matrix(:,i));
    end
end
% current_num_features = size(matrix,2) - 1;

%{
% matrix(:,2) = jnormaliser(matrix(:,2));
% matrix(:,3) = jnormaliser(matrix(:,3));
% matrix(:,4) = jnormaliser(matrix(:,4));
% matrix(:,5) = jnormaliser(matrix(:,5));
% matrix(:,6) = jnormaliser(matrix(:,6));
% matrix(:,7) = jnormaliser(matrix(:,7));
% matrix(:,8) = jnormaliser(matrix(:,8));
% matrix(:,9) = jnormaliser(matrix(:,9));
% matrix(:,10) = jnormaliser(matrix(:,10));
% matrix(:,11) = jnormaliser(matrix(:,11));
% matrix(:,12) = jnormaliser(matrix(:,12));
% matrix(:,13) = jnormaliser(matrix(:,13));
% matrix(:,14) = jnormaliser(matrix(:,14));
% matrix(:,15) = jnormaliser(matrix(:,15));
%}

% var_names = {'numreg','divint','divindm','cf','tsamp','nchans','bw', ...
%     'min_dm_step','max_dm_step','max_dm','num_ranges','total_num_dms_adjusted', ...
%     'dm_grad','dm_y','tsamp_d_binning','num_trials_in_first_dm','failsafe',...
%     'mean','med','mode','std','skewness','kurtosis','normalized_time_per_samp'};

%add random noise
randnoise = zeros(size(matrix));
randnoise(:,1:end-1) = randn(size(matrix(:,1:end-1)))./50;

% matrix = matrix + randnoise;

var_names = {'numreg','divint','divindm','failsafe','time_sampling','nchans','bw','cf','step_skew','step_kurtosis','dm_intercept','timesampling_binning','y'};
table = array2table(matrix,'VariableNames',var_names);
end