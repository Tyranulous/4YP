%project_saver

best_delta_samps = zeros(length(datain),2);
best_delta_time = zeros(length(datain),1);
percentage_diff1 = zeros(length(datain),1);
percentage_diff2 = zeros(length(datain),1);
for i = 1:length(datain)
    
    [tempbest_samps, temploc1] = min(datain(i).time(:)./datain(i).time_logs(:,11));
      [tempbest_time, temploc2] = min(datain(i).time(:));

%      if size(datain(i1).dmplan,2) == 1
%         sort_index = 13;
%     else
%         sort_index = 14;
%     end
    best_delta_samps(i,1) = datain(i).time_logs(1,6);
    best_delta_samps(i,2) = (datain(i).time(271)./datain(i).time_logs(271,11)) - tempbest_samps;
    best_delta_time(i) = datain(i).time(271) - tempbest_time;
    percentage_diff1(i) = 100*(best_delta_samps(i,2)/(tempbest_samps));
    percentage_diff2(i) = (best_delta_time(i) / tempbest_time) * 100;
end

%fixing bad data :) - it's off set as we lost one of the other
%configuratoins for some reason, it comes out to the same param set as most
%of the others.
best_delta(4,2) = 0;
percentage_diff1(4) = 0;
percentage_diff2(4) = 0;

%plotting
subplot(1,2,1)
scatter(best_delta_samps(:,1),percentage_diff2(:))
xlabel('Central Freq')
ylabel('% Difference in Dedispersion time')
subplot(1,2,2)
scatter(best_delta_samps(:,1),percentage_diff1(:))
xlabel('Central Freq')
ylabel('% Difference in Dedispersion time per sample')

