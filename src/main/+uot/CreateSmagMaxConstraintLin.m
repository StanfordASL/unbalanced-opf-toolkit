function s_mag_max_constraint = CreateSmagMaxConstraintLin(p,q,s_mag_max,n_faces,tag)
s_mag_max_constraint_tag = sprintf('s_mag_max_constraint linearized %s',tag);
s_mag_max_constraint = uot.CreateComplexMagnitudeConstraintLin(p,q,s_mag_max,n_faces,s_mag_max_constraint_tag);
end