% This function is static
function VerifyLoadPhases(x,x_phase,name,n_time_step)
if ~isempty(x)
    assert(ismatrix(x),'Loads for a given bus must be a matrix')
    assert(size(x,1) == n_time_step, sprintf('Entries do not match n_time_step in %s (dimension 1).',name));
    assert(size(x,2) == size(x_phase,2),sprintf('Entries do not match phases in %s (dimension 2).',name));
    assert(all(all(x(:,~x_phase) == 0)),sprintf('Entries for missing phases must be zero in %s.',name));
end
end
