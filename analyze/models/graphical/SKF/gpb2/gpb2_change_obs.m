function skf = skf_change_obs(skf,rows)
for i=1:skf.nmodels
    skf.model{i}.H = skf.model{i}.H(rows,:);
    skf.model{i}.R = skf.model{i}.R(rows,rows);
    skf.model{i}.ydims = length(rows);
end
skf.ydims = skf.model{1}.ydims;
