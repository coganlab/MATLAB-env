function arrvar = cell2arr(cellvar)

ntr = length(cellvar);
for i = 1:ntr
    N(i) = length(cellvar{i});
end
arrvar = zeros(ntr,max(N));
for i = 1:ntr
    arrvar(i,1:N(i)) = cellvar{i}';
end
