function [ddplan_out] = ddplan_reader(path,name)
%DDPLAN_READER reads ddplan.dat file in specified folder into an array
%   Detailed explanation goes here
try
    fullpath = strcat(path,'/',num2str(name),'.dat');
    fid = fopen(fullpath);
catch
    fullpath = strcat(path,'/ddplan.dat');
    fid = fopen(fullpath);
end

%strings = [];
try
    for i = 1:7
        line = fgetl(fid);
        line = line(2:end-1);
        
        strings(i,:) = split(line,',');
    end
    fclose(fid);
    ddplan_out = str2double(strings);
    temp = ddplan_out(7,:);
    ddplan_out(7,:) = ddplan_out(1,:);
    ddplan_out(1,:) = temp;
   ddplan_out(5,:) = ddplan_out(5,:).*ddplan_out(6,:);
   ddplan_out(6,:) = [];
   ddplan_out(2,:) = [];
    return
catch
    ddplan_out = [];
    return
end
end

