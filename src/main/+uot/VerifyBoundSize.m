function VerifyBoundSize(x,x_bound)
if ~isempty(x_bound)
    x_size = size(x);
    n_dim_x = ndims(x);

    n_dim_x_bound = ndims(x_bound);

    assert(n_dim_x_bound <= n_dim_x_bound,'Number of dimension of x_bound must not be larger than x');

    % We do it this way to get a vector of the same size as x_size
    x_bound_size = arrayfun(@(dim_x) size(x_bound,dim_x),1:n_dim_x);

    assert(all(x_bound_size == 1 | x_bound_size == x_size),'For all dimensions, x_bound must have the same size as x or be a singleton');
end
end