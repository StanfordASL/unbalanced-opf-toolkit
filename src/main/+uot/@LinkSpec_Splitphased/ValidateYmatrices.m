function ValidateYmatrices(obj)
% ValidateYmatrices Asserts that the Y matrices are valid

% All admittance matrices must be 2x2
validateattributes(obj.Y_from_siemens,{'double'},{'size',[2,2]});
validateattributes(obj.Y_to_siemens,{'double'},{'size',[2,2]});
validateattributes(obj.Y_shunt_from_siemens,{'double'},{'size',[2,2]});
validateattributes(obj.Y_shunt_to_siemens,{'double'},{'size',[2,2]});
end