function combineannot(subj)
global RECONDIR;

annots = {
    '%sh.BA_exvivo.annot'
    '%sh.BA_exvivo.thresh.annot'
    '%sh.aparc.DKTatlas.annot'
    '%sh.aparc.a2009s.annot'
    '%sh.aparc.annot'
    };

for i = 1:numel(annots)
    [annotL.vertices, annotL.label, annotL.colortable] = read_annotation(fullfile(RECONDIR, subj, 'label', sprintf(annots{i}, 'l')));
    [annotR.vertices, annotR.label, annotR.colortable] = read_annotation(fullfile(RECONDIR, subj, 'label', sprintf(annots{i}, 'r')));
    annotB.vertices = cat(1, annotL.vertices, annotR.vertices);
    annotB.label = cat(1, annotL.label, annotR.label);
    annotB.colortable = annotL.colortable; 
    assert(isequal(annotL.colortable, annotR.colortable));
    annot = annotB;
    save(fullfile(RECONDIR, subj, 'label', [sprintf(annots{i}, 'b') '.mat']), 'annot');
end

end