function remap_elec_names(subj, just_vis)
% tool used to remap electrodes for grid subjects some grids have
% non-conventional orientations and numbering orders e.g. instead of going
% from 1-48, it might be 8-64 and skip every 4th number of something
% similar. bioimagesuite does not offer a way to rename the electrodes, so
% we either need to rename the .mgrid (which is difficult to parse given
% the formatting) or the .electrodeNames. I think the best solution is to
% rename the .electrodeNames (output from Dykstra preprocessing step, the
% step to account for brainshift)
% 
% To use this script, first pull up a visualization of the current
% numbering system remap_elec_names('D26', 1); this should open a figure.
% Then, you want to add a new case to the switch block for the subject
% Specify old and new variables. This is the renaming mapping. Old is the
% orientation of the figure you just plotted -- the mgrid results. For
% every entry in old, there should be a corresponding entry in new. e.g.
% for D26, RTG 1:24 is remapped to [48:-1:43 40:-1:35 32:-1:27 24:-1:19];
% once you specify old, new, and prefix, you can rerun script
% remap_elec_names('D26', 0);
% This should generate a new .electrodeNames file with the proper remapped
% names

global globalFsDir

if ~exist(fullfile(globalFsDir, subj, 'elec_recon', [subj '.electrodeNames_orig']), 'file')
    copyfile(fullfile(globalFsDir, subj, 'elec_recon', [subj '.electrodeNames']), fullfile(globalFsDir, subj, 'elec_recon', [subj '.electrodeNames_orig']));
end

if nargin > 1 && just_vis
    enames = scantext(fullfile(globalFsDir, subj, 'elec_recon', [subj '.electrodeNames']), ' ', 2);
    enames = enames{1};
    
    ras = scantext(fullfile(globalFsDir, subj, 'elec_recon', [subj '.CT']), ' ', 2);
    figure;scatter3(ras{1}, ras{2}, ras{3});
    for e = 1:numel(enames)
        text(ras{1}(e), ras{2}(e), ras{3}(e), enames{e});
    end
    return;
end


fid = fopen(fullfile(globalFsDir, subj, 'elec_recon', [subj '.electrodeNames_orig']), 'r');
st = [];
while ~feof(fid)
    st = cat(1, st, fread(fid, 8, 'char=>char'));
end
st = st';
fclose(fid);

switch subj
    case 'D26'
        
        
        old = 1:24;
        new = [48:-1:43 40:-1:35 32:-1:27 24:-1:19];
        prefix = 'RTG';
        for r = 1:numel(old)
            st = strrep(st, sprintf('%s%d ', prefix, old(r)), sprintf('%s%d?', prefix, new(r)));
        end
        
        old = 1:24;
        new = 17:40;
        prefix = 'RPG';
        for r = 1:numel(old)
            st = strrep(st, sprintf('%s%d ', prefix, old(r)), sprintf('%s%d?', prefix, new(r)));
        end
        
        
    case 'D16'
        
        
        old = [4:4:28 3:4:27 2:4:26 1:4:21];
        new = [34:40 42:48 50:56 58:63];
        prefix = 'LTG';
        for r = 1:numel(old)
            st = strrep(st, sprintf('%s%d ', prefix, old(r)), sprintf('%s%d?', prefix, new(r)));
        end
        
        old = [1:6];
        new = [6:-1:1];
        prefix = 'LPST';
        for r = 1:numel(old)
            st = strrep(st, sprintf('%s%d ', prefix, old(r)), sprintf('%s%d?', prefix, new(r)));
        end
end

st = strrep(st, '?', ' ');
fid = fopen(fullfile(globalFsDir, subj, 'elec_recon', [subj '.electrodeNames']), 'w');
fwrite(fid, st);
fclose(fid);