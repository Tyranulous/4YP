%dataimporter

folders = dir('./');

datain = struct();
datain.time_logs = [];
datain.dmplan = [];
datain.telescope_params=[];
datain.time_error = [];
datain.optimal_params = [];
datain.divint = [];
datain.bw = [];


i = 3;
    if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name))
        path=folders(i).name; 
        datain(1).time_logs = time_log_importer(path);
        datain(1).dmplan = ddplan_reader(path);
        
        %find lowest and error
        [best_time, min_loc] = min(datain(1).time_logs(:,14));
        datain(1).optimal_params = datain(1).time_logs(min_loc,2:5);
        datain(1).time_error=datain(1).time_logs(:,14) - best_time; 
        
        %change time step to micro seconds
        temp_timestep = datain(1).time_logs(:,7) .* 1000000;
        datain(1).time_logs(:,7) = temp_timestep;
        
        %read in band width
        [~,bwstarti] = regexp(path,'bw-');
        bwendi = regexp(path,'__tsamp');
        bw = path(bwstarti+1:bwendi-1);
        datain(1).bw = str2double(bw);
    end
    
    
for i = 4:(length(folders)-2)
    if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name))
        path=folders(i).name;
        index = length(datain)+1;
        datain(index).time_logs = time_log_importer(path);
        datain(index).dmplan = ddplan_reader(path);
        
        %find lowest time to dedisperse and then caluclate differences to
        %that 
        [best_time, min_loc] = min(datain(index).time_logs(:,14));
        datain(index).optimal_params = datain(index).time_logs(min_loc,2:5);
        datain(index).time_error=datain(index).time_logs(:,14) - best_time;
        
        %change time step to micro seconds
        temp_timestep = datain(index).time_logs(:,7) .* 1000000;
        datain(index).time_logs(:,7) = temp_timestep;
        
        %read in band width - fun regular expressions :)
        [~,bwstarti] = regexp(path,'bw-');
        bwendi = regexp(path,'__tsamp');
        bw = path(bwstarti+1:bwendi-1);
        datain(index).bw = str2double(bw);
    end
end


features = zeros(length(datain),50);
labels = zeros(length(datain),1);
for i = 1:length(datain)
    flatdm = reshape(datain(i).dmplan.',1,[]);
    tempfeatures =  [datain(i).time_logs(1,6:8), datain(i).bw, flatdm];
    features(i,1:length(tempfeatures)) = tempfeatures;
    labels(i) = datain(i).optimal_params(1,4);
    features(i,49:50) = datain(i).optimal_params(1,2:3);
end
fullfeatures = zeros(length(datain)*275,50);
values = zeros(length(datain)*275,1);
bigi = 1;
for i = 1:length(datain)
    for log_i = 1:size(datain(i).time_logs,1)
    
        %dm plan
        flatdm = reshape(datain(i).dmplan.',1,[]);
        %temp features vector to allow for zeros easily
        tempfeatures =  [datain(i).time_logs(log_i,6:8), datain(i).bw, flatdm];
        fullfeatures(bigi,1:length(tempfeatures)) = tempfeatures;
        %add hpc params to features
        fullfeatures(bigi,46:50) = datain(i).time_logs(log_i,1:5);
        normalised_temp(log_i) = datain(i).time_logs(log_i,14);
        values(bigi) = datain(i).time_logs(log_i,14);
        bigi = bigi+1;
    end
    %norm_vals = [norm_vals',n
end

%x(find(x,1,'first'):find(x,1,'last'))

labels = categorical(labels);
