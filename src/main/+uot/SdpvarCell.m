function sdpvar_cell = SdpvarCell(M,N,varargin)
assert(all(size(M) == size(N)));

sdpvar_cell_ref_pre = sdpvar(M(:),N(:),varargin{:});
sdpvar_cell = reshape(sdpvar_cell_ref_pre,size(M));
end