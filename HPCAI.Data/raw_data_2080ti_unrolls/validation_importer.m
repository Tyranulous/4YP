vfeatures = zeros(length(validation),50);
%labels = zeros(length(validation),1);


for i = 1:length(validation)
    vflatdm = reshape(validation(i).dmplan.',1,[]);
    vtempfeatures =  [validation(i).time_logs(1,6:8), validation(i).bw, vflatdm];
    vfeatures(i,1:length(vtempfeatures)) = vtempfeatures;
    %    labels(i) = validation(i).optimal_params(1,4);
    vfeatures(i,49:50) = validation(i).optimal_params(1,2:3);
end
vfullfeatures = zeros(length(validation)*275,50);
vvalues = zeros(length(validation)*275,1);
vbigi = 1;
vnorm_vals = [];
for i = 1:length(validation)
    for log_i = 1:size(validation(i).time_logs,1)
        
        %dm plan
        vflatdm = reshape(validation(i).dmplan.',1,[]);
        
        %temp features vector to allow for zeros easily
        vtempfeatures =  [validation(i).time_logs(log_i,6:8), validation(i).bw, vflatdm];
        vfullfeatures(vbigi,1:length(vtempfeatures)) = vtempfeatures;
        
        %add hpc params to features
        vfullfeatures(vbigi,46:50) = validation(i).time_logs(log_i,1:5);
        %normalised_temp(log_i) = validation(i).time_logs(log_i,14);
        vvalues(vbigi) = validation(i).time(log_i);
        vbigi = vbigi+1;
    end
    vnorm_vals = [norm_vals; normalize(validation(i).time./validation(i).time_logs(:,11))];
    %norm_vals = [norm_vals',n
end

%normalize values
%vnorm_vals = normalize(vvalues);
