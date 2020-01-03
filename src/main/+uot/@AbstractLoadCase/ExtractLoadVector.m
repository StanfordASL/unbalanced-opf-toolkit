% This function is static
function x = ExtractLoadVector(x_pre,x_phase,x_load_phase,n_time_step)
x = zeros(n_time_step,size(x_phase,2));
assert(sum(x_phase) == sum(x_load_phase),'x_phase and x_load_phase must have the same number of set phases.')
if ~isempty(x_pre)
    x(:,x_phase) = x_pre(:,x_load_phase);
end
% Shift time from dimension 1 to dimension 3
x = permute(x,[3,2,1]);
end
