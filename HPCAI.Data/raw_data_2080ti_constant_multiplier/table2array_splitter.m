function [x,y] = table2array_splitter(table)

try 
    sz = size(table,2);
catch ME
    error('wtf did you do, this aint right')
end

if sz == 16
    start = 2;
elseif sz == 15
    start = 1;
else
    error('oh dear, this is even worse than that other error you probably havent seen')
    
end

x = table2array(table(:,start:start+13));
y = table2array(table(:,start+14));
end