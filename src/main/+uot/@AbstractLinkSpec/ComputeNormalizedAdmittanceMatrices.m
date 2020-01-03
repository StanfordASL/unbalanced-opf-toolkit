function [Y_from,Y_to,Y_shunt_from,Y_shunt_to] = ComputeNormalizedAdmittanceMatrices(obj,u_nom_from_v,u_nom_to_v,s_base_va)
% Compute per-unit quantities
z_base_from_ohm = u_nom_from_v^2/s_base_va;
z_base_to_ohm = u_nom_to_v^2/s_base_va;
z_base_from_to_ohm = u_nom_from_v*u_nom_to_v/s_base_va;

% Normalization works differently depending on how link_spec was created
if obj.created_from_Y_link
    % Normalize all using z_base_from_ohm
    Y_from = obj.Y_from_siemens*z_base_from_ohm;
    Y_to = obj.Y_to_siemens*z_base_from_ohm;

    Y_shunt_from = obj.Y_shunt_from_siemens*z_base_from_ohm;
    Y_shunt_to = obj.Y_shunt_to_siemens*z_base_from_ohm;
else
    % Link elements are normalized with z_base_from_to_ohm
    Y_from = obj.Y_from_siemens*z_base_from_to_ohm;
    Y_to = obj.Y_to_siemens*z_base_from_to_ohm;

    % Shunt elements are normalized with the corresponding base
    Y_shunt_from = obj.Y_shunt_from_siemens*z_base_from_ohm;
    Y_shunt_to = obj.Y_shunt_to_siemens*z_base_to_ohm;
end
end