
X = cos(2*pi*60.*[1:1000]./1e3);

noise = randn(1,1000);

ind = 1;
for n = 0:0.1:1
   ind = ind+1;
   [fs_tmp,cs_tmp,f,var_tmp] = ftest(X+n*noise, [1,5,9], 1e3, 100, 32);
   fs(ind,:) = fs_tmp;  cs(ind,:) = cs_tmp; var(ind,:) = var_tmp;
   hire(ind,:) = real(cs_tmp)+2.*var_tmp;
   hiim(ind,:) = imag(cs_tmp)+2.*var_tmp;
   lore(ind,:) = real(cs_tmp)-2.*var_tmp;
   loim(ind,:) = imag(cs_tmp)-2.*var_tmp;
end

