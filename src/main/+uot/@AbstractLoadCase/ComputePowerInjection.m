function [P_inj_array,Q_inj_array] = ComputePowerInjection(obj,U_array,T_array)
% ComputePowerInjection implements the formula
% S = V.*conj(I)
V_array = uot.PolarToComplex(U_array,T_array);
I_inj_array = obj.ComputeCurrentInjection(U_array,T_array);

S_inj_array = V_array.*conj(I_inj_array);

P_inj_array = real(S_inj_array);
Q_inj_array = imag(S_inj_array);
end