function array_of_class = FilterArrayByClass(array,class)
% FilterArrayByClass Returns the elements in array that are of class
%   array_of_class = FilterArrayByClass(array,class)
%   This is typically useful for instances of matlab.mixin.Heterogeneous

validateattributes(class,{'char'},{'scalartext'})

array_is_of_class = arrayfun(@(element) isa(element,class),array);

array_of_class = array(array_is_of_class);
end