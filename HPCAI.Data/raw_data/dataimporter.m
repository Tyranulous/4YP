%dataimporter

folders = dir('./');

datain = struct();
datain.time_logs = [];
datain.dmplan = [];
datain.telescope_params=[];
datain.time_error = [];
datain.time = [];
datain.optimal_params = [];
datain.divint = [];
datain.bw = [];
datain.speedup = [];
datain.samples = [];
datain.chans = [];
datain.dedisp = [];


i = 3;
if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name))
    path=folders(i).name;
    datain(1).time_logs = time_log_importer(path);
    datain(1).dmplan = ddplan_reader(path);
    
    %move correct value for dedispersion time into .time
    if size(datain(1).dmplan,2) == 1
        datain(1).time = datain(1).time_logs(:,13);
    else
        datain(1).time = datain(1).time_logs(:,14);
    end
    
    %find lowest and error
    [best_time, min_loc] = min(datain(1).time(:));
    datain(1).optimal_params = datain(1).time_logs(min_loc,2:5);
    datain(1).time_error=datain(1).time(:) - best_time;
    
    %change time step to micro seconds
    temp_timestep = datain(1).time_logs(:,7) .* 1000000;
    datain(1).time_logs(:,7) = temp_timestep;
    
    %read in bandwidth
    [~,bwstarti] = regexp(path,'bw-');
    bwendi = regexp(path,'__tsamp');
    bw = path(bwstarti+1:bwendi-1);
    datain(1).bw = str2double(bw);
    
    %read in speedup and samples
    [datain(1).samples, datain(1).speedup] = txt_importer(path);
    
    datain(1).chans = datain(1).time_logs(1,8);
    
end


for i = 4:(length(folders)-2)
    if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name))
        path=folders(i).name;
        index = length(datain)+1;
        datain(index).time_logs = time_log_importer(path);
        datain(index).dmplan = ddplan_reader(path);
        
        %find lowest time to dedisperse and then caluclate differences to
        %that
        %move correct value for dedispersion time into .time
        if size(datain(index).dmplan,2) == 1
            datain(index).time = datain(index).time_logs(:,13);
        else
            datain(index).time = datain(index).time_logs(:,14);
        end
        
        %find lowest and error
        [best_time, min_loc] = min(datain(index).time(:));
        datain(index).optimal_params = datain(index).time_logs(min_loc,2:5);
        datain(index).time_error=datain(index).time(:) - best_time;
        
        
        %change time step to micro seconds
        temp_timestep = datain(index).time_logs(:,7) .* 1000000;
        datain(index).time_logs(:,7) = temp_timestep;
        
        %read in band width - fun regular expressions :)
        [~,bwstarti] = regexp(path,'bw-');
        bwendi = regexp(path,'__tsamp');
        bw = path(bwstarti+1:bwendi-1);
        datain(index).bw = str2double(bw);
        
        %read in speedup and samples
        [datain(index).samples, datain(index).speedup] = txt_importer(path);
        
        datain(index).chans = datain(index).time_logs(1,8);
    end
end


validation(1) = datain(34);
validation(2) = datain(35);

datain(35)=[];
datain(34)=[];

%remove errnoeous data :) - addjust this when new data is bad
datain(26) = [];
datain(25) = [];

features = zeros(length(datain),50);
%labels = zeros(length(datain),1);


for i = 1:length(datain)
    flatdm = reshape(datain(i).dmplan.',1,[]);
    tempfeatures =  [datain(i).time_logs(1,6:8), datain(i).bw, flatdm];
    features(i,1:length(tempfeatures)) = tempfeatures;
    %    labels(i) = datain(i).optimal_params(1,4);
    features(i,49:50) = datain(i).optimal_params(1,2:3);
end
fullfeatures = nan(length(datain)*275,50);
values = zeros(length(datain)*275,1);
bigi = 1;
norm_vals = [];
valls = [];
fullfeatures_nodm = zeros(length(datain)*27,9);
for i = 1:length(datain)
    
    for log_i = 1:size(datain(i).time_logs,1)
        
        %dm plan
        flatdm = reshape(datain(i).dmplan.',1,[]);
        
        %temp features vector to allow for zeros easily
        tempfeatures =  [datain(i).time_logs(log_i,6:8), datain(i).bw, flatdm];
        tempfeatures2 = [datain(i).time_logs(log_i,6:8), datain(i).bw,datain(i).time_logs(log_i,1:5)];
        fullfeatures(bigi,1:length(tempfeatures)) = tempfeatures;
        fullfeatures_nodm(bigi,1:length(tempfeatures2)) = tempfeatures2;
        
        %add hpc params to features
        fullfeatures(bigi,46:50) = datain(i).time_logs(log_i,1:5);
        %normalised_temp(log_i) = datain(i).time_logs(log_i,14);
        %values(bigi) = datain(i).time(log_i);
        bigi = bigi+1;
    end
    valls = [valls; datain(i).time./datain(i).time_logs(:,11)];
    norm_vals = [norm_vals; normalize(datain(i).time./datain(i).time_logs(:,11))];
    %norm_vals = [norm_vals',n
end

%normalize values
%norm_vals = normalize(values);

%x(find(x,1,'first'):find(x,1,'last'))

%labels = categorical(labels);
