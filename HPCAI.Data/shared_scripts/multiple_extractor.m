function newdata = multiple_extractor(data)
%MULTIPLE_EXTRACTOR Extracts data from new
%
newdata = data(1);

newdata(1) = [];
tempdata = newdata;
index = 1;
for i = 1:length(data) 
    %easy base case where we got all the data we're looking for
    if length(data(i).samples) == 2750
        for j = 1:10
            newdata(index).dmplan = data(i).dmplan{j};
            for k = 1:275
                l = (k-1)*10+j;
                newdata(index).time_logs(k,:) = data(i).time_logs(l,:);
                newdata(index).time(k,:) = data(i).time(l,:);
                newdata(index).samples(k,:) = data(i).samples(l,:);
                newdata(index).time_logs(k,:) = data(i).time_logs(l,:);
                newdata(index).corrected_time(k,:) = data(i).corrected_time(l,:);
            end
            newdata(index).central_freq = newdata(index).time_logs(1,6);
            newdata(index).bw = newdata(index).time_logs(1,9);
            newdata(index).chans = newdata(index).time_logs(1,8);
            index = index + 1;
        end
%     elseif mod(length(data(i).samples),275) == 0
%         len = (length(data(i).samples)/275);
%         for j = 1:len
%             newdata(index).dmplan = data(i).dmplan{j};
%             for k = 1:275
%                 l = (k-1)*len+j;
%                 newdata(index).time_logs(k,:) = data(i).time_logs(l,:);
%                 newdata(index).time(k,:) = data(i).time(l,:);
%                 newdata(index).samples(k,:) = data(i).samples(l,:);
%                 newdata(index).time_logs(k,:) = data(i).time_logs(l,:);
%                 newdata(index).corrected_time(k,:) = data(i).corrected_time(l,:);
%             end
%             newdata(index).central_freq = newdata(index).time_logs(1,6);
%             newdata(index).bw = newdata(index).time_logs(1,9);
%             newdata(index).chans = newdata(index).time_logs(1,8);
%             
%             index = index + 1;
%         end
        %else
        %I cba worrying about this for the moment
    else
        inputs = [data(i).inputs(:,1), data(i).inputs(:,3), data(i).inputs(:,4), data(i).inputs(:,2)];
        inputs_sum = sum(data(i).inputs,2);
        tracker = ones(1,10);
        for j = 1:length(data(i).time)
            switch sum(data(i).time_logs(j,6:9))
                case inputs_sum(1)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,1);
               
                case inputs_sum(2)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,2);
               
                case inputs_sum(3)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,3);
                    
                case inputs_sum(4)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,4);
                    
                case inputs_sum(5)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,5);
                    
                case inputs_sum(6)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,6);
                    
                case inputs_sum(7)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,7);
                    
                case inputs_sum(8)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,8);
                    
                case inputs_sum(9)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,9);
                    
                case inputs_sum(10)
                    [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,10);
                    
                otherwise
                    warning('hit the multiple extracter switch statement')
            end
            
        end
        k = 1;
        for m = 1:10
            try
                if length(tempdata(k).time) == 275
                    tempdata(k).dmplan = data(i).dmplan{k};
                    tempdata(k).central_freq = tempdata(k).time_logs(1,6);
                    tempdata(k).bw = tempdata(k).time_logs(1,9);
                    tempdata(k).chans = tempdata(k).time_logs(1,8);
                    k = k+1;
                else
                    tempdata(k) = [];
                end
            catch
                break
            end
                
        end
        if isempty(newdata)
            newdata = tempdata;
        else
        newdata(end+1:end+length(tempdata)) = tempdata;
        end
        index = index + length(tempdata);
        tempdata(:) = [];
    end
end
end
function [tempdata,tracker] = deepcopier(data,tempdata,tracker,i,j,c)

tempdata(c).time_logs(tracker(c),:) = data(i).time_logs(j,:);
tempdata(c).time(tracker(c),:) = data(i).time(j,:);
tempdata(c).samples(tracker(c),:) = data(i).samples(j,:);
tempdata(c).time_logs(tracker(c),:) = data(i).time_logs(j,:);
tempdata(c).corrected_time(tracker(c),:) = data(i).corrected_time(j,:);
tracker(c) = tracker(c)+1;
end
