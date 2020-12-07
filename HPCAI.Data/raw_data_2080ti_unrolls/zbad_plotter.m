figure(1)
hold on
a=1;
b=1;
c=1;
d=1;

cf_mean512 = [];
cf_mean1024 = [];
cf_mean2048 = [];
cf_mean4096 = [];

for i=1:length(datain)
    
    if true %ne(i,26) && ne(i,25) %&& ne(i,7) && ne(i,8) && ne(i,9) && ne(i,10) && ne(i,30)
        i
        %temp = datain(i).speedup;%
        temp = datain(i).time(:) ./ datain(i).samples(:) ./ datain(i).chans;
        
        if datain(i).chans == 512
            
            plotting512(1:length(temp),a) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,1);
            %plot(plotting512);
            
            cf_mean512 = [cf_mean512; datain(i).time_logs(1,6),mean(temp)];
            a = a+1;
            
        end
        if datain(i).chans == 1024
            plotting1024(1:length(temp),b) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,2);
            %plot(plotting1024);
            
             cf_mean1024 = [cf_mean1024; datain(i).time_logs(1,6),mean(temp)];
            b = b+1;
        end
        if datain(i).chans == 2048
            plotting2048(1:length(temp),c) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,3);
            %plot(plotting2048);
            
             cf_mean2048 = [cf_mean2048; datain(i).time_logs(1,6),mean(temp)];
            c = c+1;
        end
        if datain(i).chans == 4096
            plotting4096(1:length(temp),d) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,4);
            %plot(plotting4096);
            
             cf_mean4096 = [cf_mean4096; datain(i).time_logs(1,6),mean(temp)];
            d = d+1;
        end
        plotting(1:length(temp),i) = temp;%datain(i).speedup(:) ./ datain(i).samples(:);
    end
   
end
% nplot = normalize(plotting);
% plot(nplot)


% nplotting4096 = normalize(plotting4096);
% nplotting2048 = normalize(plotting2048);
% nplotting1024 = normalize(plotting1024);
% nplotting512 = normalize(plotting512);
% 
% 
% 
subplot(2,2,1)
plot(plotting512);
subplot(2,2,2)
plot(plotting1024);
subplot(2,2,3)
plot(plotting2048);
subplot(2,2,4)
plot(plotting4096);

figure(2)
hold on
scatter(cf_mean512(:,1),cf_mean512(:,2));
scatter(cf_mean1024(:,1),cf_mean1024(:,2));
scatter(cf_mean2048(:,1),cf_mean2048(:,2));
scatter(cf_mean4096(:,1),cf_mean4096(:,2));
legend('chans = 512','chans = 1024','chans = 2048', 'chans = 4096')
title('Mean (dedispersion time/number of samples) vs central freq split by num chans')
xlabel('Central Freq')
ylabel('mean(time/samples)')
hold off