%lots_of_graph_plotter

%for each param we look at we need to bin into discrete possibles

% 1 Identify top 5% of results
    % 1.1 Create sorted matrix of params and time
numreg = [2,0;4,0;6,0;8,0;10,0;12,0;14,0;16,0];
divint = [4,0;8,0;10,0;12,0;14,0;16,0;18,0;20,0;24,0;25,0;28,0;30,0;32,0;48,0;50,0;64,0];
divindm = [10,0;15,0;20,0;24,0;25,0;32,0;40,0;48,0;50,0;60,0;64,0;128,0];

ndata = [];
tdata = [];
dmdata = [];

ndata2 = [];
tdata2 = [];
dmdata2 = [];

n_cf = [];
t_cf = [];
dm_cf = [];

n_cf2 = [];
t_cf2 = [];
dm_cf2 = [];

n_bw = [];
t_bw = [];
dm_bw = [];

time_cf = [];

for i1 = 1:length(datain)
    if size(datain(i1).dmplan,2) == 1
        sort_index = 13;
    else
        sort_index = 14;
    end
    
    % sort time_logs using sort rows
    temp_sort = sortrows(datain(i1).time_logs,sort_index);
    
    % 1.2 Take best (lowest) x (5% of 275 atm ~ 14)
    for i2 = 1:14
        ndata = [ndata,temp_sort(i2,3)];
        tdata = [tdata,temp_sort(i2,4)];
        dmdata = [dmdata,temp_sort(i2,5)];
        
        %%{
        switch temp_sort(i2,3)
            case 2
                numreg(1,2) = numreg(1,2) + 1;
                
            case 4
                numreg(2,2) = numreg(2,2) + 1;
                
            case 6
                numreg(3,2) = numreg(3,2) + 1;
                
            case 8
                numreg(4,2) = numreg(4,2) + 1;
                
            case 10
                numreg(5,2) = numreg(5,2) + 1;
                
            case 12
                numreg(6,2) = numreg(6,2) + 1;
                
            case 14
                numreg(7,2) = numreg(7,2) + 1;
           
            case 16
                numreg(8,2) = numreg(8,2) + 1;
            otherwise
                "something went wrong"
                
        end
        
        switch temp_sort(i2,4)
            case 4
                divint(1,2) = divint(1,2) + 1;
            case 8
                divint(2,2) = divint(2,2) + 1;
            case 10
                divint(3,2) = divint(3,2) + 1;
            case 12
                divint(4,2) = divint(4,2) + 1;
            case 14
                divint(5,2) = divint(5,2) + 1;
            case 16
                divint(6,2) = divint(6,2) + 1;
            case 18
                divint(7,2) = divint(7,2) + 1;
            case 20
                divint(8,2) = divint(8,2) + 1;
            case 24
                divint(9,2) = divint(9,2) + 1;
            case 25
                divint(10,2) = divint(10,2) + 1;
            case 28
                divint(11,2) = divint(11,2) + 1;
            case 30
                divint(12,2) = divint(12,2) + 1;
            case 32
                divint(13,2) = divint(13,2) + 1;
            case 48
                divint(14,2) = divint(14,2) + 1;
            case 50
                divint(15,2) = divint(15,2) + 1;
            case 64
                divint(16,2) = divint(16,2) + 1;
            otherwise
                "something went wrong2"
        end
        
        switch temp_sort(i2,5)
            case 10
                divindm(1,2) = divindm(1,2) + 1;
            case 15
                divindm(2,2) = divindm(2,2) + 1;
            case 20
                divindm(3,2) = divindm(3,2) + 1;
            case 24
                divindm(4,2) = divindm(4,2) + 1;
            case 25
                divindm(5,2) = divindm(5,2) + 1;
            case 32
                divindm(6,2) = divindm(6,2) + 1;
            case 40
                divindm(7,2) = divindm(7,2) + 1;
            case 48
                divindm(8,2) = divindm(8,2) + 1;
            case 50
                divindm(9,2) = divindm(9,2) + 1;
            case 60
                divindm(10,2) = divindm(10,2) + 1;
            case 64
                divindm(11,2) = divindm(11,2) + 1;
            case 128
                divindm(12,2) = divindm(12,2) + 1;
            otherwise
                "something went wrong 3"
 
        end
        %}
    end
    for i2 = 1:5
        ndata2 = [ndata2,temp_sort(i2,3)];
        tdata2 = [tdata2,temp_sort(i2,4)];
        dmdata2 = [dmdata2,temp_sort(i2,5)];
        
        n_cf2 = [n_cf2;temp_sort(i2,6),temp_sort(i2,3)];
        t_cf2 = [t_cf2;temp_sort(i2,6),temp_sort(i2,4)];
        dm_cf2 = [dm_cf2;temp_sort(i2,6),temp_sort(i2,5)];
    
    end
    n_cf = [n_cf;temp_sort(1,6),temp_sort(1,3)];
    t_cf = [t_cf;temp_sort(1,6),temp_sort(1,4)];
    dm_cf = [dm_cf;temp_sort(1,6),temp_sort(1,5)];
    
    time_cf = [time_cf;temp_sort(1,6),temp_sort(1,sort_index)/temp_sort(1,11)];
    
    %{ 
    n_bw = [n_bw;datain(i1).bw,temp_sort(i2,3)];
    t_bw = [t_bw;datain(i1).bw,temp_sort(i2,4)];
    dm_bw = [dm_bw;datain(i1).bw,temp_sort(i2,5)];
    %}
    
end
%{
numreg_mean = sum(numreg(:,1).*numreg(:,2))/sum(numreg(:,2));
numreg_sd = sqrt(sum(((numreg(:,1)-numreg_mean).*numreg(:,2)).^2)./sum(numreg(:,2)));

divint_mean = sum(divint(:,1).*divint(:,2))/sum(divint(:,2));
divint_sd = sqrt(sum(((divint(:,1)-divint_mean).*divint(:,2)).^2)./sum(divint(:,2)));

divindm_mean = sum(divindm(:,1).*divindm(:,2))/sum(divindm(:,2));
divindm_sd = sqrt(sum(((divindm(:,1)-divindm_mean).*divindm(:,2)).^2)./sum(divindm(:,2)));
%}

numreg_mean = mean(ndata);
numreg_sd = std(ndata);

divint_mean = mean(tdata);
divint_sd = std(tdata);

divindm_mean = mean(dmdata);
divindm_sd = std(dmdata);

numreg_mean2 = mean(ndata2);
numreg_sd2 = std(ndata2);

divint_mean2 = mean(tdata2);
divint_sd2 = std(tdata2);

divindm_mean2 = mean(dmdata2);
divindm_sd2 = std(dmdata2);

%{
subplot(2,2,1);
bar(numreg(:,1),numreg(:,2),1)
xline(numreg_mean)
subplot(2,2,2);
bar(divint(:,1),divint(:,2),2)
xline(divint_mean)
subplot(2,2,3);
bar(divindm(:,1),divindm(:,2),1)
xline(divindm_mean)
subplot(2,2,4);
% 2 Split each time.log by the param and add to respective array/vector
    % 1.1 only need to count or...?
%}


% figure(1)
% histogram(ndata)
% xline(numreg_mean)
% xlabel('NUMREG')
% ylabel('Frequency')
% 
% figure(2)
% histogram(tdata)
% xline(divint_mean)
% xlabel('DIVINT')
% ylabel('Frequency')
% 
% figure(3)
% histogram(dmdata)
% xline(divindm_mean)
% xlabel('DIVINDM')
% ylabel('Frequency')
% 
% figure(4)
% histogram(ndata2)
% %xline(numreg_mean)
% xlabel('NUMREG')
% ylabel('Frequency')
% 
% figure(5)
% histogram(tdata2)
% %xline(divint_mean)
% xlabel('DIVINT')
% ylabel('Frequency')
% 
% figure(6)
% histogram(dmdata2)
% %xline(divindm_mean)
% xlabel('DIVINDM')
% ylabel('Frequency')
%     
% figure(7)
% hold on
% scatter(n_cf(:,1),n_cf(:,2),'x','r')
% scatter(t_cf(:,1),t_cf(:,2),'x','g')
% scatter(dm_cf(:,1),dm_cf(:,2),'x','b')
% legend('NUMREG','DIVINT','DIVINDM')
% hold off
% 
% figure(8)
% 
% subplot(2,3,1)
% histogram(ndata)
% xline(numreg_mean)
% xlabel('NUMREG')
% ylabel('Frequency (top 5%)')
% 
% subplot(2,3,2)
% histogram(tdata)
% xline(divint_mean)
% xlabel('DIVINT')
% ylabel('Frequency (top 5%)')
% 
% subplot(2,3,3)
% histogram(dmdata)
% xline(divindm_mean)
% xlabel('DIVINDM')
% ylabel('Frequency (top 5%)')
% 
% subplot(2,3,4)
% histogram(ndata2)
% xline(numreg_mean2)
% xlabel('NUMREG')
% ylabel('Frequency (top 1%)')
% 
% subplot(2,3,5)
% histogram(tdata2)
% xline(divint_mean2)
% xlabel('DIVINT')
% ylabel('Frequency (top 1%)')
% 
% subplot(2,3,6)
% histogram(dmdata2)
% xline(divindm_mean2)
% xlabel('DIVINDM')
% ylabel('Frequency (top 1%)')

figure(9)
scatter(time_cf(:,1),time_cf(:,2),'x')

% figure(8)
% hold on
% scatter(n_cf2(:,1),n_cf2(:,2),'x','r')
% scatter(t_cf2(:,1),t_cf2(:,2),'x','g')
% scatter(dm_cf2(:,1),dm_cf2(:,2),'x','b')
% legend('NUMREG','DIVINT','DIVINDM')
% hold off
