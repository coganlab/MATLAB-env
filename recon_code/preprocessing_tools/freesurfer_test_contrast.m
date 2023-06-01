function freesurfer_test_contrast(subj, contrast)
% subj = 'D29';
% contrast = .5;
if nargin < 2
    contrast = .5;
end
fsdir=getFsurfSubDir();

% Load MRI
mriFname=fullfile(fsdir,subj,'mri','brainmask.mgz');
if ~exist(mriFname,'file')
   error('File %s not found.',mriFname); 
end
mri=MRIread(mriFname);

mx=max(max(max(mri.vol)))*contrast;
mn=min(min(min(mri.vol)));
figure;imagesc(mri.vol(:,:,128), [mn, mx])
colormap gray
end