function [data,rejected] = monotonicDmFinder(data)
%NORMALdMFINDER Summary of this function goes here
%   Detailed explanation goes here
index = 1;
rejected = data(1);
rejected(1) = [];
for t = 1:length(data)
    dmsize = size(data(index).dmplan,2);
    if dmsize ~= 1
        for i = 2:dmsize
            if data(index).dmplan(1,i-1) > data(index).dmplan(1,i)
                rejected(length(rejected)+1) = data(index);
                data(index) = [];
                index = index - 1;
                break;
            end
        end
    end
    index = index + 1;
        
end
if isempty(rejected(1))
    rejected(1) = [];
end
end

