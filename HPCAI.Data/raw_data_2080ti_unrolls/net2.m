regression_layers = [
    featureInputLayer(50)%potential to name input features here if it might help
    fullyConnectedLayer(25)
    reluLayer
    fullyConnectedLayer(15)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer];

%trainopts = trainingOptions('adam','MaxEpochs',100,'InitialLearnRate',0.0005,'Plots','training-progress','Shuffle','every-epoch');
trainopts = trainingOptions('adam','MaxEpochs',100,'InitialLearnRate',0.001,'Plots','training-progress');
net = trainNetwork(fullfeatures,norm_vals,regression_layers,trainopts);
%net = trainNetwork(fullfeatures,values,regression_layers,trainopts);