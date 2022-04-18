function subj_type = list_recon_subjs_by_elec_type()
% etype = 'DGS'
subjs = list_recon_subjs;
subj_type = [subjs cellfun(@(a) get_elec_type(a), subjs, 'un', 0)];
    
end