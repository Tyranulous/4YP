function [output,type,output2] = combined_predictor(classifier,network,matrix,xvc)

 matrix271 = matrix(271:275:length(matrix),4:end-1);
 matrix = matrix(:,1:end-1);

classes = classify(classifier,xvc);
class_pred = predict(classifier,xvc);
reg = predict(network,matrix);
output = NaN(length(matrix271),1);
type = output;

for i = 0:length(matrix271)-1
    if classes(i+1) == 'true'
        locs = i*275+1:(i+1)*275;
        [~,loc] = min(reg(locs));
        output(i+1) = loc;
        type(i+1) = 2;
    else
        output(i+1) = 271;
        type(i+1) = 1;
    end
end
% 
% for i = 0:length(matrix271)-1
%     if classes(i+1) == 'true'
%         locs = i*275+1:(i+1)*275;
%         [~,loc] = min(reg(locs));
%         output(i+1) = loc;
%     else
%         output(i+1) = 271;
%     end
% end
end