function Z_link_adjusted = AdjustZlink(Z_link, Z_link_norm_min)
% The optimization has problems when Z_link has a very small
% norm. In these cases, we multiply Z_link by a constant
% to increase its norm to Z_link_norm_min
%
% This function is static, protected

Z_link_norm = norm(Z_link);

if Z_link_norm < Z_link_norm_min
    Z_link_adjusted = Z_link*Z_link_norm_min/Z_link_norm;
else
    Z_link_adjusted = Z_link;
end
end