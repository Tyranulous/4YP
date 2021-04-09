function [predicted_pcts, hd_pcts] = data_extractor(locs,data)
%% Calculating 

lend = length(data);
cfs = zeros(lend,1);
predicted_pcts = cfs;
hd_pcts = cfs;

for t = 1:lend
    
    dmplan = data(t).dmplan;
    newsamples = dmplan(4,:)./dmplan(3,:);
    
%     tps = data(t).corrected_time(:)./data(t).samples;
tps = data(t).corrected_time(:)./sum(data(t).dmplan(4,:)./data(t).dmplan(3,:));    
%cfs(t) = data(t).central_freq;
    cfs(t) = data(t).time_logs(locs(t),8);
    %cfs(t) = var(newsamples);
    best = min(tps);
    predicted_pcts(t) = ((tps(locs(t)) - best) / best).*100;
    hd_pcts(t) = ((tps(271) - best) / best ) * 100;
    
end
cfs = 1:length(cfs);
diffs = hd_pcts - predicted_pcts;
end