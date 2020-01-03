function res = IsNumericRowOrEmptyVector(x)
res = isempty(x) || (isnumeric(x) && isrow(x));
end