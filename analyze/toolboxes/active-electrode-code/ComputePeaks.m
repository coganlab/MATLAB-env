function ComputePeaks (data, filename, startSec, stopSec, triggerTime, numRow, numCol, Fs)

% All frequency values are in Hz.


save_mov = 'TRUE';
%save_mov = 'FALSE';

%smooth_en = 'FALSE';
smooth_en = 'TRUE';

% 7/14 cat - test31 file
% bad_col = [1 2 4 5 12 17];
% bad_row = [13];
% bad_single_row = [9];
% bad_single_col = [7];

% 8/19 rat - test02 file
% bad_col = [1 ];
% bad_row = [];
% bad_single_row = [8];
% bad_single_col = [7];

% 5/19 rat - test02 file
bad_col = [9 12];
bad_row = [6];
bad_single_row = [];
bad_single_col = [];

% pull electrode data out and negate
dataf = -data(1:numRow*numCol,floor(startSec*Fs)+1:floor(stopSec*Fs));

%xAvg = dataf;

% reshape to physical arrangement
g = reshape(dataf,numRow,numCol,size(dataf,2));


if strcmp(smooth_en, 'TRUE')
    % knock out bad columns
    g(:,bad_col,:) = 0;
    
    % knock out bad rows
    g(bad_row,:,:) = 0;
    
    g(bad_single_row,bad_single_col,:) = 0;
end

dataf = reshape(g,numRow*numCol,size(g,3));

% create average trace
xAvg = mean(dataf,1);

[pks, locs] = findpeaks(xAvg, 'MINPEAKDISTANCE', 40);

% scatter(locs, pks)
% hold on
% plot(xAvg)

pksD = zeros(size(dataf,1), size(locs,2));
locsD = zeros(size(dataf,1), size(locs,2));


for i = 1:size(dataf,1)
    [pks_temp, locs_temp] = findpeaks(dataf(i,:), 'MINPEAKDISTANCE', 40);
    if size(pks_temp,2) > 0
        %if size(pks_temp) == size(pks)
            %pksD(i,:) = pks_temp;
            locsD(i,1:size(locs_temp,2)) = locs_temp;
        %else
            
        %end
    end
end

locsD = locsD(:,1:end-1);
locs = locs(1:end-1);

delay = mean(locsD - repmat(locs,size(locsD,1),1),2);

iso = reshape(delay,numRow,numCol);

if strcmp(smooth_en, 'TRUE')
    % knock out bad columns
    iso(:,bad_col) = 0;
    
    % knock out bad rows
    iso(bad_row,:) = 0;
    
    iso(bad_single_row,bad_single_col) = 0;
end

if strcmp(smooth_en, 'TRUE')
    % create spatial averaging filter to use for dead rows and columns
    h = fspecial('average', [3 3]);
    
    % smooth
    iso2 = filter2(h, iso);
    
    % replace bad columns in the original data with the smoothed data from
    % above
    iso(:,bad_col) = (3/2) * iso2(:,bad_col);
    iso(bad_row,:) = (3/2) * iso2(bad_row,:);
    
end


% plot the new combined data
imagesc(iso,[-28 18]);

% for i = 1:size(dataf,1)
% hold off
%     figure(1)
%     scatter(locsD(i,:), pksD(i,:))
% hold on
% plot(xAvg,'g')
% plot(dataf(i,:),'b')
% pause
% end

% for i = 1:size(dataf,1)
%     corrV = xcorr(xAvg,dataf(i,:));
%     [a b(i) ] =  max(corrV);
% end
% iso = reshape(b,numRow,numCol);

end