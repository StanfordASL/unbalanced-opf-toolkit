function res = VoltageIsPositivelySequenced(z)
% VoltageIsPositivelySequenced checks if voltages are possitively sequenced
% (i.e., separated by a positive angle like [0, -120, 120]).
%   res = VoltageIsPositivelySequenced(v) where v is a complex voltage
%   vector
%   res = VoltageIsPositivelySequenced(t) where t is a vector with angles

% Vector must have 3 5 phases
assert(size(z,2) == 3);

if any(imag(z) ~= 0)
    t = angle(z);
else
    t = z;
end

delta = uot.Delta();

% We add the first element to close the cycle
angle_diff = uot.WrapToPi(delta*t.');

res = all(angle_diff > 0);
end