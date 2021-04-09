function plotter_parent(data)

histogram_plotter(data);
%best_v_271(data);
%best_v_271_mkii(data);
%inter_tele_variance(data,1);
%inter_tele_variance(data,0);
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

function best_v_271(data)

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

function best_v_271_mkii(data)

%{
% plan!
% first need to order time_logs by time and time per samp - temp variable
% which contains this information in an easier to access location

% use location of best to find which hash define was that, record to a
% matrix

%record if cache or shared memory

%plot with colour to indicate cache
%figure out a way to use the hash define info usefully

%simples

%first only do time graph!
%need data for...:  temp all times
                    best times
                    central frequencies for telescope
                    percentage difference
                    %}
% best_delta_samps = zeros(length(data),2);
% best_delta_time = zeros(length(data),1);
% percentage_diff1 = zeros(length(data),1);
% percentage_diff2 = zeros(length(data),1);

%times = zeros(275,1);

best_times = zeros(length(data),1);
time_locs = zeros(length(data),1);
hash271_times = zeros(length(data),1);

hashdefines = zeros(length(data),1);
cache_or_shared = zeros(length(data),1);
cfs = zeros(length(data),1);
%pct_diffs = zeros(length(data,1);





for id = 1:length(data)
    
    %tempory time vector from datain
    times = data(id).corrected_time(:);
    
    %find best time
    [best_times(id),time_locs(id)] = min(times);
    hash271_times(id) = times(271);
    hashdefines(id,1:4) = data(id).time_logs(time_locs(id),2:5);
    
    cfs(id) = data(id).time_logs(1,6);
    
    cache_or_shared(id) = data(id).time_logs(271,1);
%    if data(id).time_logs(271,1) == 1 || data(id).time_logs(271,1) == 2
%        cache_or_shared(id) = "umm_wtf";
%    end
   
    
%     [tempbest_samps, temploc1] = min(data(id).time(:)./data(id).samples(:));
%     [tempbest_time, temploc2] = min(data(id).time(:));
    
    %      if size(data(i1).dmplan,2) == 1
    %         sort_index = 13;
    %     else
    %         sort_index = 14;
    %     end
%     best_delta_samps(i,1) = data(i).time_logs(1,6);
%     best_delta_samps(i,2) = (data(i).time(271)./data(i).samples(271)) - tempbest_samps;
%     best_delta_time(i) = data(i).time(271) - tempbest_time;
%     percentage_diff1(i) = 100*(best_delta_samps(i,2)/(tempbest_samps));
%     percentage_diff2(i) = (best_delta_time(i) / tempbest_time) * 100;
end

pct_diffs = [cfs,100 * ((hash271_times - best_times) ./ best_times)];

shared_pct = pct_diffs((cache_or_shared(:)==1),:);
cache_pct = pct_diffs((cache_or_shared(:)==2),:);

unique_hashdefines = unique(hashdefines,'rows');
unique_hashdefines = [unique_hashdefines, zeros(size(unique_hashdefines,1),1)];

for q = 1:size(unique_hashdefines,1)
    counter = 0;
    for qq = 1:size(hashdefines,1)
        counter = counter + ismember(unique_hashdefines(q,1:4), hashdefines(qq,:), 'rows');
    end
    unique_hashdefines(q,5) = counter;
end
    big_hash_labels = strings(size(hashdefines,1),1);
for i = 1:size(hashdefines,1)
    if ismember(hashdefines(i,:),[4,14,8,64])
        big_hash_labels(i) = '';
    else
        big_hash_labels(i) = strcat(string(hashdefines(i,1)),', ',string(hashdefines(i,2)),', ',string(hashdefines(i,3)),', ',string(hashdefines(i,4)));
    end
end
big_hash_labels = cellstr(big_hash_labels);
figure('Name','Time')
hold on
%scatter(cfs,pct_diffs)
text(cfs + 3, pct_diffs(:,2) + 3, big_hash_labels)
scatter(shared_pct(:,1),shared_pct(:,2));
scatter(cache_pct(:,1),cache_pct(:,2));
legend('Shared memory','Cache')
xlabel('Central Freq')
ylabel('% Difference in Dedispersion time between best and 4-14-8-64')
figure('Name','Hash Define Freq Plot')
unique_hashdefines = sortrows(unique_hashdefines,5);
for i=1:size(unique_hashdefines,1)
    hash_labels(i) = strcat('u:',string(unique_hashdefines(i,1)),' n:',string(unique_hashdefines(i,2)),' dvt:',string(unique_hashdefines(i,3)),' dvdm:',string(unique_hashdefines(i,4)));
end
hash_labels = categorical(hash_labels);
hash_labels = reordercats(hash_labels,string(hash_labels));
bar(hash_labels,unique_hashdefines(:,5))

%plotting
% subplot(1,2,1)
% scatter(best_delta_samps(:,1),percentage_diff2(:))
% xlabel('Central Freq')
% ylabel('% Difference in Dedispersion time between best and 4-14-8-64')
% subplot(1,2,2)
% scatter(best_delta_samps(:,1),percentage_diff1(:))
% xlabel('Central Freq')
% ylabel('% Difference in Dedispersion time per sample between best and 4-14-8-64')



end
function inter_tele_variance(data,samps)
percent_diff = zeros(length(data),2);
for i = 1:length(data)
    [tempmax,maxloc] = max(data(i).corrected_time);
    [tempmin, minloc] = min(data(i).corrected_time);
    if samps
        tempmax = tempmax/data(i).samples(maxloc);
        tempmin = tempmin/data(i).samples(minloc);
    end
    if tempmax ~= inf && tempmin ~= 0
        percent_diff(i,2) = (tempmin/(tempmax-tempmin))*100;
        percent_diff(i,1) = data(i).time_logs(1,6);
    else
        percent_diff(i,1) = data(i).time_logs(1,6);
        percent_diff(i,2) = 0;
    end
end
if samps
    figure('Name','samps')
    scatter(percent_diff(:,1),percent_diff(:,2),'filled')
    xlabel('central freq')
    ylabel('percent diff between best and worst time per samp')
else
    figure('Name','time')
    scatter(percent_diff(:,1),percent_diff(:,2),'filled')
    xlabel('central freq')
    ylabel('percent diff between best and worst time')
end
end