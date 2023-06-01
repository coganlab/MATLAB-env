% dumpPCAParams(filename_root, PCAParams, ver2_flag)
%
% dumps textfile versions of PCAParams and a mat file version
% of PCAParams to disk.  if ver2_flag is 1, writes 3 files for
% rtbci2 code
%
% ver 1 mode: writes filename_root.pca.txt (all three concatenated)
% ver 2 mode: writes filename_root.pca_u.txt
%                    filename_root.pca_mean.txt
%                    filename_root.pca_base.txt
%
% also writes filename_root.pcaparams.mat
%
% in version 1 mode, the first two lines that precede each csv data block
% define the dimensions of the data
%
function dumpPCAParams(filename_root, PCAParams, vers_2)

% the old trainer/decoder used one file with all params, if the last arg
% is not supplied, write out in that format
if (nargin == 2)
    fname = [filename_root '.pca.txt'];
    fid = fopen(fname, 'w');
    fprintf(fid,'%d\n%d\n', size(PCAParams.U,1), size(PCAParams.U,2));
    fclose(fid);

    dlmwrite(fname, PCAParams.U, '-append', 'precision', '%.6f');

    fid = fopen(fname, 'a');
    fprintf(fid,'%d\n%d\n', size(PCAParams.Base,1), size(PCAParams.Base,2));
    fclose(fid);

    dlmwrite(fname, PCAParams.Base, '-append', 'precision', '%.6f');

    fid = fopen(fname, 'a');
    fprintf(fid,'%d\n%d\n', size(PCAParams.Mean,1), size(PCAParams.Mean,2));
    fclose(fid);

    dlmwrite(fname, PCAParams.Mean, '-append', 'precision', '%.6f');
else
    % the new trainer/decoder uses three separate files

    dlmwrite([filename_root '.pca_u.txt'], PCAParams.U, 'precision', '%.6f');
    dlmwrite([filename_root '.pca_mean.txt'], PCAParams.Mean, 'precision', '%.6f');
    dlmwrite([filename_root '.pca_base.txt'], PCAParams.Base, 'precision', '%.6f');
end

save([filename_root '.pcaparams.mat'], 'PCAParams');


