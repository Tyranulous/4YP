function dmlength_plot(data)
data1 = [];
data3 = [];
data4 = [];
data5 = [];
data6 = [];
data7 = [];
data8 = [];
data2 = [];
datao = [];
for t = 1:length(data)
    dmlength = size(data(t).dmplan,2);
    switch dmlength
        case 1
            data1 = [data1; data(t).bestHashLoc];
        case 2
            data2 = [data2; data(t).bestHashLoc];
        case 3
            data3 = [data3; data(t).bestHashLoc];
        case 4
            data4 = [data4; data(t).bestHashLoc];
        case 5
            data5 = [data5; data(t).bestHashLoc];
        case 6
            data6 = [data6; data(t).bestHashLoc];
        case 7
            data7 = [data7; data(t).bestHashLoc];
        case 8
            data8 = [data8; data(t).bestHashLoc];
        otherwise
            datao = [datao; data(t).bestHashLoc];
    end
end

%plotting = [data1,data2,data3,data4,data5,data6,data7,data8,datao];
% for i = 1:9
hdplot1 = uniquess(data1);
hdplot2 = uniquess(data2);
hdplot3 = uniquess(data3);
hdplot4 = uniquess(data4);
hdplot5 = uniquess(data5);
hdplot6 = uniquess(data6);
hdplot7 = uniquess(data7);
hdplot8 = uniquess(data8);
hdploto = uniquess(datao);


% histc
% plotting = [mean(data1),mean(data2),mean(data3),mean(data4),mean(data5),...
%             mean(data6),mean(data7),mean(data8)];
datao
% figure();
% plot(plotting);
figure('Name','1');
bar(hdplot1(:,1),hdplot1(:,2));
% histogram(data1);
figure('Name','2');
bar(hdplot2(:,1),hdplot2(:,2));
% histogram(data2);
figure('Name','3');
bar(hdplot3(:,1),hdplot3(:,2));
% histogram(data3);
figure('Name','4');
bar(hdplot4(:,1),hdplot4(:,2));
% histogram(data4);
figure('Name','5');
bar(hdplot5(:,1),hdplot5(:,2));
% histogram(data5);
figure('Name','6');
bar(hdplot6(:,1),hdplot6(:,2));
% histogram(data6);
figure('Name','7');
bar(hdplot7(:,1),hdplot7(:,2));
% histogram(data7);
figure('Name','8');
bar(hdplot8(:,1),hdplot8(:,2));
% histogram(data8);
figure('Name','o');
bar(hdploto(:,1),hdploto(:,2));
end
function out = uniquess(data)
try
        out = unique(data);
        out = [out,zeros(length(out),1)];
        for ii = 1:length(out)
            out(ii,2) = sum(data == out(ii,1));
        end
catch
    error('uhoh')
end
end
