function createArrayMRIUnderlay(XFM,SIZE,RES,DEPTH,NAME)
% BETA. WORK IN PROGRESS
%
%  createArrayMRIUnderlay(XFM,SIZE,RES,DEPTH,NAME)
%
% Creates MRI underlays for topoplots of arrays. 
% Requires SPM functions spm_vol and spm_read_vols. This will try to add
% a spm folder under /mnt/raid
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
% optional
% SIZE:     Four element vector specifying the size [xleft xright yleft yright] of the
%           MRI underlay in mm. Defaults to [-15 15 -15 15].
% RES:      Scalar. Resolution of the MRI underlay in mm. Defaults to 0.5mm
% DEPTH:    Vector specifying the desired depths at which MRI underlay is
%           interpolated in mm. Defaults to 0:-1:-30;
% NAME:     String. Name of the array. Defaults to 'Array'
%
% See: createArrayElectrodeGrid, plotArray

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
if nargin<2; SIZE = [-15 15 -15 15]; end % width, height
if nargin<3; RES = 0.5; end
if nargin<4; DEPTH = 0:-1:-30; end
if nargin<5; NAME = 'Array'; end
fprintf('Creating MRI underlays:\n %.2fmm x %.2fmm with %.2fmm resolution\n%d images from %.2fmm to %.2fmm depth\n',abs(diff(SIZE(1:2))),abs(diff(SIZE(3:4))),RES,numel(DEPTH),DEPTH(1),DEPTH(end))

% Load header and image
fprintf('Loading image\n')
V = spm_vol(sprintf('%s/%s.nii',MRIDIR,MONKEYNAME));
vol = spm_read_vols(V);
qform = V.mat;

% Scale image intensities
vol=vol-min(vol(:));
vol=vol./max(vol(:));
vol=vol.*255;

% Voxel space
[Xs Ys Zs] = ndgrid(1:V.dim(1),1:V.dim(2),1:V.dim(3));

% Define off-plane slice
xc = SIZE(1):RES:SIZE(2); nx = numel(xc); % mm
yc = SIZE(3):RES:SIZE(4); ny = numel(yc);
nz = numel(DEPTH);
% keyboard

% Memory preallocation
MRI = nan(nx,ny,nz);

% Image interpolation
tic
for id=1:numel(DEPTH)
    Xc = nan(nx,ny);
    Yc = nan(nx,ny);
    Zc = nan(nx,ny);
    for ix=1:numel(xc)
        for iy=1:numel(yc)
            tmp = pinv(qform)*(xfm*[xc(ix) yc(iy) DEPTH(id) 1]'); % Transform from chamber space to voxel space
            Xc(ix,iy)=tmp(1);
            Yc(ix,iy)=tmp(2);
            Zc(ix,iy)=tmp(3);
        end
    end
    MRI(:,:,id) = interpn(Xs,Ys,Zs,vol,Xc,Yc,Zc);
    fprintf('\r%d/%d, %.2fs',id,nz,toc)
end
save(sprintf('%s/%s.mat',MRIDIR,NAME),'MRI','SIZE','DEPTH','RES')
fprintf('\ndone\n')




