%Tagging an empty constraint leads to an error, this checks if the
%constraint is empty before tagging it
function constraint_tagged = TagConstraintIfNonEmpty(constraint,tag)
if isempty(constraint)
    constraint_tagged = [];
else
    constraint_tagged = constraint:tag;
end
end
