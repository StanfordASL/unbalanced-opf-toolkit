function s_mag_max_constraint = CreateSmagMaxConstraint(p,q,s_mag_max,tag)
s_mag_max_constraint_tag = sprintf('s_mag_max_constraint %s',tag);
s_mag_max_constraint = uot.CreateComplexMagnitudeConstraint(p,q,s_mag_max,s_mag_max_constraint_tag);
end