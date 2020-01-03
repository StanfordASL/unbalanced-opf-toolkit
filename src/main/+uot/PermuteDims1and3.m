function res = PermuteDims1and3(x)
assert(ndims(x) <= 3,'Currently only arrays with 3 of fewer dimensions are supported.')

% yalmip throws error when permuting matrix
if (isa(x,'sdpvar') || isa(x,'ndsdpvar')) && ismatrix(x)
    size_x = [size(x),1];

    res = sdpvar(size_x(3),size_x(2),size_x(1),'full');

    % We need to transpose for it to work as intended
    % We need the if clause because othwerwise YALMIP throws an error
    if size_x(1) == 1
        res(1,:) = x.';
    else
        res(1,:,:) = x.';
    end
else
    res = permute(x,[3,2,1]);
end
end


