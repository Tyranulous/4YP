function location_plotter(locs,data,titl,network_used)
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




%% Plotting

figure('Name',titl)

if exist('network_used', 'var')
    
    type1 = [predicted_pcts(network_used == 1),cfs(network_used == 1)'];
    type2 = [predicted_pcts(network_used == 2),cfs(network_used == 2)'];
    
    cf_hd=cfs;
    cf_hd(hd_pcts < 5) = [];
    hd_pcts(hd_pcts < 5) = [];
    
    scatter(type1(:,2),type1(:,1),'filled')
    hold on
    scatter(type2(:,2),type2(:,1),'filled')
    scatter(cf_hd,hd_pcts)
    % scatter(cfs(1),predicted_pcts(1));s
%     title('Percent difference of dedispersion time per sample comapred to best possible hash define')    
    ylabel('% Difference to Optimal Parameter Set')
    legend('classifier','regression',"Default parameter set")
    hold off
    figure('Name',titl)
    %remve = diffs==0;
    %cfsr = cfs(remve);
    %diffs = diffs(remve);
    type1 = [diffs(network_used == 1),cfs(network_used == 1)'];
    type2 = [diffs(network_used == 2),cfs(network_used == 2)'];
    
    scatter(type1(:,2),type1(:,1),'filled')
    hold on
    scatter(type2(:,2),type2(:,1),'filled')
    ylabel('% Difference to Default Parameter Set')
%     title('+ve means predicted better than default hash define')
    hold off
else
    scatter(cfs,predicted_pcts,'filled')
    hold on
    scatter(cfs,hd_pcts)
    % scatter(cfs(1),predicted_pcts(1));
%     title('Percent difference of dedispersion time per sample comapred to best possible hash define')
    ylabel('% Difference to Optimal Parameter Set')
    legend('Combined classifier and regression network',"Default parameter set")
    hold off
    figure('Name',titl)
    %remve = diffs==0;
    %cfsr = cfs(remve);
    %diffs = diffs(remve);
    scatter(cfs,diffs,'filled')
%     xlabel('cf')
    ylabel('% Difference to Default Parameter Set')
%     title('+ve means predicted better than default hash define')
end
end