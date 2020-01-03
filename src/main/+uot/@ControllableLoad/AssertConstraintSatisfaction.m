function AssertConstraintSatisfaction(obj)
s_base_va = obj.opf_problem.s_base_va;

constraint_tol_va = obj.constraint_tol*s_base_va;

[p_val,q_val] = obj.GetValue();
p_val_va = p_val*s_base_va;
q_val_va = q_val*s_base_va;

assert(size(p_val_va,2) == obj.spec.n_phase)
assert(size(q_val_va,2) == obj.spec.n_phase)

tag = obj.spec.name;

uot.AssertLowerBoundSatisfaction(p_val_va,obj.spec.p_min_va,constraint_tol_va,tag);
uot.AssertUpperBoundSatisfaction(p_val_va,obj.spec.p_max_va,constraint_tol_va,tag);

uot.AssertLowerBoundSatisfaction(q_val_va,obj.spec.q_min_va,constraint_tol_va,tag);
uot.AssertUpperBoundSatisfaction(q_val_va,obj.spec.q_max_va,constraint_tol_va,tag);

power_factor_val = uot.ComputePowerFactor(p_val_va,q_val_va);
uot.AssertLowerBoundSatisfaction(power_factor_val,obj.spec.power_factor_min,obj.constraint_tol,tag);
uot.AssertUpperBoundSatisfaction(power_factor_val,obj.spec.power_factor_max,obj.constraint_tol,tag);

% Note that constraints on s_mag_max_va and s_sum_mag_max_va must also be
% satisified if we linearized the constraints because we are using an
% inner approximation.
s_mag_val_va = abs(p_val_va + 1i*q_val_va);
uot.AssertUpperBoundSatisfaction(s_mag_val_va,obj.spec.s_mag_max_va,constraint_tol_va,tag);

% We sum across phases (dimension 2)
s_sum_va = sum(p_val_va + 1i*q_val_va,2);
s_sum_mag_va = abs(s_sum_va);
uot.AssertUpperBoundSatisfaction(s_sum_mag_va,obj.spec.s_sum_mag_max_va,constraint_tol_va,tag);

p_delta_val_va = diff(p_val_va,1,1);
uot.AssertUpperBoundSatisfaction(p_delta_val_va,obj.spec.p_delta_max_va,constraint_tol_va,tag);

q_delta_val_va = diff(q_val_va,1,1);
uot.AssertUpperBoundSatisfaction(q_delta_val_va,obj.spec.q_delta_max_va,constraint_tol_va,tag);
end