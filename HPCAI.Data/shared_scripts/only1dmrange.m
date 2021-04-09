function output = only1dmrange(data)


locs = 0;
for t = 1:length(data)
    
    if size(data(t).dmplan,2) == 1
        if locs == 0
            locs = t;
        else
            locs(end+1) = t;
        end
    end
end

output = data(locs);
end