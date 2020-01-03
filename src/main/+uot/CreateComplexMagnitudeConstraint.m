% Creates a constraint abs(x_re + i x_im) <= x_mag_max
function x_mag_max_constraint = CreateComplexMagnitudeConstraint(x_re,x_im,x_mag_max,tag)
if ~isempty(x_mag_max)
    assert(all(size(x_re) == size(x_im)));

%     x_mag = sdpvar(size(x_re,1),size(x_re,2));
%
%     for i_x_mag = 1:numel(x_mag)
%         x_mag(i_x_mag) = norm([x_re(i_x_mag),x_im(i_x_mag)],2);
%     end

    x_mag = abs(x_re + 1i*x_im);

    x_mag_max_constraint = uot.CreateUpperBoundConstraint(x_mag,x_mag_max,tag);
else
    x_mag_max_constraint = [];
end


end