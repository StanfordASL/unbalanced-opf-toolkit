function x_box_constraint = CreateBoxConstraint(x,x_min,x_max,tag)
x_upper_bound_tag = [tag,' upper bound'];
x_upper_bound = uot.CreateUpperBoundConstraint(x,x_max,x_upper_bound_tag);

x_lower_bound_tag = [tag,' lower bound'];
x_lower_bound = uot.CreateLowerBoundConstraint(x,x_min,x_lower_bound_tag);

x_box_constraint = [
    x_lower_bound;
    x_upper_bound];
end