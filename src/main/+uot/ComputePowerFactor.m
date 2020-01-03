function res = ComputePowerFactor(P,Q)
S = P + 1i*Q;

if abs(S) > 0
   res = P./abs(S);
else
   res = 1;
end
end