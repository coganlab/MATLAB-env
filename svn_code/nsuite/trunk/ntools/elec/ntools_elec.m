function ntools_elec(varargin)

% check for spm, fsl and freesurfer
if isempty(which('spm')), error('Please install SPM.\n'); end
if isempty(getenv('FSLDIR')),error('Please install FSL.\n'); end
if isempty(getenv('FREESURFER_HOME')), error('Please instll Freesurfer\n'); end

% get the subject info
Ssdir=getenv('SUBJECTS_DIR');
Subject_path = uigetdir(Ssdir,'Select the subject FreeSurfer reconstruction folder');

if Subject_path==0
    disp('No Freesurfer folder was selected');
    return
end

ii = strfind(Subject_path,'/');
Ssdir = Subject_path(1:ii(end));
Sdir = Subject_path(ii(end)+1:end);

%% read the inital text file
[FileName,PathName] = uigetfile('*.txt','Select the initial text file','../'); % need personal settings
jj = strfind(PathName,'/');
Sname = PathName(jj(end-1)+1:jj(end)-1);

[dep_img_file,dep_img_path] = uigetfile({'*.*';'*.nii';'*.nii.gz';'*.img'},...
        'Select the T1 pre-operation image: ',PathName);
    
% move other files to backup folder
backup_dir = [PathName,'backup_',datestr(now,29)];
if ~exist(backup_dir,'dir'), mkdir(backup_dir); end;
all_files = dir(PathName);
all_files_isdir = [all_files(:).isdir];
all_files_name = {all_files(:).name};
all_files_name = all_files_name(all_files_isdir==0);
idx = ~cellfun(@isempty,strfind(all_files_name,'.log'))+...
    ~cellfun(@isempty,strfind(all_files_name,FileName))+...
    ~cellfun(@isempty,strfind(all_files_name,dep_img_file));
all_files_name = all_files_name(~logical(idx));
for i=1:length(all_files_name), movefile([PathName, all_files_name{i}],backup_dir,'f'); end;
    
% start diary 
diary_file = [PathName,'localization_process_',datestr(now,29),'.log'];
diary on;
diary(diary_file)
fprintf('\n================================================================\n');
fprintf('Starting localization process for %s at %s\n',Sname,datestr(now,31));
fprintf('Freesurfer Recon dir: %s\n',Subject_path);
fprintf('Initial location text file: %s\n',fullfile(PathName,FileName));

% read in preop T1
hdr = ntools_elec_load_nifti([dep_img_path dep_img_file],1);
if ~isequal(hdr.pixdim(2),hdr.pixdim(3),hdr.pixdim(4))
    warning('T1 voxel mm dimensions not equal. Will affect the accuracy of distance calculation');
end
scale = mean(hdr.pixdim(2:4));

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s','CommentStyle','%');
fclose(fid);

elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];

if isempty(char(elec_all{5}(:)))
    g = strmatch('G',upper(elec_all{1}));
    d = strmatch('D',upper(elec_all{1}));
else
    g = strmatch('G',upper(elec_all{5}));
    d = strmatch('D',upper(elec_all{5}));
end

ini_grid = elec_cell(g,:);
ini_depth = elec_cell(d,:);
elec_cell([g;d],:) = [];

hemi = menu('Electrodes on which hemisphere?','left hemi','right hemi','both hemi');
if hemi==1
    sph_s = 'lh'; fprintf('\nElectrodes are on Left hemisphere\n');
elseif hemi==2
    sph_s = 'rh'; fprintf('\nElectrodes are on Right hemisphere\n');
else
    sph_s = 'both'; fprintf('\nElectrodes are on Both hemispheres\n');
end

%%
% outer-brain surface check and create
ntools_elec_outer_brain(Subject_path)

% calculate grids
radius = input('\nInput the inter-electrode distance (mm) (Press Enter for default distance 10mm) : ');
if isempty(radius)
    radius = 10;
end
[elec_grid,grid_stats] = ntools_elec_calc_grid(ini_grid,Subject_path,scale,radius);
fprintf('\nGrid stats: itr#: %f mean: %f std:%f\n',cell2mat(grid_stats(1:3)))

% calculate depth elecs
elec_depth = ntools_elec_calc_depth(ini_depth);

% calculate strip elecs
elec_strip = ntools_elec_calc_strip(elec_cell,Subject_path,sph_s);

% save the electrodes locations into a text file
fname_t1 = [PathName Sname '_coor_T1_' datestr(now,29) '.txt'];
ntools_elec_savetxt(fname_t1,elec_grid,elec_strip,elec_depth);
fid = fopen(fname_t1);
text = textscan(fid,'%s %f %f %f %s');
fclose(fid);
name = text{1}; x = text{2}; y = text{3}; z = text{4}; label = text{5};

% save all into binary nifti image
fname_bin = [PathName,Sname,'_elec_bin_T1_' datestr(now,29), '.nii.gz'];
elec_vox = ntools_elec_savebin([x y z],hdr,fname_bin);

% transform into mni space
elec_mni = ntools_elec_dartel_warp(fname_bin,[dep_img_path,dep_img_file]);
fname_mni = [PathName Sname '_coor_MNI_' datestr(now,29) '.txt'];
ntools_elec_savetxt(fname_mni,[name num2cell(elec_mni) label]);


%% Save the surf.mat and plot

if strcmp(sph_s,'both')
    surf_brain_lh = fs_load_subj(Sdir,'lh','pial',0,Ssdir);
    if ~isfield(surf_brain_lh,'coords')
        surf_brain_lh.coords = surf_brain_lh.vertices;
    end
    surf_brain_rh = fs_load_subj(Sdir,'rh','pial',0,Ssdir);
    if ~isfield(surf_brain_rh,'coords')
        surf_brain_rh.coords = surf_brain_rh.vertices;
    end    
    
    lh_mat = [PathName,Sdir,'_lh_pial_surf.mat'];
    rh_mat = [PathName,Sdir,'_rh_pial_surf.mat'];

    save(lh_mat,'-struct','surf_brain_lh','coords','faces');
    save(rh_mat,'-struct','surf_brain_rh','coords','faces');

    ntools_elec_plot(fname_t1,{lh_mat,rh_mat});

    clear surf_brain_lh surf_brain_rh 
else
    surf_brain = fs_load_subj(Sdir,sph_s,'pial',0,Ssdir);
    if ~isfield(surf_brain,'coords')
        surf_brain.coords = surf_brain.vertices;
    end    
    surf_mat = [PathName,Sdir,'_',sph_s,'_pial_surf.mat'];

    save(surf_mat,'-struct','surf_brain','coords','faces');

    ntools_elec_plot(fname_t1,surf_mat);

    clear surf_brain
end

% close diary
fprintf('\nElectrodes Localization finished for %s',Sname);
fprintf('\n================================================================\n');
diary off
