function createArrayBAlabels(XFM,GRID,DEPTH,NAME)
% BETA. WORK IN PROGRESS
%
%  createArrayMRIUnderlay(XFM,GRID)
%
% Create Brodman Area labels for arbitrary positions along electrod tracks
% Needs an image called balabels.nii containing area labels in register with 
% the monkey's MRI, located in the MRIDIR
%  
% XFM:      String. Name of function in MONKEYDIR/MRI/ which outputs the
%           brainsight transformation matrix from chamber space to scanner
%           space. See Brainsight help figure 16-4
%
%           OR
%
%           4x4 matrix specifying the affine transformation from chamber to
%           scanner space.See Brainsight help figure 16-4
%
%
% GRID:     string ('SC32' 'SC96')or nchanx2matrix of electrode coordinates
%           Defaults to 'SC32'
%
% DEPTHS:   Electrode depths from chamber center for which to evaluate labels
%
% See: createArrayElectrodeGrid, plotArray, createArrayMRIUnderlay

global MONKEYDIR MONKEYNAME

% adding spm to path
DIR = dir('/mnt/raid'); DIR = {DIR(:).name}; idir = strmatch('spm',DIR);
if ~isempty(idir); addpath(genpath(['/mnt/raid/' DIR{idir}])); fprintf('Adding %s found in /mnt/raid/\n',DIR{idir}); else; fprintf('No SPM in /mnt/raid\nAssuming SPM functions to be available\n');end
% check MRI dir
MRIDIR = [MONKEYDIR '/MRI'];
if ~exist(MRIDIR); error(sprintf('%s/MRI not found. Please see the WIKI for instructions for setting up a monkey specific MRI dir.\n',MONKEYDIR));else addpath(MRIDIR);end
% get xfm
if ischar(XFM); eval(sprintf('xfm = %s;',XFM)); else xfm=XFM; end
% Paramteres
if nargin<2; GRID = 'SC32'; end % width, height
if nargin<3; DEPTH = 0:-0.5:-30; end
if nargin<4; NAME = 'balabels'; end
if strcmp('SC96',GRID)
    load SC96_standard_grid.mat % part of analyze
    fprintf('Electrodegrid: %s\n',GRID)
elseif strcmp('SC32',GRID)
    load SC32_standard_grid.mat % part of analyze
    fprintf('Electrodegrid: %s\n',GRID)
elseif ischar(GRID)
    load(sprintf('%s/%s',MRIDIR,GRID))
    fprintf('Electrodegrid: %s\n',GRID)
    if size(fac,1)~=nd
       error('Electrode grid does not match input') 
    end
else
    centers = GRID;
end
fprintf('Creating BA labels for %d electrodes\n Depths: %.2fmm - %.2fmm\n',size(centers,1),DEPTH(1),DEPTH(end))

% Load header and image
fprintf('Loading image\n')
V = spm_vol(sprintf('%s/balabels.nii',MRIDIR));
vol = spm_read_vols(V);
qform = V.mat;


% Voxel space
[Xs Ys Zs] = ndgrid(1:V.dim(1),1:V.dim(2),1:V.dim(3));
nz = numel(DEPTH);

% Preallocation
Labels = nan(numel(DEPTH),size(centers,1));

% Image interpolation
tic
for ielec = 1:size(centers,1)
    for id=1:nz

        tmp = pinv(qform)*(xfm*[centers(ielec,1) centers(ielec,2) DEPTH(id) 1]'); % Transform from chamber space to voxel space
        Xc=tmp(1);
        Yc=tmp(2);
        Zc=tmp(3);
        
        Labels(id,ielec) = interpn(Xs,Ys,Zs,vol,Xc,Yc,Zc,'nearest');
    end
    fprintf('\r%d/%d, %.2fs',ielec,size(centers,1),toc)
end
save(sprintf('%s/%s.mat',MRIDIR,NAME),'Labels','DEPTH')
fprintf('\ndone\n')




