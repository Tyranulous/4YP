function matrix = nan_checker(matrix)
nans = isnan(matrix);
matrix(nans) = 1;
end