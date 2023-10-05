function run_elec_location_stats(subj,options)

arguments
    subj
    options.mm = [1 3 5 7 9 10]
end

etype = get_elec_type(subj);

parcs = {'aparc+aseg.mgz', 'aparc.a2009s+aseg.mgz'};
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