function res = ApplyMapToCell(map,cell_array,varargin)
% ApplyMapToCell Shorthand to apply a map to a cell array
%   res = ApplyMapToCell(map,cell_array,'param1', val1, ...)
%   map is a function or containers.Map that takes an element of the cell
%   array as argument and returns a value
%   cell_array contains the elements to be mapped
%   Parameter-value pairs are passed directly to cellfun
%
%   See also cellfun

    res = cellfun(@(x) map(x),cell_array,varargin{:});
end