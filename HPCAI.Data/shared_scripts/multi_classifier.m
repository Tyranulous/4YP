function classifications = multi_classifier(table, top_hds)

%get training data in matrix
fom = table2array(table(:,end));
%initialise storage vector
classifications = zeros(length(fom)/275,1);

% define top 8 hashdefines to select from - maybe move this outside of the
% function?? to allow for 
if ~exist('top_hds','var')
%     top_hds = [271;254;269;190;12;270];
    error('no top hds defined');
end

for t = 0:275:length(fom)-1
    
    locs = t+1:t+275;
    
    [tempmin, location] = min(fom(locs));
    
    % check if best matches one of top hashdefines
    if sum(location == top_hds) == 1    
        classifications((t+275)/275) = location;
    
    else
        lessthan5pct = find(fom(locs) < 0.95 * tempmin);
        matched_hds = intersect(lessthan5pct,top_hds);
        if not(isempty(matched_hds))
            scores = fom(matched_hds + t);
            [mini,location2] = min(scores);
            classifications((t+275)/275) = matched_hds(location2);
        end            
    end
end

classifications = categorical(classifications);
end