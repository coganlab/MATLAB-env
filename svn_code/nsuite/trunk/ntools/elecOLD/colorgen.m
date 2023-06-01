function colormatrix = colorgen(sub2,hemi)
nyumc;
[vertices2, label, colortable]=read_annotation([NYUMCDIR '/' sub2 '/label/' hemi '.aparc.a2009s.annot']);

colormatrix=zeros(length(label),3);
for A=1:length(label)
    clear dummy*
    labeltemp=label(A);
    dummy=(colortable.table(:,5) == labeltemp);
    dummy2=colortable.table(dummy,:);
    colormatrix(A,:)=dummy2(1:3);
end
colormatrix=colormatrix./255;

end