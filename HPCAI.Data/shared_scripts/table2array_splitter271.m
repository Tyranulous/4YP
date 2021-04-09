function [x,y] = table2array_splitter271(table)

try 
    sz = size(table,2);
catch ME
    error('wtf did you do, this aint right')
end
start = 1;
% if sz == 18
%     start = 2;
% elseif sz == 17
%     start = 1;
% else
%     error('oh dear, this is even worse than that other error you probably havent seen')
%     
% end

x = table2array(table(:,start:start+11));
y = table2array(table(:,start+12));
end