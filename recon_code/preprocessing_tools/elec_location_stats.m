function elec_location_stats(sub, parc_fn, radius, use_brainshifted)
global RECONDIR;
if nargin < 3
    radius = 3;
end
if nargin < 4
    use_brainshifted = 0;
end
root = fullfile(RECONDIR, sub);
mri = MRIread(fullfile(root, 'mri', 'brainmask.mgz'));
parc = MRIread(fullfile(root, 'mri', parc_fn));

% [elecMatrix, elecLabels, elecRgb]=mgrid2matlab(sub);
if use_brainshifted
    xyz = scantext(fullfile(root, 'elec_recon', sprintf('%s.PIALVOX', sub)), ' ', 2, '%f%f%f');
    elecMatrix = cat(2, xyz{1}, xyz{2}, xyz{3}) + 1;
    elecLabels = scantext(fullfile(root, 'elec_recon', sprintf('%s.electrodeNames', sub)), ' ', 2, '%s%s%s');
    elecLabels = elecLabels{1};
else
    elecdata = parse_RAS_file(fullfile(root, 'elec_recon', sprintf('%sPostimpLoc.txt', sub)));
    elecMatrix = elecdata.xyz + 1;
    elecLabels = elecdata.labels';
end
nElec=length(elecLabels);
elecMatrix=round(elecMatrix);
xyz=zeros(size(elecMatrix));
xyz(:,1)=elecMatrix(:,2);
xyz(:,2)=elecMatrix(:,1);
xyz(:,3)=size(parc.vol, 3)-elecMatrix(:,3);
elec = xyz;

% Load segmentation color table
pathstr = fileparts(which('mgrid2matlab'));
inFile=fullfile(pathstr,'FreeSurferColorLUTnoFormat.txt');
fid=fopen(inFile,'r');
tbl=textscan(fid,'%d%s%d%d%d%d');
fclose(fid);

radius_2 = radius^2;

x_num = size(parc.vol, 1);
y_num = size(parc.vol, 2);
z_num = size(parc.vol, 3);

summary = {};
anatLabels = {};
for r = 1:size(elec,1)
    % get all voxels in a cube around electrode
    x_vox = elec(r,1) - radius : elec(r,1) + radius;
    y_vox = elec(r,2) - radius : elec(r,2) + radius;
    z_vox = elec(r,3) - radius : elec(r,3) + radius;
    parcvals = [];
    summary{r,2} = elecLabels{r};
    anatLabels{r,1} = elecLabels{r};
    parcval = parc.vol(elec(r,1), elec(r,2), elec(r,3));
    idx = find(tbl{1} == parcval, 1, 'first');
    anatLabels{r,2} = tbl{2}{idx};
    summary{r,1} = tbl{2}{idx};
    i = 1;
    for x = 1:numel(x_vox)
        for y = 1:numel(y_vox)
            for z = 1:numel(z_vox)
                vox = [x_vox(x) y_vox(y) z_vox(z)];
                if sum((elec(r,:) - vox).^2) <= radius_2
                    parcvals(i,1) = parc.vol(vox(1),vox(2),vox(3));
                    i = i + 1;
                end
            end
        end
    end
    uparc = unique(parcvals);
    counts = [];
    for u = 1:numel(uparc)
        counts(u) = sum(parcvals == uparc(u));
    end
    [~,reorder] = sort(counts, 'descend');
    i = 3;
%     disp(sum(counts));
    counts = counts / sum(counts);
    for u = 1:numel(uparc)
        if uparc(reorder(u)) == 0
            summary{r,i} = 'unknown';
        else
            idx = find(tbl{1} == uparc(reorder(u)), 1, 'first');
            summary{r,i} = tbl{2}{idx};
        end
        summary{r,i+1} = sprintf('%.4f', counts(reorder(u)));
        i = i + 2;
    end
end

% write to table
summary_text = summary;
log = cellfun(@isempty, summary_text);
summary_text(log) = {' '};
if use_brainshifted
    bs = '_brainshifted';
else
    bs = '';
end
fid = fopen(fullfile(root, 'elec_recon', sprintf('%s_elec_location_radius_%dmm_%s%s.csv', sub, radius, parc_fn, bs)), 'w');
fprintf(fid, '#Info: %s parcellation results. For each electrode we find the voxels within a spherical radius and determine the anatomical label for each voxel. Columns C onward show proportion of this sphere belongs to a particular label. The far left column shows the label for the origin of the sphere - the center of the electrode.\n', parc_fn);
for r = 1:size(summary, 1)
    towrite = strjoin(summary_text(r,:), ',');
    fprintf(fid, '%s\n', towrite);
end
fclose(fid);

end