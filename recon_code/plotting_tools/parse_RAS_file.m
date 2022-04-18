function elec = parse_RAS_file(filename)
% example file format:
% RPIP 10 36.651800 -50.179000 65.633900 R D
% RPIP 9 34.166700 -50.667000 59.166700 R D
% ...

fid = fopen(filename, 'r');
raw_data = textscan(fid, '%s %d %f %f %f %s %s');
elec.xyz = cat(2, raw_data{3}, raw_data{4}, raw_data{5});
elec.labelprefix = raw_data{1};
elec.labelnumber = raw_data{2};
elec.isLeft = zeros(numel(elec.labelprefix), 1);
for e = 1:numel(elec.labelprefix)
    elec.labels{e,1} = [elec.labelprefix{e} num2str(elec.labelnumber(e))];
    if elec.labelprefix{e}(1) == 'L'
        elec.isLeft(e,1) = 1;
    end
end
elec.isLeft = elec.isLeft == 1; % just convert from double to logical
elec.hemisphere = raw_data{6};
elec.type = raw_data{7};
fclose(fid);

end