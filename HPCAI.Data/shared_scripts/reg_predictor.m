function reg_prediction = reg_predictor(network,matrix)

reg = predict(network,matrix);


for i = 0:size(matrix,1)/275-1
        locs = i*275+1:(i+1)*275;
        [~,loc] = min(reg(locs));
        reg_prediction(i+1) = loc;
end