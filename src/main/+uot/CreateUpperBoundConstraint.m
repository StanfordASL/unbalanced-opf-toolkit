function x_upper_bound = CreateUpperBoundConstraint(x,x_max,tag)
if ~isempty(x_max)
    x_max_expanded = uot.ExpandBound(x,x_max);
    % Consider only finite bounds
    x_upper_bound_indices = isfinite(x_max_expanded);

    x_upper_bound = x(x_upper_bound_indices) <= x_max_expanded(x_upper_bound_indices);
    x_upper_bound = uot.TagConstraintIfNonEmpty(x_upper_bound,tag);
else
    x_upper_bound = [];
end
end