function norm  = jnormaliser2(input,offset,div)
if exist('input','var')
    if ~exist('offset','var') || ~exist('div','var')
        %warning('No offset or divisor was provided, defaulting to max and min')
        %norm = (input - min(input))./(max(input) - min(input));
        div = (max(input)-min(input))/2;
        offset = div + min(input);
        
        norm = (input-offset)./div;
    else
        norm = (input-offset)./div;
    end
else
    error('No input vector supplied to normaliser function.')
end
end