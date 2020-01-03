function res = NumelMustBeLessThanOrEqual(val,n_val_max)
if numel(val) > n_val_max
    error('Number of elements must be less than %d',n_val_max);
end
res = true;
end