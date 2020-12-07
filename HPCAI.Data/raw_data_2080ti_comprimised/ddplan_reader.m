function [ddplan_out] = ddplan_reader(path)
%DDPLAN_READER reads ddplan.dat file in specified folder into an array
%   Detailed explanation goes here
fullpath = strcat(path,'/ddplan.dat');
fid = fopen(fullpath);
%strings = [];

    for i = 1:6
        line = fgetl(fid);
        line = line(2:end-1);
        
        strings(i,:) = split(line,',');
    end
    fclose(fid);
    ddplan_out = str2double(strings);
    
   ddplan_out(5,:) = ddplan_out(5,:).*ddplan_out(6,:);
   ddplan_out(6,:) = [];
   ddplan_out(2,:) = [];
    return
end

