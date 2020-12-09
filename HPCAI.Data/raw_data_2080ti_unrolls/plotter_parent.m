function plotter_parent(data)

histogram_plotter(data);
%best_v_273(data);

end

function histogram_plotter(data)

ndata = [];
tdata = [];
dmdata = [];

for i1 = 1:length(data)
    if size(data(i1).dmplan,2) == 1
        sort_index = 13;
    else
        sort_index = 14;
    end
    
    % sort time_logs using sort rows
    temp_sort = sortrows(data(i1).time_logs,sort_index);
    
    % 1.2 Take best (lowest) x (5% of 275 atm ~ 14)
    for i2 = 1:14
        ndata = [ndata,temp_sort(i2,3)];
        tdata = [tdata,temp_sort(i2,4)];
        dmdata = [dmdata,temp_sort(i2,5)];
    end
end

numreg_mean = mean(ndata);
numreg_sd = std(ndata);

divint_mean = mean(tdata);
divint_sd = std(tdata);

divindm_mean = mean(dmdata);
divindm_sd = std(dmdata);

figure(1)
histogram(ndata)
xline(numreg_mean)
xlabel('NUMREG')
ylabel('Frequency')

figure(2)
histogram(tdata)
xline(divint_mean)
xlabel('DIVINT')
ylabel('Frequency')

figure(3)
histogram(dmdata)
xline(divindm_mean)
xlabel('DIVINDM')
ylabel('Frequency')

end

function best_v_273(data)

%project_saver

best_delta_samps = zeros(length(data),2);
best_delta_time = zeros(length(data),1);
percentage_diff1 = zeros(length(data),1);
percentage_diff2 = zeros(length(data),1);
for i = 1:length(data)
    
    [tempbest_samps, temploc1] = min(data(i).time(:)./data(i).samples(:));
    [tempbest_time, temploc2] = min(data(i).time(:));
    
    %      if size(data(i1).dmplan,2) == 1
    %         sort_index = 13;
    %     else
    %         sort_index = 14;
    %     end
    best_delta_samps(i,1) = data(i).time_logs(1,6);
    best_delta_samps(i,2) = (data(i).time(271)./data(i).samples(271)) - tempbest_samps;
    best_delta_time(i) = data(i).time(271) - tempbest_time;
    percentage_diff1(i) = 100*(best_delta_samps(i,2)/(tempbest_samps));
    percentage_diff2(i) = (best_delta_time(i) / tempbest_time) * 100;
end


%plotting
subplot(1,2,1)
scatter(best_delta_samps(:,1),percentage_diff2(:))
xlabel('Central Freq')
ylabel('% Difference in Dedispersion time between best and 4-14-8-64')
subplot(1,2,2)
scatter(best_delta_samps(:,1),percentage_diff1(:))
xlabel('Central Freq')
ylabel('% Difference in Dedispersion time per sample between best and 4-14-8-64')



end