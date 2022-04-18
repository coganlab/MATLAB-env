function pial2mat(sub, ptype)
global RECONDIR;

hem = 'l';
[surf_brain.coords,surf_brain.faces] = freesurfer_read_surf(fullfile(RECONDIR, sub, 'surf', sprintf('%sh.%s', hem, ptype)));
if strcmp(ptype, 'inflated')
    surf_brain.coords(:,1) = surf_brain.coords(:,1) - 45; 
end
save(fullfile(RECONDIR, sub, 'surf', sprintf('%sh.%s.mat', hem, ptype)), 'surf_brain');

b_surf_brain = surf_brain;

hem = 'r';
[surf_brain.coords,surf_brain.faces] = freesurfer_read_surf(fullfile(RECONDIR, sub, 'surf', sprintf('%sh.%s', hem, ptype)));
if strcmp(ptype, 'inflated')
    surf_brain.coords(:,1) = surf_brain.coords(:,1) + 45; 
end
save(fullfile(RECONDIR, sub, 'surf', sprintf('%sh.%s.mat', hem, ptype)), 'surf_brain');

num_vert = size(b_surf_brain.coords,1);
b_surf_brain.coords = cat(1, b_surf_brain.coords, surf_brain.coords);
r_new_faces = surf_brain.faces + num_vert;
b_surf_brain.faces = cat(1, b_surf_brain.faces, r_new_faces);

surf_brain = b_surf_brain;

hem = 'b';
save(fullfile(RECONDIR, sub, 'surf', sprintf('%sh.%s.mat', hem, ptype)), 'surf_brain');

end