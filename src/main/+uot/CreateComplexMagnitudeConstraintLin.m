% Creates a linear constraint that approximates abs(x_re + i x_im) <=
% x_mag_max by using the an inner regular polygon inside the circle of
% radius x_mag_max
function x_mag_max_constraint = CreateComplexMagnitudeConstraintLin(x_re,x_im,x_mag_max,n_faces,tag)
if ~isempty(x_mag_max)
    assert(all(size(x_re) == size(x_im)));
    assert(all(x_mag_max(:) >= 0))

    x_mag_max_expanded = uot.ExpandBound(x_re,x_mag_max);

    % Consider only finite bounds
    constraint_indices = isfinite(x_mag_max_expanded);

    x_re_vec = x_re(constraint_indices);
    x_im_vec = x_im(constraint_indices);

    x_mag_max_expanded_vec = x_mag_max_expanded(constraint_indices);

    [A,b_norm] = uot.CreateRegularPolygon(n_faces);

    x_mag_max_constraint = A*[x_re_vec(:).';x_im_vec(:).'] <=  b_norm*x_mag_max_expanded_vec(:).';

    x_mag_max_constraint = uot.TagConstraintIfNonEmpty(x_mag_max_constraint,tag);
else
    x_mag_max_constraint = [];
end
end