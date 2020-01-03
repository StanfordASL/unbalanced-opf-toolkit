function [U_array,T_array] = ComputeVoltageEstimate(obj)
U_array = obj.ComputeVoltageMangitudeEstimate();

% The LP version cannot estimate phase, only voltage magnitude
T_array = [];
end