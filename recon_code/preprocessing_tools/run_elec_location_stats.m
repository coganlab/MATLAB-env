function run_elec_location_stats(subj,options)

arguments
    subj
    options.mm = [1 3 5 7 9 10]
    options.parcs = {'aparc.BN_atlas+aseg.mgz','aparc.a2009s+aseg.mgz','aparc+aseg.mgz'};
end

etype = get_elec_type(subj);

parcs = options.parcs;
mm = options.mm;
for p = 1:numel(parcs)
    for m = 1:numel(mm)
        if contains(etype, 'G')
            elec_location_stats(subj, parcs{p}, mm(m), 1);
        end
        elec_location_stats(subj, parcs{p}, mm(m), 0);
    end
end

end