% Displays model parameters as images

for i=1:skf.nmodels

    subplot(4,skf.nmodels,i*4-3);
    imagesc(skf.model{i}.A);
    colormap('hot');
    axis off;

    subplot(4,skf.nmodels,i*4-2);
    imagesc(skf.model{i}.Q);
    colormap('hot');
    axis off;

    subplot(4,skf.nmodels,i*4-1);
    imagesc(skf.model{i}.H);
    colormap('hot');
    axis off;

    subplot(4,skf.nmodels,i*4);
    imagesc(skf.model{i}.R);
    colormap('hot');
    axis off;
end
