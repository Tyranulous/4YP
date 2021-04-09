function classifier_statterPlotter(cnet,x,y,data) %extend to include threshold?


class = classify(cnet,x);
correct = 0;
false_network  = 0;
false_271 = 0;
preds = predict(cnet,x);
false_preds = 0;
true_preds = 0;
indexes = [];
for i = 1:length(y)
    
    if (class(i) == y(i))
        correct = correct + 1;
    elseif class(i) == 'true'
        false_network = false_network + 1;
        true_preds = true_preds + preds(i,2);
        indexes = [indexes;i];
    elseif class(i) == 'false'
        false_271 = false_271 + 1;
        false_preds = false_preds + preds(i,1);
        indexes = [indexes;i];
    end
end
correct
false_network
false_271

mean_false_pos = false_preds/false_network
mean_false_negatives = true_preds/false_271

trues = sum(y == 'true')
falses = sum(y == 'false')

dmplan_plotNstat(data,indexes);
