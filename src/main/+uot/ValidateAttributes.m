function ValidateAttributes(A,classes,attributes,varargin)
% ValidateAttributes Checks validity of an array
%   It generalizes the builtin validateattributes so that attributes can include
%   function handles. These function handles must take a single input and throw
%   an error if the array is invalid

is_function_handle = cellfun(@(x) isa(x,'function_handle'),attributes);

attributes_handle = attributes(is_function_handle);
attributes_others = attributes(~is_function_handle);

validateattributes(A,classes,attributes_others,varargin{:})

n_attributes_handle = numel(attributes_handle);

for i_attributes_handle = 1:n_attributes_handle
    f_handle = attributes_handle{i_attributes_handle};

    try
        f_handle(A);
    catch exception
       error('ValidateAttributes:HandleFailure','Validation function handle "%s" threw exception %s with message %s ',char(f_handle),exception.identifier,exception.message);
    end
end


end