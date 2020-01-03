% Note that b_norm needs to be multiplied with the desired radius
function [A,b_norm] = CreateRegularPolygon(n_face,varargin)
gamma = pi./(n_face);
if numel(varargin) == 0
    theta_0 = gamma;
elseif numel(varargin) == 1
    theta_0 = varargin{1};
else
    error('Too many input arguments.');
end

gamma_vec = theta_0 + [0:(n_face - 1)].'*2*pi/n_face;

A = [cos(gamma_vec),sin(gamma_vec)];
b_norm = repmat(cos(gamma),n_face,1);
end