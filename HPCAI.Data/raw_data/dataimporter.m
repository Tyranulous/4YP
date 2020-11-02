%dataimporter

folders = dir('./');

datain = struct();
datain.time_logs = [];
datain.dmplan = [];
datain.telescope_params=[];

i = 3;
    if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name))
        path=folders(i).name;
        temp = time_log_importer(path);
        datain(1).time_logs = temp;%time_log_importer(path);
        datain(1).dmplan = ddplan_reader(path);
    end
    
    
for i = 4:(length(folders)-2)
    if folders(i).isdir == 1 && not(strcmp('cf-1400__bw-__tsamp-0.000256__chans-4096',folders(i).name))
        path=folders(i).name;
        temp = time_log_importer(path);
        datain(length(datain)+1).time_logs = temp;%time_log_importer(path);
        datain(length(datain)).dmplan = ddplan_reader(path);
    end
end
