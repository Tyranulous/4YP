function [full_table, small_table, num_features] = combined_feature_tabler(data)

[full_table, num_features] = overall_feature_table_maker_ii(data);
% [full_table, num_features] = overall_feature_tabler_1dm(data);
locs_271 = 271:275:length(data)*275;
small_table = full_table(locs_271,4:end);

end