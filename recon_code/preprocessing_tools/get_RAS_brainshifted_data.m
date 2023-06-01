function elec = get_RAS_brainshifted_data(subj, brainshifted)

if brainshifted
    fn_end = '.PIAL';
else
    fn_end = '.POSTIMPLANT';
end
rasfn = fullfile(get_recondir, subj, 'elec_recon', [subj fn_end]);
elecfn = fullfile(get_recondir, subj, 'elec_recon', [subj '.electrodeNames']);

ras = scantext(rasfn, ' ', 2);
elecdata = scantext(elecfn, ' ', 2);

elec.xyz = cat(2, ras{1}, ras{2}, ras{3});
labels = elecdata{1};
for i = 1:numel(labels)
    mask_is_letter = isletter(labels{i});
    [ii1 jj1]=find(mask_is_letter==1);
    [ii2 jj2]=find(mask_is_letter==0);
    
    mask_is_letter1=ones(1,jj1(end));
    mask_is_letter2=zeros(1,jj2(end)-jj1(end));
    mask_is_letter=logical(cat(2,mask_is_letter1,mask_is_letter2));
    elec.labelprefix{i,1} = labels{i}(mask_is_letter);
    elec.labelnumber(i,1) = str2double(labels{i}(~mask_is_letter));
end

elec.isLeft = zeros(numel(elec.labelprefix), 1);
for e = 1:numel(elec.labelprefix)
    elec.labels{e,1} = [elec.labelprefix{e} num2str(elec.labelnumber(e))];
    if elec.labelprefix{e}(1) == 'L'
        elec.isLeft(e,1) = 1;
    end
end

elec.isLeft = elec.isLeft == 1; % just convert from double to logical
elec.hemisphere = elecdata{1,3};
elec.type = elecdata{1,2};