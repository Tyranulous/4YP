function output = location_statter(locs,data)

lend = length(data);
cfs = zeros(lend,1);
predicted_pcts = cfs;
hd_pcts = cfs;

output = struct('mean_predicted',0, ...
                'median_predicted',0,...
                'mode_predicted',0,...
                'std_predicted',0,...                
                'mean_271',0,...
                'std_271',0,...
                'correct_preds',0, ...
                'correct_preds_pct',0, ...
                'correct_271',0, ...
                'beat_271',0, ...
                'default_hd_picked',0 ...
                );       

for t = 1:lend
    
%     tps = data(t).corrected_time(:)./data(t).samples;
    tps = data(t).corrected_time(:)./sum(data(t).dmplan(4,:)./data(t).dmplan(3,:));
    cfs(t) = data(t).central_freq;
    
    best = min(tps);
    predicted_pcts(t) = ((tps(locs(t)) - best) / best).*100;
    hd_pcts(t) = ((tps(271) - best) / best ) * 100;
    
end

output.correct_preds = sum(predicted_pcts == 0);
output.correct_preds_pct = output.correct_preds/length(locs) * 100;
output.correct_271 = sum(hd_pcts == 0);
output.beat_271 = sum(hd_pcts>predicted_pcts);
output.default_hd_picked = sum(hd_pcts==predicted_pcts);

output.mean_predicted = mean(predicted_pcts);
output.median_predicted = median(predicted_pcts);
output.mode_predicted=mode(predicted_pcts);
output.std_predicted = std(predicted_pcts);
output.max_predicted = max(predicted_pcts);
output.mean_271 = mean(hd_pcts);
output.std_271 = std(hd_pcts);
output.max_271 = max(hd_pcts);

