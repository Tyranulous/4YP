function [newdatain,newholdbackdatain] = holdback(data,percentage_held)
%randomly sample a percentage of all telescopes and remove them from
%datain and table
%return new tables and data ins
if ~exist('percentage_held', 'var')
    percentage_held = 10;
end
numt = length(data);
number_held = floor(numt*(percentage_held/100));
%randoms = randi(numt,number_held,1);
randoms = randperm(numt,number_held);

newholdbackdatain = data(randoms);
newdatain = data;
newdatain(randoms) = [];
end


