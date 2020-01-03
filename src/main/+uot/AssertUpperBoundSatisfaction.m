function AssertUpperBoundSatisfaction(x_val,x_max,constraint_tol,tag)
if ~isempty(x_max)
    x_max_expanded = uot.ExpandBound(x_val,x_max);
    assert(all(x_val(:) <= x_max_expanded(:) +  constraint_tol),'Upper bound satisfaction failed for %s',tag);
end
end