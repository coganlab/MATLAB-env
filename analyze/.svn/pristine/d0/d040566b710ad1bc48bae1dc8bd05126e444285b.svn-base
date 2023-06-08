function [microdrive, row, col, ch, arm, connector] = layoutDef_ECOG244_JWpt(microdrive)

spacing = 0.75;

nE = size(microdrive.electrodes,2);

nArm = size(microdrive.pcbConfig,2);

arm = []; connector = [];
row = []; col = []; ch = [];
for iA = 1:nArm
    
    [num, txt] = xlsread(microdrive.configFile, ['pcb', microdrive.pcbConfig{iA}]);
    
    r = num(:, ismember(txt(1,:), 'Row'));
    c = num(:, ismember(txt(1,:), 'Col'));
    ch_ind = num(:, ismember(txt(1,:), 'DAQ'));
    a = str2double(microdrive.pcbConfig{iA}(1));
    switch microdrive.pcbConfig{iA}(2)
        case 'a'
            con = 1;
        case 'b'
            con = 2;
        otherwise
            error('unexpected arm name')
    end
                
    %deal with missing/ground channels
    tmp = sort(ch_ind);
    missing = find(~ismember(1:tmp(end), tmp));
    r = cat(1, r, nan(length(missing),1));
    c = cat(1, c, nan(length(missing),1));
    ch_ind = cat(1, ch_ind, missing');
    
    row = cat(1, row, r);
    col = cat(1, col, c);    
    ch  = cat(1, ch,  ch_ind + length(ch));
    arm = cat(1, arm, repmat(a, length(r),1));
    connector = cat(1, connector, repmat(con, length(r),1));
    
end
    


pos_x = col*spacing;
pos_y = row*spacing;


for iE=ch'
    
    microdrive.electrodes(iE).position.row = row(iE);
    microdrive.electrodes(iE).position.col = col(iE);
    microdrive.electrodes(iE).position.x   = pos_x(iE);
    microdrive.electrodes(iE).position.y   = pos_y(iE);
end
    
    
    