for i=1:length(datain)
    
        i
        %temp = datain(i).speedup;%
        if size(datain(i).dmplan,2) == 1
            time_col = 13;
        else
            time_col = 14;
        end
            
        
        temp = datain(i).time_logs(:,time_col) ./ datain(i).time_logs(:,11);% ./ datain(i).chans;
        
%         if datain(i).chans == 512
%             
%             plotting512(1:length(temp),a) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
%             %subplot(2,2,1);
%             %plot(plotting512);
%             
%             cf_mean512 = [cf_mean512; datain(i).time_logs(1,6),mean(temp)];
%             a = a+1;
%             
%         end
%         if datain(i).chans == 1024
%             plotting1024(1:length(temp),b) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
%             %subplot(2,2,2);
%             %plot(plotting1024);
%             
%              cf_mean1024 = [cf_mean1024; datain(i).time_logs(1,6),mean(temp)];
%             b = b+1;
%         end
%         if datain(i).chans == 2048
%             plotting2048(1:length(temp),c) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
%             %subplot(2,2,3);
%             %plot(plotting2048);
%             
%              cf_mean2048 = [cf_mean2048; datain(i).time_logs(1,6),mean(temp)];
%             c = c+1;
%         end
%         if datain(i).chans == 4096
%             plotting4096(1:length(temp),d) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
%             %subplot(2,2,4);
%             %plot(plotting4096);
%             
%              cf_mean4096 = [cf_mean4096; datain(i).time_logs(1,6),mean(temp)];
%             d = d+1;
%         end
        plotting(1:length(temp),i) = temp;%datain(i).speedup(:) ./ datain(i).samples(:);
    plotting(plotting < 2e-5) = nan;
    %normplot = normalize(plotting);
    if any(datain(i).time_logs(:,1) ~= 1)
    "!"
    end
    
end