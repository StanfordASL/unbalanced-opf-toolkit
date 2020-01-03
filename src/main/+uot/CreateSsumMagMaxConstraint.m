% Based on Power Constraints 1
function s_sum_mag_max_constraint = CreateSsumMagMaxConstraint(p,q,s_sum_mag_max,tag)
% We sum accros phases (dimension 2)
p_sum = sum(p,2);
q_sum = sum(q,2);

s_sum_mag_max_constraint_tag = sprintf('s_sum_mag_max_constraint %s',tag);
s_sum_mag_max_constraint = uot.CreateComplexMagnitudeConstraint(p_sum,q_sum,s_sum_mag_max,s_sum_mag_max_constraint_tag);
end