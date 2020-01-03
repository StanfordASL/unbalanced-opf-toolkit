function CheckBoundSize(x)
if ~any(size(x,2) == [0,1,3])
    error('Second dimension must be one or three if not empty')
end
end