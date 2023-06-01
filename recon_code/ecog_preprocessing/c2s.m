function x = c2s(cell_or_struct)
if iscell(cell_or_struct)
    x = cellfun(@(a) a, cell_or_struct);
end
if isstruct(cell_or_struct)
    x = arrayfun(@(a) a, cell_or_struct, 'un', 0);
end