function [r,theta] = ComplexToPolar(z)
    r = abs(z);
    theta = angle(z);
end