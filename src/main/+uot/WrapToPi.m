function res = WrapToPi(angle)
% WrapToPi Wraps an angle to [-pi,pi)
res = angle - 2*pi*floor((angle + pi)/(2*pi));
end