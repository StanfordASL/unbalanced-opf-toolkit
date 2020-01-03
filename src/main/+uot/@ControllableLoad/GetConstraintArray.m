function constraint_array = GetConstraintArray(obj)
s_base_va = obj.opf_problem.load_case.network.spec.s_base_va;

linearize_magnitude_constraints = obj.opf_problem.linearize_magnitude_constraints;
n_faces = obj.opf_problem.n_faces;

p = obj.decision_variables.p;
q = obj.decision_variables.q;

name = obj.spec.name;

p_min = obj.spec.p_min_va/s_base_va;
p_max = obj.spec.p_max_va/s_base_va;
p_box_tag = sprintf('%s: p_box_constraint',name);
p_box_constraint = uot.CreateBoxConstraint(p,p_min,p_max,p_box_tag);

q_min = obj.spec.q_min_va/s_base_va;
q_max = obj.spec.q_max_va/s_base_va;
q_box_tag = sprintf('%s: q_box_constraint',name);
q_box_constraint = uot.CreateBoxConstraint(q,q_min,q_max,q_box_tag);

power_factor_min_constraint = uot.CreatePowerFactorMinConstraint(p,q,obj.spec.power_factor_min);

power_factor_max_constraint = uot.CreatePowerFactorMaxConstraint(p,q,obj.spec.power_factor_max);

s_mag_max = obj.spec.s_mag_max_va/s_base_va;
s_mag_max_constraint_tag = name;
if linearize_magnitude_constraints
    s_mag_max_constraint = uot.CreateSmagMaxConstraintLin(p,q,s_mag_max,n_faces,s_mag_max_constraint_tag);
else
    s_mag_max_constraint = uot.CreateSmagMaxConstraint(p,q,s_mag_max,s_mag_max_constraint_tag);
end

s_sum_mag_max = obj.spec.s_sum_mag_max_va/s_base_va;
s_sum_mag_max_constraint_tag = name;
if linearize_magnitude_constraints
    s_sum_mag_max_constraint = uot.CreateSsumMagMaxConstraintLin(p,q,s_sum_mag_max,n_faces,s_sum_mag_max_constraint_tag);
else
    s_sum_mag_max_constraint = uot.CreateSsumMagMaxConstraint(p,q,s_sum_mag_max,s_sum_mag_max_constraint_tag);
end

p_delta_max = obj.spec.p_delta_max_va/s_base_va;
% We take the first derivative across discrete time (dimension 1).
p_delta = diff(p,1,1);
p_delta_max_constraint_tag = sprintf('%s: p_delta_max',name);
p_delta_max_constraint = uot.CreateBoxConstraint(p_delta,-p_delta_max,p_delta_max,p_delta_max_constraint_tag);

q_delta_max = obj.spec.q_delta_max_va/s_base_va;
% We take the first derivative across discrete time (dimension 1).
q_delta = diff(q,1,1);
q_delta_max_constraint_tag = sprintf('%s: q_delta_max',name);
q_delta_max_constraint = uot.CreateBoxConstraint(q_delta,-q_delta_max,q_delta_max,q_delta_max_constraint_tag);

constraint_array = [ ...
    p_box_constraint;
    q_box_constraint;
    power_factor_min_constraint;
    power_factor_max_constraint;
    s_mag_max_constraint;
    s_sum_mag_max_constraint;
    p_delta_max_constraint;
    q_delta_max_constraint;
    ];
end


