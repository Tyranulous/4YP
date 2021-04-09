regression_layers = [
    featureInputLayer(14)%potential to name input features here if it might help
    %fullyConnectedLayer(30)
    %reluLayer
    fullyConnectedLayer(20)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer];
 
%trainopts = trainingOptions('adam','MaxEpochs',100,'InitialLearnRate',0.0005,'Plots','training-progress','Shuffle','every-epoch');
%trainopts = trainingOptions('sgdm','MaxEpochs',100,'InitialLearnRate',0.001,'Plots','training-progress');
%net = trainNetwork(trainingTable2,'time_per_sample',regression_layers,trainopts);

[xt,yt] = table2array_splitter(trainingTable);
[xv,yv] = table2array_splitter(holdbackTable);

yv = nan_checker(yv);
yt = nan_checker(yt);

trainopts = trainingOptions('sgdm','MaxEpochs',5000, ...
            'InitialLearnRate',0.01,'Plots','training-progress', ...
            'MiniBatchSize',10000, 'Shuffle', 'every-epoch', ...
            'ValidationData',{xv,yv}, 'ValidationPatience',8, ...
            'ValidationFrequency', 25);
        
[net7, net5info] = trainNetwork(xt,yt,regression_layers,trainopts)
%net = trainNetwork(fullfeatures,values,regression_layers,trainopts);

net_stats7 = stats(net7, holdback_datain, holdbackTable, 2)