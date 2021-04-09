%NETWORK

%{

https://uk.mathworks.com/help/deeplearning/ug/list-of-deep-learning-layers.html

Input layer:
Feature input


middle layers:
fully connected
relu or elulayer

output:
classificationlayer or softmaxlayer

net = network(50,4);


%}

%dataimporter.m

divdm_layers = [
    featureInputLayer(8)%potential to name input features here if it might help
    fullyConnectedLayer(25)
    reluLayer
    fullyConnectedLayer(15)
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

% sigmoid as last layer
% 


%{
divt_layers = [
    featureInputLayer(50)
    fullyConnectedLayer(25)
    reluLayer
    fullyConnectedLayer(15)
    softmaxLayer
    classificationLayer];

acc_layers = [
    featureInputLayer(50)
    fullyConnectedLayer(25)
    reluLayer
    fullyConnectedLayer(8)
    softmaxLayer
    classificationLayer];
%}


trainopts = trainingOptions('adam','InitialLearnRate',0.001,'Plots','training-progress','ValidationData',{Xvalidation,Yvalidation});
net2 = trainNetwork(features_,vals_,divdm_layers,trainopts);
    