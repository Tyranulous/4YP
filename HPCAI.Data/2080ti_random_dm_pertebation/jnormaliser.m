%function to normalisea vector given the offest and divisor (or fa
function norm  = jnormaliser(input,offset,div)
if exist('input','var')
    if ~exist('offset','var') || ~exist('div','var')
        %warning('No offset or divisor was provided, defaulting to max and min')
        norm = (input - min(input))./(max(input) - min(input));
    else
        norm = (input-offset)./div;
    end
else
    error('No input vector supplied to normaliser function.')
end
end