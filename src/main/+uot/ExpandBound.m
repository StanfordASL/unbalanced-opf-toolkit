function x_bound_expanded = ExpandBound(x,x_bound)
uot.VerifyBoundSize(x,x_bound);

x_size = size(x);
n_dim_x = ndims(x);

% We do it this way to get a vector of the same size as x_size
x_bound_size = arrayfun(@(dim_x) size(x_bound,dim_x),1:n_dim_x);

repeat_vector = x_size;
repeat_vector(x_bound_size == x_size) = 1;

x_bound_expanded = repmat(x_bound,repeat_vector);
end