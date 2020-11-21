function [samples,speedup] = txt_importer(path)

    %go_back = cd(path);
    %files = dir('./');
    
    samps_path = strcat(path,'/num_samples2.txt');
    speed_path = strcat(path,'/speedup2.txt');
    
    %strings = (275,2);
    
    fid = fopen(samps_path);
    %fgetl(fid);
    %fgetl(fid);
    line = fgetl(fid);
    i=1;
    while line ~= -1
     
        strings(i,:) = split(line,':');
        i = i+1;
        line = fgetl(fid);
    end
    fclose(fid);
    
    fid = fopen(speed_path);
   % fgetl(fid);
   % fgetl(fid);
    line = fgetl(fid);
    i=1;
    while line ~= -1
     
        strings2(i,:) = split(line,':');
        i = i+1;
        line = fgetl(fid);
    end
    
    
    samples = str2double(strings(:,2));
    speedup = str2double(strings2(:,2));
    %data(:,3) = data(:,2)./data(:,1);
    %data = strings;
    fclose(fid);
end