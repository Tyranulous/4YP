%dataimporter

folders = dir('./');

testdatain = struct();
testdatain.time_logs = [];
testdatain.dmplan = [];
testdatain.telescope_params=[];
testdatain.time_error = [];
testdatain.time = [];
testdatain.optimal_params = [];
testdatain.divint = [];
testdatain.bw = [];
testdatain.speedup = [];
testdatain.samples = [];
testdatain.chans = [];
testdatain.dedisp = [];
testdatain.corrected_time = [];


i = 3;
if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name)) && not(strcmp('cf-290__bw-100__tsamp-64__chans-4096',folders(i).name))
    path=folders(i).name;
    testdatain(1).time_logs = time_log_importer(path);
    testdatain(1).dmplan = ddplan_reader(path);
    
    %move correct value for dedispersion time into .time
    if size(testdatain(1).dmplan,2) == 1
        testdatain(1).time = testdatain(1).time_logs(:,13);
    else
        testdatain(1).time = testdatain(1).time_logs(:,14);
    end
    
    %find lowest and error
    temp_best_finder = testdatain(1).time;
    temp_best_finder(temp_best_finder < 2e-5) = nan;
    testdatain(1).corrected_time = temp_best_finder(:);
    
    [best_time, min_loc] = min(temp_best_finder);
    testdatain(1).optimal_params = testdatain(1).time_logs(min_loc,2:5);
    testdatain(1).time_error=testdatain(1).time(:) - best_time;
    
%     [best_time, min_loc] = min(datain(1).time(:));
%         datain(1).optimal_params = datain(1).time_logs(min_loc,2:5);
%     datain(1).time_error=datain(1).time(:) - best_time;


    %change time step to micro seconds
    temp_timestep = testdatain(1).time_logs(:,7) .* 1000000;
    testdatain(1).time_logs(:,7) = temp_timestep;
    
    %read in bandwidth
    [~,bwstarti] = regexp(path,'bw-');
    bwendi = regexp(path,'__tsamp');
    bw = path(bwstarti+1:bwendi-1);
    testdatain(1).bw = str2double(bw);
    
        %read in speedup and samples
        testdatain(1).samples = testdatain(1).time_logs(:,11);
        [~,testdatain(1).speedup] = txt_importer(path);
    
    testdatain(1).chans = testdatain(1).time_logs(1,8);
    
end


for i = 4:(length(folders)-2)
    if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name)) && not(strcmp('cf-290__bw-100__tsamp-64__chans-4096',folders(i).name))
        path=folders(i).name;
        index = length(testdatain)+1;
        testdatain(index).time_logs = time_log_importer(path);
        testdatain(index).dmplan = ddplan_reader(path);
        
        %find lowest time to dedisperse and then caluclate differences to
        %that
        %move correct value for dedispersion time into .time
        if size(testdatain(index).dmplan,2) == 1
            testdatain(index).time = testdatain(index).time_logs(:,13);
        else
            testdatain(index).time = testdatain(index).time_logs(:,14);
        end
        
        temp_best_finder = testdatain(index).time;
        temp_best_finder(temp_best_finder < 2e-5) = nan;
        
        testdatain(index).corrected_time = temp_best_finder(:);
        
        [best_time, min_loc] = min(temp_best_finder);
        testdatain(index).optimal_params = testdatain(index).time_logs(min_loc,2:5);
        testdatain(index).time_error=testdatain(index).time(:) - best_time;
        
        %find lowest and error
%         [best_time, min_loc] = min(datain(index).time(:));
%         datain(index).optimal_params = datain(index).time_logs(min_loc,2:5);
%         datain(index).time_error=datain(index).time(:) - best_time;
        
        
        %change time step to micro seconds
        temp_timestep = testdatain(index).time_logs(:,7) .* 1000000;
        testdatain(index).time_logs(:,7) = temp_timestep;
        
        %read in band width - fun regular expressions :)
        [~,bwstarti] = regexp(path,'bw-');
        bwendi = regexp(path,'__tsamp');
        bw = path(bwstarti+1:bwendi-1);
        testdatain(index).bw = str2double(bw);
        
        %read in speedup and samples
        testdatain(index).samples = testdatain(index).time_logs(:,11);
        [~,testdatain(index).speedup] = txt_importer(path);
        
        testdatain(index).chans = testdatain(index).time_logs(1,8);
        
        
        % temporaty code to remove non full runs, will probably have to
        % change at some point in the future 
        if size(testdatain(index).time_logs,1) ~= 275
            testdatain(index) = [];
        end
    end
end

% for i = 1:length(datain)
%    datain(i).speedup;
% end

            
%validation(1) = datain(34);
%validation(2) = datain(35);

%datain(35)=[];
%datain(34)=[];

%remove errnoeous data :) - addjust this when new data is bad
%datain(26) = [];
%datain(25) = [];

features = zeros(length(testdatain),50);
%labels = zeros(length(datain),1);


for i = 1:length(testdatain)
    flatdm = reshape(testdatain(i).dmplan.',1,[]);
    tempfeatures =  [testdatain(i).time_logs(1,6:8), testdatain(i).bw, flatdm];
    features(i,1:length(tempfeatures)) = tempfeatures;
    %    labels(i) = datain(i).optimal_params(1,4);
    features(i,49:50) = testdatain(i).optimal_params(1,2:3);
end
fullfeatures = nan(length(testdatain)*275,50);
values = zeros(length(testdatain)*275,1);
bigi = 1;
norm_vals = [];
valls = [];
fullfeatures_nodm = zeros(length(testdatain)*27,9);
for i = 1:length(testdatain)
    
    for log_i = 1:size(testdatain(i).time_logs,1)
        
        %dm plan
        flatdm = reshape(testdatain(i).dmplan.',1,[]);
        
        %temp features vector to allow for zeros easily
        tempfeatures =  [testdatain(i).time_logs(log_i,6:8), testdatain(i).bw, flatdm];
        tempfeatures2 = [testdatain(i).time_logs(log_i,6:8), testdatain(i).bw,testdatain(i).time_logs(log_i,1:5)];
        fullfeatures(bigi,1:length(tempfeatures)) = tempfeatures;
        fullfeatures_nodm(bigi,1:length(tempfeatures2)) = tempfeatures2;
        
        %add hpc params to features
        fullfeatures(bigi,46:50) = testdatain(i).time_logs(log_i,1:5);
        %normalised_temp(log_i) = datain(i).time_logs(log_i,14);
        %values(bigi) = datain(i).time(log_i);
        bigi = bigi+1;
    end
    valls = [valls; testdatain(i).time./testdatain(i).time_logs(:,11)];
    norm_vals = [norm_vals; normalize(testdatain(i).time./testdatain(i).time_logs(:,11))];
    %norm_vals = [norm_vals',n
end

%normalize values
%norm_vals = normalize(values);

%x(find(x,1,'first'):find(x,1,'last'))

%labels = categorical(labels);
