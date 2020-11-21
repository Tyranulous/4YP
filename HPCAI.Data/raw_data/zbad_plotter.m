figure(1)
hold on
a=1;
b=1;
c=1;
d=1;
for i=1:length(datain)
    if true %ne(i,26) && ne(i,25) %&& ne(i,7) && ne(i,8) && ne(i,9) && ne(i,10) && ne(i,30)
        i
        temp = datain(i).speedup;%datain(i).time(:) ./ datain(i).samples(:);
        
        if datain(i).chans == 512
            
            plotting512(1:length(temp),a) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,1);
            %plot(plotting512);
            a = a+1;
            
        end
        if datain(i).chans == 1024
            plotting1024(1:length(temp),b) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,2);
            %plot(plotting1024);
            b = b+1;
        end
        if datain(i).chans == 2048
            plotting2048(1:length(temp),c) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,3);
            %plot(plotting2048);
            c = c+1;
        end
        if datain(i).chans == 4096
            plotting4096(1:length(temp),d) = temp; %datain(i).time_logs(:,14) ./ datain(i).samples(:);
            %subplot(2,2,4);
            %plot(plotting4096);
            d = d+1;
        end
        plotting(1:length(temp),i) = temp;%datain(i).speedup(:) ./ datain(i).samples(:);
    end
   
end
nplot = normalize(plotting);
plot(nplot)


% nplotting4096 = normalize(plotting4096);
% nplotting2048 = normalize(plotting2048);
% nplotting1024 = normalize(plotting1024);
% nplotting512 = normalize(plotting512);
% 
% 
% 
% subplot(2,2,1)
% plot(nplotting512);
% subplot(2,2,2)
% plot(nplotting1024);
% subplot(2,2,3)
% plot(nplotting2048);
% subplot(2,2,4)
% plot(nplotting4096);

hold off