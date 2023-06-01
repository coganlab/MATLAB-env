function ras2brainshift(subj, brainshifted)
if brainshifted
    suffix = '_brainshifted';
else
    suffix = '';
end
data = get_RAS_brainshifted_data(subj, brainshifted);
fid = fopen(fullfile(get_recondir, subj, 'elec_recon', sprintf('%s_elec_locations_RAS%s.txt', subj, suffix)) ,'w');
for d = 1:numel(data.labelprefix)
    towrite = sprintf('%s %d %f %f %f %s %s\n', data.labelprefix{d}, data.labelnumber(d), data.xyz(d,1), data.xyz(d,2), data.xyz(d,3), data.hemisphere{d}, data.type{d});
    fprintf(fid, towrite);
end
fclose(fid);
end