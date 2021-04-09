function [output,type,output2] = combined_predictor2(classifier,network,matrix,xvc,best_hds)

matrix271 = matrix(271:275:length(matrix),4:end-1);
matrix = matrix(:,1:end-1);

classes = classify(classifier,xvc);
class_pred = predict(classifier,xvc);
reg = predict(network,matrix);
output = NaN(length(matrix271),1);
output2 = output;
type = output;
for i = 0:length(matrix271)-1
    if classes(i+1) == '0'
         locs = i*275+1:(i+1)*275;
         [~,locy] = min(reg(locs));
         output(i+1) = locy;
         type(i+1) = 2;
%             output(i+1) = 271;
    else
        type(i+1) = 1;
        switch classes(i+1)
            case '271'
                output(i+1) = 271;
            case '254'
                output(i+1) = 254;
            case '269'
                output(i+1) = 269;
            case '190'
                output(i+1) = 190;
            case '12'
                output(i+1) = 12;
            case '270'
                output(i+1) = 270;
            case '273'
                output(i+1) = 273;
            case '249'
                output(i+1) = 249;
            case '275'
                output(i+1) = 275;
        end
    end
end

for i = 0:length(matrix271)-1
if class_pred(i+1,1)>0.5
    locs = i*275+1:(i+1)*275;
    [~,locy] = min(reg(locs));
    output2(i+1) = locy;
else
    gt5 = sum(find(class_pred(i+1,:)>0.5));
    if gt5 > 0
        output2(i+1) = best_hds(gt5 - 1);
        %   if class_pred(i+1,2) > 0.5
        %         output(i+1) = 12;
        %     elseif class_pred(i+1,3) > 0.5
        %         output(i+1) = 190;
        %     elseif class_pred(i+1,4) > 0.5
        %         output(i+1) = 254;
        %     elseif class_pred(i+1,5) > 0.5
        %         output(i+1) = 269;
        %     elseif class_pred(i+1,6) > 0.5
        %         output(i+1) = 270;
        %     elseif class_pred(i+1,7) > 0.5
        %         output(i+1) = 271;
    else
        locs = i*275+1:(i+1)*275;
        [~,locy] = min(reg(locs));
        output2(i+1) = locy;
    end
end
end