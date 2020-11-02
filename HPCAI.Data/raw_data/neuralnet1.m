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



divdm_layers = [
    featureInputLayer(50)%potential to name input features here if it might help
    fullyConnectedLayer(50)
    reluLayer
    fullyConnectedLayer(12)
    softmaxLayer
    classificationLayer];

divt_layers = [
    featureInputLayer(50)
    fullyConnectedLayer(50)
    reluLayer
    fullyConnectedLayer(15)
    softmaxLayer
    classificationLayer];

acc_layers = [
    featureInputLayer(50)
    fullyConnectedLayer(50)
    reluLayer
    fullyConnectedLayer(8)
    softmaxLayer
    classificationLayer];

trainopts = trainingOptions('sgdm');
    