function AssertIsInstance(input,class_name)
if ~isempty(input)
    assert(isa(input,class_name),'AssertIsInstance Error: object is of class %s, not a %s object.', class(input),class_name);
end
end