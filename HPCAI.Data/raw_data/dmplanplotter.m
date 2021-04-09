function dmplanplotter(data)
    figure('Name','dmplans');
    
    for i = 1:10:length(data)
        for t = i:i+9
            try
                if ~isempty(data(t).time_error)
                    dmplan = data(t).dmplan;
                
                    plot(dmplan(2,:),dmplan(1,:));
                    drawnow
                    hold on
                end
            catch
                fprintf('ran out of telescopes :)')
            end
        end
        hold off
    input('');
    end
hold off    
end