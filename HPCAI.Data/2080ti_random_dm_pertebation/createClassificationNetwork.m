function layers = createClassificationNetwork(layerDefs)
%CREATECLASSIFICATIONNETWORK Generates a neural network for the 
%   Generates and trains a NN with layers specified by layers matrix and number of
%   neurons specified by neurons, trainopts optional extra argument sets
%   training options 


% 
%     featureInputLayer(50)%potential to name input features here if it might help
%     fullyConnectedLayer(25)
%     reluLayer
%     fullyConnectedLayer(7)
%     softmaxLayer
%     classificationLayer
layers = [];
    for i = 1:length(layerDefs)
        switch layerDefs{i}{1}
            case 'relu'
                layers = [layers; reluLayer];
            case 'featureInput'
                layers = [layers; featureInputLayer(layerDefs{i}{2})];
            case 'fullyConnected'
                layers = [layers; fullyConnectedLayer(layerDefs{i}{2})];
            case 'softmax'
                layers = [layers; softmaxLayer];
            case 'classification'
                layers = [layers; classificationLayer];
            case 'leakyrelu'
                layers = [layers; leakyReluLayer];
            case 'dropout'
                layers = [layers; dropoutLayer];
            otherwise
                error("something went wrong in the layer defintion :(")
        end       
    
%     if ~exist('trainopts', 'var')
%         trainopts = trainingOptions('adam','MaxEpochs',5000, ...
%             'InitialLearnRate',0.0005,'Plots','training-progress', ...
%             'MiniBatchSize',128, 'Shuffle', 'every-epoch', ...
%             'ValidationData',{xhc,holdback_classification}, ...
%             'ValidationFrequency',15, ...
%             'ValidationPatience',inf);
%     end
    
    
    end
    
end

