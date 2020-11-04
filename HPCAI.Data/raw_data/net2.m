regression_layers = [
    featureInputLayer(50)%potential to name input features here if it might help
    fullyConnectedLayer(40)
    reluLayer
    fullyConnectedLayer(25)
    reluLayer
    fullyConnectedLayer(15)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer];

trainopts = trainingOptions('adam','InitialLearnRate',0.001,'Plots','training-progress');