function output = just_nn_predictor(rnet, matrix)

reg = predict(rnet,matrix(:,1:end-1));
output = NaN(length(matrix)/275,1);
for i = 0:length(matrix)/275 - 1
        locs = i*275+1:(i+1)*275;
        [~,loc] = min(reg(locs));
        output(i+1) = loc;
end
end