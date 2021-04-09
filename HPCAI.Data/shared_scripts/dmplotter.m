function dmplotter(data)

for t = 1:length(data)
    dmplan = data(t).dmplan;
    
    leny = size(dmplan,2);
    len(t) = leny;
    
    total_trials(t) = sum(dmplan(4,:));
    adjusted_trials(t) = sum(dmplan(4,:)./dmplan(3,:));
    pct_1dm(t) = dmplan(4,1)/adjusted_trials(t);
    if leny>1
        pct_1dm2(t) = dmplan(4,1)/adjusted_trials(t);
        pct_2dm(t) = sum(dmplan(4,1:2)./dmplan(3,1:2))/adjusted_trials(t);
        if leny>2
        pct_3dm(t) = sum(dmplan(4,1:3)./dmplan(3,1:3))/adjusted_trials(t);
        end
    end
end

max_dmplan_length = max(len)
mean1 = mean(pct_1dm)
mean11 = mean(pct_1dm2)
mean2 = mean(pct_2dm)
mean3 = mean(pct_3dm)
std1 = std(pct_1dm2)
std2 = std(pct_2dm)
% figure()
% plot(pct_1dm);
% figure()
% plot(pct_2dm)
% figure()
% plot(adjusted_trials)
