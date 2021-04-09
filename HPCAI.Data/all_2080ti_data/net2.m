regression_layers = [
    featureInputLayer(12)%potential to name input features here if it might help
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(8)
    reluLayer
    fullyConnectedLayer(8)
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

trainopts = trainingOptions('adam','MaxEpochs',1000, ...
            'InitialLearnRate',0.005,'Plots','training-progress', ...
            'MiniBatchSize',550, 'Shuffle', 'every-epoch', ...
            'ValidationData',{xv,yv});
        
net = trainNetwork(xt,yt,regression_layers,trainopts);
%net = trainNetwork(fullfeatures,values,regression_layers,trainopts);