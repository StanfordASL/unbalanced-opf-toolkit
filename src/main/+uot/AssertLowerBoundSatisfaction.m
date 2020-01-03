function AssertLowerBoundSatisfaction(x_val,x_min,constraint_tol,tag)
if ~isempty(x_min)
    x_min_expanded = uot.ExpandBound(x_val,x_min);
    assert(all(x_min_expanded(:) - constraint_tol <= x_val(:)),'Lower bound satisfaction failed for %s',tag);
end
end