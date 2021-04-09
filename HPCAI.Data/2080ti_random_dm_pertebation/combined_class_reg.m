% Start!
%% Data import
%  dataimporter;

% network for classification
% Data processing 

%% Setup
clear training_datain validation_datain training validation table

% num_features = 17;

% amount of telescopes held back
percentage = 30;
classify_boundary = -1.6;
% class_y_loc = num_features - 2;
%{
while true
    [training_datain,validation_datain] = holdback(datain,percentage);

    % extract feature and response data
    [training_full, training_271, num_features] = combined_feature_tabler(training_datain);
    [validation_full, validation_271, ~] = combined_feature_tabler(validation_datain);
    
    class_y_loc = num_features - 2;
    
    a1 = table2array(training_271);
    training_classification = categorical(a1(:,class_y_loc)>classify_boundary);
    
    falses = training_classification == 'false';
    num_true = sum(not(falses))
    num_false = sum(falses)
    
%     if num_true>num_false
%         falsess = training_classification == 'true';
%         indexess = zeros(sum(falsess),1);
%         for i = 1:length(training_classification)
%             if training_classification(i) == 'true'
%                 indexess(i) = i;
%             end
%         end
%         randyrandom = randperm(num_false);
%         indexess = indexess(randyrandom);
%         indexess = indexess(indexess~=0);
%         training_classification(indexess) = [];
%     end





    test = abs(num_true-num_false)
    falses = training_classification == 'false';
    newtest = abs(sum(not(falses))-sum(falses))
    
    if newtest < 60
        break;
    end
    %full table in case thats useful
    % table271 = [training_271;holdback_271];
    % tablefull = [training_full,validation_full];
end
%}
%% Classifier preamble 2
%{
ytc = within_x_pct_classes(training_full,6);
yvc = within_x_pct_classes(validation_full,6);

validation_classification = categorical(yvc);
training_classification =categorical(ytc);

xtc = table2array(training_271(:,1:end-1));
xvc = table2array(validation_271(:,1:end-1));

%nan correction
xtc(isnan(xtc)) = 0;
xvc(isnan(xvc)) = 0;

falses = sum(ytc=='false')
trues = sum(ytc=='true')
%}

%% Classifier preamble
%{
% clear test
% 
% class_y_loc = num_features - 2;
% num_class_features = num_features - 3;
% 
% a1 = table2array(training_271);
% training_classification = categorical(a1(:,class_y_loc)>classify_boundary);
% a2 = table2array(validation_271);
% validation_classification = categorical(a2(:,class_y_loc)>classify_boundary);
% 
% xtc = a1(:,1:num_class_features);
% xvc = a2(:,1:num_class_features);
% 
% falses = training_classification == 'false';
% num_true = sum(not(falses))
% num_false = sum(falses)
% 
if num_true<num_false
    %error("More falses than trues, check subsequent code as it has untested behaviour")
    false_features = xtc(falses,:);
    true_features = xtc(not(falses),:);
    randy = randperm(num_false);
    false_features(randy(1:num_false-num_true),:) = [];
    
    reduced_training_set = [true_features;false_features];
    xtc = reduced_training_set;
    training_classification = [];
    training_classification(1:num_true,1) = 1;
    training_classification(num_true+1:2*num_true,1) = 0;
    training_classification = categorical(training_classification==1);
else
    true_features = xtc(not(falses),:);
    false_features = xtc(falses,:);
    randy = randperm(num_true);
    true_features(randy(1:num_true-num_false),:) = []; 
    
    reduced_training_set = [true_features;false_features];
    xtc = reduced_training_set;
    training_classification = [];
    training_classification(1:num_false,1) = 1;
    training_classification(num_false+1:2*num_false,1) = 0;
    training_classification = categorical(training_classification==1);
end



% reduced_training_set = [true_features;false_features];
% xtc = reduced_training_set;
% training_classification = [];
% training_classification(1:num_true,1) = 1;
% training_classification(num_true+1:2*num_true,1) = 0;
% training_classification = categorical(training_classification==1);
%}

%% Classifier Preamble 3

[training_datain,validation_datain] = holdback(datain,percentage);
% [training_datain,validation_datain] = holdback(datain1dm,percentage);
% extract feature and response data
[training_full, training_271, num_features] = combined_feature_tabler(training_datain);
[validation_full, validation_271, ~] = combined_feature_tabler(validation_datain);

class_y_loc = num_features - 2;

a1 = table2array(training_271);
training_classification = categorical(a1(:,class_y_loc)>classify_boundary);
    
num_falses = sum(training_classification == 'false')
num_trues = sum(training_classification == 'true')

if num_trues>num_falses
    cut = num_trues-num_falses;
    tlocs = [];
    for i = 1:length(training_classification)
        if training_classification(i) == 'true'
            tlocs = [tlocs;i];
        end
    end
    
    randy = randperm(length(tlocs),cut);
    tlocs = tlocs(randy);
    
    training_classification(tlocs) = [];
    a1(tlocs,:) = [];
        
end

xtc = a1(:,1:class_y_loc-1);
xvc = table2array(validation_271);
validation_classification = categorical(xvc(:,class_y_loc)>classify_boundary);
xvc = xvc(:,1:class_y_loc - 1);





%% Classifier network training

num_class_features = num_features - 3;

%plots to 'training-progess'
trainoptsc = trainingOptions('adam','MaxEpochs',5000, ...
            'InitialLearnRate',0.00075,'Plots','none', ...
            'MiniBatchSize',length(training_classification), 'Shuffle', 'every-epoch', ...
            'ValidationData',{xvc,validation_classification}, ...
            'ValidationPatience',4, "Verbose",true, ...
            'ValidationFrequency',15);
        
classLayerDefs = {{'featureInput',num_class_features},{'relu'},...
                    {'fullyConnected',5},{'relu'},{'fullyConnected',2},...
                    {'softmax'},{'classification'}};
%nn_classification_layers = createClassificationNetwork(classLayerDefs);
nn_classification_layers = [featureInputLayer(num_class_features)
                            reluLayer
                            fullyConnectedLayer(5)
                            reluLayer
                            dropoutLayer
                            fullyConnectedLayer(2)
                            softmaxLayer
                            classificationLayer];
[cnet,info] = trainNetwork(xtc,training_classification,nn_classification_layers,trainoptsc);
final_accuracy = info.FinalValidationAccuracy
accuracy_error = info.TrainingAccuracy(end) - info.FinalValidationAccuracy


%% Regression Network Preamble

% regression_layers = [
%     featureInputLayer(num_features)%potential to name input features here if it might help
%     fullyConnectedLayer(30)
%     reluLayer
%     fullyConnectedLayer(20)
%     reluLayer
%     fullyConnectedLayer(10)
%     reluLayer
%     fullyConnectedLayer(10)
%     reluLayer
%     fullyConnectedLayer(1)
%     regressionLayer];
 
regression_layers = [
    featureInputLayer(num_features)%potential to name input features here if it might help
    fullyConnectedLayer(30)
    leakyReluLayer
    fullyConnectedLayer(20)
    leakyReluLayer
    dropoutLayer
    fullyConnectedLayer(10)
    leakyReluLayer
    fullyConnectedLayer(20)
    leakyReluLayer
    fullyConnectedLayer(10)
    leakyReluLayer
    fullyConnectedLayer(1)
    regressionLayer];

xtr = table2array(training_full(:,1:num_features));
ytr = table2array(training_full(:,end));

xvr = table2array(validation_full(:,1:num_features));
yvr = table2array(validation_full(:,end));

yvr = nan_checker(yvr);
ytr = nan_checker(ytr);

%nan correction
xtr(isnan(xtr)) = 0;
xvr(isnan(xvr)) = 0;

%% Regression Netowork Training

%plots to 'training-progess'
trainoptsr = trainingOptions('adam','MaxEpochs',5000, ...
            'InitialLearnRate',0.002,'Plots','none', ...
            'MiniBatchSize',10000, 'Shuffle', 'every-epoch', ...
            'ValidationData',{xvr,yvr}, 'ValidationPatience',8, ...
            'ValidationFrequency', 25);
        
[rnet, net5info] = trainNetwork(xtr,ytr,regression_layers,trainoptsr)
%reg_stats = location_statter(simple_pred_hashdefines
%net = trainNetwork(fullfeatures,values,regression_layers,trainopts);


%% Testing performance

net_stats7 = stats(rnet, validation_datain, validation_full, 2)

combined_hashdefines = combined_predictor(cnet,rnet,table2array(validation_full));
simple_pred_hashdefines = just_nn_predictor(rnet,table2array(validation_full));
location_plotter(combined_hashdefines,validation_datain);

reg_stats = location_statter(simple_pred_hashdefines,validation_datain)
combined_stats = location_statter(combined_hashdefines,validation_datain)
