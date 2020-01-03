function X_ordered = PermuteNamedRows(X,original_row_name_cell,target_row_name_cell)
% Reorder named rows in an array
%
% X is a matrix whose rows are ordered following original_row_name_cell
% X_ordered contains the rows of X, reordered following target_row_name_cell
% Note: all elements of target_row_name_cell must appear on original_row_name_cell.


n_X = size(X,1);

validateattributes(original_row_name_cell,{'cell'},{'numel',n_X},mfilename,'original_row_name_cell',2);
validateattributes(target_row_name_cell,{'cell'},{},mfilename,'target_row_name_cell',3);

assert(numel(target_row_name_cell) <= n_X, 'target_row_name_cell may not have more elements than original_row_name_cell');

original_row_name_map = containers.Map(original_row_name_cell,1:n_X);

permuted_row_indices = uot.ApplyMapToCell(original_row_name_map,target_row_name_cell);

assert(all(~isnan(permuted_row_indices)),'original_row_name_cell does not contain all entries of target_row_name_cell');

X_ordered = X(permuted_row_indices,:,:);
end