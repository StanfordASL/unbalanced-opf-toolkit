function gamma_mat = GetGammaMatrix()
% This function is static
% Defined between eq 11 and 12 in Gan2014

% Note: this probably does not work for negatively sequenced networks
% Possibly replace gamma_mat with [v_flat, v_flat_1, v_flat_2] where
% _x means cyclic shifting

alpha_val = exp(-2i*pi/3);

gamma_mat = [
    1,alpha_val^2,alpha_val;
    alpha_val,1,alpha_val^2;
    alpha_val^2,alpha_val,1;
    ];
end