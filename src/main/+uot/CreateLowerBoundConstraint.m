function x_lower_bound = CreateLowerBoundConstraint(x,x_min,tag)
if ~isempty(x_min)
    x_min_expanded = uot.ExpandBound(x,x_min);
    % Consider only finite bounds
    x_lower_bound_indices = isfinite(x_min_expanded);

    x_lower_bound = x_min_expanded(x_lower_bound_indices) <= x(x_lower_bound_indices);
    x_lower_bound = uot.TagConstraintIfNonEmpty(x_lower_bound,tag);
else
    x_lower_bound = [];
end
end