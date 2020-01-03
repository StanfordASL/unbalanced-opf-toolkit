function res = IsCharString(str)
res = isa(str,'char') && size(str,1) == 1;
end