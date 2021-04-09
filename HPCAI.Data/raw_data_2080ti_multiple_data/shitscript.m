function shitscript(datain)
for i = 1:length(datain)
    check = datain(i).samples(:);
    if ismember(check,0)
        'oops'
    end
    check = datain(i).corrected_time(:);
        if ismember(check,0)
        'oops'
    end
end