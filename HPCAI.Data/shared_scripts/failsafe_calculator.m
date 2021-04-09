function datain = failsafe_calculator(datain)
for t = 1:length(datain)
    
    m_power = 2.0;
    nchans = datain(t).time_logs(1,8);
    tsamp = (datain(t).time_logs(1,7))*1e-6;
    dm_step = datain(t).dmplan(1,:);
    
    fch1 = datain(t).time_logs(1,6) + datain(t).bw/2;
    foff = -datain(t).bw / nchans;
    dmshifts = zeros(nchans,1);
    for c = 1:nchans
        dmshifts(c) = 4148.741601 * ((1/(fch1+(foff*c))^m_power)-(1/fch1^m_power));
    end
    datain(t).failsafe = zeros(275,size(datain(t).dmplan,2));
    adjusted_dmtrials = datain(t).dmplan(4,:)./datain(t).dmplan(3,:);
    weightings = adjusted_dmtrials./sum(adjusted_dmtrials);
    datain(t).failsafe_scores = zeros(275,1);
    for hd = 1:275
        SDIVINDM = datain(t).time_logs(hd,5);
        SNUMREG = datain(t).time_logs(hd,3);
        SDIVINT = datain(t).time_logs(hd,4);
        
        for i = 1:size(datain(t).dmplan,2)
            shift_one = ( SDIVINDM - 1 ) * ( dm_step(i) / ( tsamp ) );
            
            shifta = floor((shift_one * dmshifts(nchans)) + ( SDIVINT - 1 ) * 2);
            
            lineshift = shifta + ( ( SNUMREG - 1 ) * 2 * SDIVINT );
            
            if (( ( SDIVINT - 1 ) + ( ( SDIVINDM - 1 ) * SDIVINT ) - 1 ) < lineshift) 
                datain(t).failsafe(hd,i) = 1;
            end
        end
        datain(t).failsafe_scores(hd) = sum(weightings.*datain(t).failsafe(hd,:));
    end
    
    
end