idx=iiBD;
Tidx=zeros(length(idx),1);
for iChan=1:length(idx);
    Tlab=contains(subj_labels{idx(iChan)},'T');
    if Tlab==1
        Tidx(iChan)=1;
    end
end
    