%dataimporter
addpath('H:\OneDrive\Documents\Work\Machine Learning\4YP\HPCAI.Data\shared_scripts')
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
datain.corrected_time = [];

%legacy (and kinda dumb) code
%{
% i = 3;
% if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name)) && not(strcmp('cf-290__bw-100__tsamp-64__chans-4096',folders(i).name))
%     path=folders(i).name;
%     datain(1).time_logs = time_log_importer(path);
%     datain(1).dmplan = ddplan_reader(path);
%     
%     %move correct value for dedispersion time into .time
%     if size(datain(1).dmplan,2) == 1
%         datain(1).time = datain(1).time_logs(:,13);
%     else
%         datain(1).time = datain(1).time_logs(:,14);
%     end
%     
%     %find lowest and error
%     temp_best_finder = datain(1).time;
%     temp_best_finder(temp_best_finder < 2e-5) = nan;
%     datain(1).corrected_time = temp_best_finder(:);
%     
%     [best_time, min_loc] = min(temp_best_finder);
%     datain(1).optimal_params = datain(1).time_logs(min_loc,2:5);
%     datain(1).time_error=datain(1).time(:) - best_time;
%     
% %     [best_time, min_loc] = min(datain(1).time(:));
% %         datain(1).optimal_params = datain(1).time_logs(min_loc,2:5);
% %     datain(1).time_error=datain(1).time(:) - best_time;
% 
% 
%     %change time step to micro seconds
%     temp_timestep = datain(1).time_logs(:,7) .* 1000000;
%     datain(1).time_logs(:,7) = temp_timestep;
%     
%     %read in bandwidth
%     [~,bwstarti] = regexp(path,'bw-');
%     bwendi = regexp(path,'__tsamp');
%     bw = path(bwstarti+1:bwendi-1);
%     datain(1).bw = str2double(bw);
%     
%         %read in speedup and samples
%         datain(1).samples = datain(1).time_logs(:,11);
%         [~,datain(1).speedup] = txt_importer(path);
%     
%     datain(1).chans = datain(1).time_logs(1,8);
%     
% end
%}

for i = 3:(length(folders)-2)
    if folders(i).isdir == 1% && not(strcmp('cf-290__bw-100__tsamp-64__chans-4096',folders(i).name))
        path=folders(i).name;
        if i == 3 || isempty(datain(1).time_error)%this will probably fall over if the i = 3 data point is a dud... hopefully fixed that :0
            index = 1;
        else 
            index = length(datain)+1;
        end
        
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
        
        temp_best_finder = datain(index).time;
        temp_best_finder(temp_best_finder < 2e-5) = nan;
        
        datain(index).corrected_time = temp_best_finder(:);
        
        [best_time, min_loc] = min(temp_best_finder);
        datain(index).optimal_params = datain(index).time_logs(min_loc,2:5);
        datain(index).time_error=datain(index).time(:) - best_time;
        
        %find lowest and error
%         [best_time, min_loc] = min(datain(index).time(:));
%         datain(index).optimal_params = datain(index).time_logs(min_loc,2:5);
%         datain(index).time_error=datain(index).time(:) - best_time;
        
        
        %change time step to micro seconds
        temp_timestep = datain(index).time_logs(:,7) .* 1000000;
        datain(index).time_logs(:,7) = temp_timestep;
        
        %read in band width - fun regular expressions :)
        [~,bwstarti] = regexp(path,'bw-');
        bwendi = regexp(path,'__tsamp');
        bw = path(bwstarti+1:bwendi-1);
        datain(index).bw = str2double(bw);
        
        %read in speedup and samples
        datain(index).samples = datain(index).time_logs(:,11);
        [~,datain(index).speedup] = txt_importer(path);
        
        datain(index).chans = datain(index).time_logs(1,8);
        
        
        % temporaty code to remove non full runs, will probably have to
        % change at some point in the future 
        if size(datain(index).time_logs,1) ~= 275
            if ~exist('lessthan275', 'var')
                lessthan275(1) = datain(index);
            else
                lessthan275(length(lessthan275)+1) = datain(index);
            end
            %datain(index) = [];
            
        end
    end
end

%clean up
clear index i bwstarti bw temp_timestep temp_best_finder path min_loc best_time bwendi folders
 