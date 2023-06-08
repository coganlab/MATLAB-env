function skf = gpb2_set_initial(skf, X_0)
skf.X_0 = X_0;
skf.X(:,1) = skf.X_0;
for i=1:skf.nmodels
    skf.model{i}.X(:,1) = skf.X_0;
end

