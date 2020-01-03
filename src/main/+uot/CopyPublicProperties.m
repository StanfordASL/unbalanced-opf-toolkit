function dest = CopyPublicProperties(dest,source)
% CopyPublicProperties copies the public properties from an object onto
% another
%   dest = CopyPublicProperties(dest,source)

assert(strcmp(class(dest),class(source)),'source and dest must have the same type.')

for property_name_c = properties(dest).'
    assert(numel(property_name_c) == 1)
    property_name = property_name_c{1};

    property_meta = findprop(dest,property_name);

    if strcmp(property_meta.GetAccess,'public') && strcmp(property_meta.SetAccess,'public') && ~property_meta.Dependent
        dest.(property_name) = source.(property_name);
    end
end
end