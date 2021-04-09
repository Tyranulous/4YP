function with_failsafes = full_failsafes(full)

%takes in full feature table and returns matrix with all 275 failsafe
%values
with_failsafes = [];
farr = table2array(full(:,1:end-1));

for t = 1:275:size(farr,1)
    % t = 1,276,551...etc
    
    locs = t:t+274;
    
    failsafes = farr(locs,4)';
    
    new_line = [farr(t+1,5:end),failsafes];
    with_failsafes = [with_failsafes; new_line];
end
