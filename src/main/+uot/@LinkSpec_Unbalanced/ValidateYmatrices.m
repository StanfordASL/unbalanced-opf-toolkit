function ValidateYmatrices(obj)
% ValidateYmatrices Asserts that the Y matrices are valid

n_phase = sum(obj.phase);

% All admittance matrices must be 2x2
validateattributes(obj.Y_from_siemens,{'double'},{'size',[n_phase,n_phase]});
validateattributes(obj.Y_to_siemens,{'double'},{'size',[n_phase,n_phase]});
validateattributes(obj.Y_shunt_from_siemens,{'double'},{'size',[n_phase,n_phase]});
validateattributes(obj.Y_shunt_to_siemens,{'double'},{'size',[n_phase,n_phase]});
end