function res = IsPositiveIntegerScalar(n)
res = isscalar(n) && n > 0 && floor(n) == n;
end