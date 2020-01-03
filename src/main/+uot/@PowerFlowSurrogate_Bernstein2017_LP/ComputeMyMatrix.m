function M_y = ComputeMyMatrix(network,V_ast_nopcc_stack)
% |static|, |private| Computes the M_y matrix defined below eq. 7 in :cite:`Bernstein2017`
%
% Synopsis::
%
%   M_y = ComputeMyMatrix(network,V_ast_nopcc_stack)
%
% Arguments:
%   V_ast_nopcc_stack (double): :term:`phase-consistent stack<Phase-consistent stack>` with complex voltages at the linearization point (excluding those for the |pcc|)
%
% Returns:
%
%   - **M_y** (double) - M_y matrix

% .. Line with 80 characters for reference #####################################

Ybus_NN_inv = inv(network.Ybus_NN);
M_y_pre = Ybus_NN_inv*inv(diag(conj(V_ast_nopcc_stack)));

M_y = [M_y_pre,-1i*M_y_pre];
end