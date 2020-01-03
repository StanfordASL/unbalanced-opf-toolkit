function res = Spblkdiag(varargin)

input_sparse = cellfun(@(x) sparse(x),varargin,'UniformOutput',false);

res = blkdiag(input_sparse{:});
end