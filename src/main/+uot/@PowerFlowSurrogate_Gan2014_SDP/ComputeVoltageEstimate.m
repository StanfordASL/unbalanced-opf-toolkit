function [U_array,T_array] = ComputeVoltageEstimate(obj)
V_array = obj.RecoverVI();

[U_array,T_array] = uot.ComplexToPolar(V_array);
end