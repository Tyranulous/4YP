function stats = dmplan_plotNstat(data,indexes)

%Plan:
%{
Loop through selected dmplans
add relevant data to various arrays
plot said data 

data to plot:
    -random offset value - might have to rewrite the import script for this
    -max dm - min dm?
    -min dm step
    -max dm step
    -mean dm step
    -var dm step
    -num ranges

%}

%% Preamble / variable definitions

close all

%% Function

for i = 1:length(indexes)
    dmplan = data(indexes(i)).dmplan;
    
    pertebation(i) = dmplan(1,1) / dmplan(5,1);
    maxdm(i) = (dmplan(2,end)+dmplan(1,end)*dmplan(3,end));
    mindm(i) = dmplan(2,1);
    mindmstep(i) = dmplan(1,1);
    maxdmstep(i) = dmplan(1,end);
    meandmstep(i) = mean(dmplan(1,:));
    vardmstep(i) = var(dmplan(1,:));
    numranges(i) = size(dmplan,2);
    numdmtrials(i) = sum(dmplan(4,:)./dmplan(3,:));
    dmtrialWeightingVar(i) = var(dmplan(4,:)./dmplan(3,:));
    dmtrialWeightingKertosis(i) = kurtosis(dmplan(4,:)./dmplan(3,:));
    dmtrialWeightingSkewness(i) = skewness(dmplan(4,:)./dmplan(3,:));
end


is = 1:length(indexes);

figure('Name','Random Pertebation Value');
histogram(pertebation); 
title('Random Pertebation Value')

figure('Name','Max and Min DM / binning');
scatter(is,maxdm); 
title('Max and Min DM / binning')
hold on
scatter(is,mindm);
legend('max dm', 'min dm');
hold off

figure('Name','Max, Min, Mean, Var DM step');
histogram(maxdmstep); 
title('Max, Min, Mean, Var DM step');
hold on
histogram(mindmstep); 
histogram(meandmstep);
histogram(vardmstep);
legend('Max DM step','Min DM step','Mean DM step','Var DM step');
hold off

figure('Name','Number of Ranges');
histogram(numranges);
title('Number of Ranges')

figure('Name','Total number of DM trials / binning')
histogram(numdmtrials);
title('Total number of DM trials / binning');

figure('Name','dmtrial Weighting Var');
histogram(dmtrialWeightingVar);
title('dmtrial Weighting Var')

figure('Name','dmtrial Weighting kertosis and skew');

histogram(dmtrialWeightingKertosis);
hold on
histogram(dmtrialWeightingSkewness);
legend('DM trials Kertosis','DM trials skewness');
title('dmtrial Weighting kertosis and skew')


