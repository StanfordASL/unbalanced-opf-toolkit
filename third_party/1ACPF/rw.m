function rowindices = rw(varargin)

buses = varargin{1};
if size(varargin)<2
    phases = 1:3;
else
    phases = varargin{2};
end

tmp = bsxfun(@plus,3*(buses-1),phases');
rowindices = tmp(:);