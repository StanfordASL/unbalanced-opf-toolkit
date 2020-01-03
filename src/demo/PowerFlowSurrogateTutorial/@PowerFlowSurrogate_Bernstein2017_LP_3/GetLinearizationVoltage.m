function [U_ast,T_ast] = GetLinearizationVoltage(obj)
% Returns the linearization voltage given by the choice of linearization_point
%
% Synopsis::
%
%   [U_ast,T_ast] = pf_surrogate.GetLinearizationVoltage
%
% Returns:
%
%   - **U_ast** (double) - :term:`Phase-consistent array` (n_bus,n_phase) with voltage magnitudes at the linearization point
%   - **T_ast** (double) - :term:`Phase-consistent array` (n_bus,n_phase) with voltage angles at the linearization point

% .. Line with 80 characters for reference #####################################


linearization_point = obj.linearization_point;

load_case = obj.opf_problem.load_case;
u_pcc_array = obj.opf_problem.u_pcc_array;
t_pcc_array = obj.opf_problem.t_pcc_array;

[U_ast, T_ast] = linearization_point.GetVoltageAtLinearizationPoint(load_case,u_pcc_array,t_pcc_array);
end