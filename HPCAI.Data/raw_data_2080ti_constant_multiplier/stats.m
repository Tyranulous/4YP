%{
Todo:

Averages
variances 
look at word
neural nets 
so no biggie
I guess

:pain:


sort feature table for easier explainging and observation of patterns
%}
function [pct_data] = stats(model,data,table,type)

num_telescopes = length(data);

if exist('type','var')
    if type == 1
        [~,predictions] = predicter(model,table,num_telescopes);
        [pct_data] = best_v_predicted(predictions,data,num_telescopes);
        %plotter_parent(data, predictions, data, 5)
    elseif type == 2
        predictions = nn_predicter(model,table,num_telescopes);
        pct_data = best_v_predicted(predictions,data,num_telescopes);
    end

pct_data.mean_pred = mean(pct_data.pcts_pred);
pct_data.mean_271 = mean(pct_data.pcts_271);
pct_data.std_pred = std(pct_data.pcts_pred);
pct_data.std_271 = std(pct_data.pcts_271);
pct_data.max_pred = max(pct_data.pcts_pred);
pct_data.max_271 = max(pct_data.pcts_271);

plot_data(pct_data.pcts_pred,pct_data.pcts_271,pct_data.cfs,pct_data.hds_271,pct_data);
plot_data_with_medians(pct_data.pcts_pred,pct_data.pcts_271,pct_data.cfs,pct_data.hds_271,pct_data);
else
    error('No type was provided for the model, 1 = regression model, 2 = neural net')
end
end

function [flat_predictions, formatted_predictions] = predicter(model,holdback_table,num_telescopes)
formatted_predictions = NaN(275,num_telescopes);
try
    flat_predictions = model.predictFcn(holdback_table);
catch ME
    msg = 'probably passed in model incorrectly';
    causeException = MException('MyComponent:noSuchVariable',msg);
    ME = addCause(ME,causeException);
    rethrow(ME)
end

for i = 1:num_telescopes
   formatted_predictions(:,i) = flat_predictions(((i-1)*275+1):((i)*275));
end
end

%function [percents,reals,central_freqs,hashdefines] = best_v_predicted(predictions,data,num_telescopes)
function [output] = best_v_predicted(predictions,data,num_telescopes)
%calculates the differences between the best and the predicted value in
%real terms and as a percentage (per sample)

%hashdefines = struct('predicted',cell(1,num_telescopes),'best',cell(1,num_telescopes));
output = struct('pcts_pred',zeros(num_telescopes,1), ... 
                'pcts_271',zeros(num_telescopes,1), ...
                'hds_pred',zeros(num_telescopes,5), ...
                'hds_271',zeros(num_telescopes,5), ...
                'hds_best',zeros(num_telescopes,5), ...
                'cfs',zeros(num_telescopes,1), ...
                'correct_preds',0, ...
                'correct_271',0, ...
                'beat_271',0, ...
                'rmse_preds',0, ...
                'pcts_2nd_plan', zeros(num_telescopes,1), ...
                'med_pcts',zeros(num_telescopes,1) ...
                );                

%pre allocation
%percents = NaN(num_telescopes,1);
%reals = NaN(num_telescopes,1);
%central_freqs = NaN(num_telescopes,1);

sum_squared_error = 0;

for i = 1:num_telescopes
    %record central frequncies
    output.cfs(i) = data(i).time_logs(1,6);
    
    %calculate tps for telescope
    tps = data(i).corrected_time ...
        ./data(i).samples;
    
    %all predicted data
    %find location of the predicted best result
    [~,pred_min_loc] = min(predictions(:,i));
    %record time per sample value of this prediction
    predicted_tps = tps(pred_min_loc);
    %record correspongind hash define (and whether it ran in cache or not)
    output.hds_pred(i,:) = data(i).time_logs(pred_min_loc,1:5);
    
    %all best data
    %find location of best hashdefine and record value
    [best_tps,best_min_loc] = min(tps);
    %record corresponding hashdefine and whether it ran in cache or not
    output.hds_best(i,:) = data(i).time_logs(best_min_loc,1:5);
    
    %271 data
    tps_271 = tps(271);
    output.hds_271(i,:) = data(i).time_logs(271,1:5);
    
    % percent difference
    output.pcts_pred(i) = ((predicted_tps - best_tps) / best_tps) * 100;
    output.pcts_271(i) = ((tps_271 - best_tps) / best_tps) * 100;
   
    med_tps = median(tps);
    output.med_pcts(i) = ((med_tps - best_tps) / best_tps) * 100;
    %{
    if output.hds_pred(i,:) == output.hds_best(i,:)
        output.correct_preds = output.correct_preds + 1;
    end
    if output.hds_271(i,:) == output.hds_best(i,:)
        output.correct_271 = output.correct_271 + 1;
    end
    %}
    
    sum_squared_error = sum_squared_error + ...
                        sum((predictions(:,i) - data(i).corrected_time(:)).^2);
end
output.correct_preds = sum(output.pcts_pred == 0);
output.correct_271 = sum(output.pcts_271 == 0);

output.beat_271 = sum(output.pcts_271 > output.pcts_pred);

output.rmse_preds = sqrt(sum_squared_error / num_telescopes);

end
function plot_data_with_medians(pcts_pred,pcts_271,cfs,hds,struct)
figure('Name','with medians');
txt = sprintf('Mean percentage differece (for predicted) = %f \nStd = %f \nMax = %f',struct.mean_pred,struct.std_pred,struct.max_pred);
hold on;
h(1) = scatter(cfs,pcts_pred,'filled');
 h(2) = scatter(cfs,pcts_271);
h(3) = scatter(cfs,struct.med_pcts);
h(4) = scatter(2000,0,'w');
%set(h(2),'visible','off');
%set(h(3),'visible','off');
%l = plot([cfs';cfs'], [pcts_pred';pcts_271'], '-k');
legend(h(1:4),'Predicted performance','4 14 8 64 performance','medians',txt);
end
function plot_data(pcts_pred,pcts_271,cfs,hds,struct)
figure('Name','no medians');
txt = sprintf('Mean percentage differece (for predicted) = %f \nStd = %f \nMax = %f',struct.mean_pred,struct.std_pred,struct.max_pred);
hold on;
h(1) = scatter(cfs,pcts_pred,'filled');
 h(2) = scatter(cfs,pcts_271);
%h(3) = scatter(cfs,struct.med_pcts);
h(3) = scatter(2000,0,'w');
%set(h(2),'visible','off');
%set(h(3),'visible','off');
%l = plot([cfs';cfs'], [pcts_pred';pcts_271'], '-k');
legend(h(1:3),'Predicted performance','4 14 8 64 performance',txt);
end
function predictions = nn_predicter(net,table,num_telescopes)
[xv,~] = table2array_splitter(table);
%yv = nan_checker(yv);
flat_predictions = predict(net,xv);
predictions = zeros(275,num_telescopes);
for i = 1:num_telescopes
            predictions(:,i) = flat_predictions(((i-1)*275+1):((i)*275));
end

%plotter_parent(datain, predicted, holdback_datain, 5)
end
