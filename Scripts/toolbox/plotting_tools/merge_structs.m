function structDefault = merge_structs(structDefault, structSpecified)
% returns a copy of the structDefault, but replaces fieldname-values with
% those in structSpecified.

if isempty(structSpecified)
    return;
end

fS = fieldnames(structSpecified);

for f = 1:numel(fS)
    if isfield(structDefault, fS{f}) && ~isempty(structSpecified.(fS{f}))
        structDefault.(fS{f}) = structSpecified.(fS{f});
    end
end

end