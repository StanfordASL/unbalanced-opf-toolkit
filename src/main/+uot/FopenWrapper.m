function file_id = FopenWrapper(varargin)

[file_id,errmsg] = fopen(varargin{:});

if file_id < 0
   error('Could not open file %s.',errmsg);
end
end