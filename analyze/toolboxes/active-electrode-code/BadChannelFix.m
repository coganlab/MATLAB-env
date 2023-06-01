function data = BadChannelFix (data, numRow, numCol, bad_row, bad_col, bad_single_row, bad_single_col)

% This function removes user selected bad channels and replaces the missing
% data with interpolated data from adjacent electrodes
% Inputs:
% data - the data
% numRow - number of electrode rows
% numCol - number of electrode columns
% bad_row - an array of indices of completely bad rows to remove
% bad_col - an array of indices of completely bad columns to remove
% bad_single_row - an array of indices of the rows corresponding to bad
%                   single pixels
% bad_single_col - an array of indices of the columns corresponding to bad
%                   single pixels
%     If any of the above 4 parameters are not used, supply them as []


% start by reshaping to physical arrangement
data = reshape(data,numRow,numCol,size(data,2));

% knock out bad columns
data(:,bad_col,:) = 0;

% knock out bad rows
data(bad_row,:,:) = 0;

% knock out bad single electrodes
for i = 1:size(bad_single_row,2)
    data(bad_single_row(i),bad_single_col(i),:) = 0;
end

% create spatial averaging filter to use for dead rows and columns
h = fspecial('average', [3 3]);
%h = fspecial('average', [5 5]);
%h = fspecial('gaussian',[5 5],0.5);

% now, create a compensation matrix that corrects for the filtering with 0 data

% create a matrix of 1s for good channels and 0s for bad channels
blank = ones(numRow,numCol);
blank(:,bad_col) = 0;
blank(bad_row,:) = 0;
for j = 1:size(bad_single_row,2)
    blank(bad_single_row(j),bad_single_col(j)) = 0;
end

% filter the matrix of 1s and 0s with same spatial filter
blank = filter2(h, blank);

% invert weight matrix
blank = 1 ./ blank;

% loop over all the samples
for i = 1:size(data,3)
    
    % grab one frame of the data, one data point in time
    iso = data(:,:,i);
    
    % create a spatially smoothed version of that frame
    iso2 = filter2(h, iso);
    
    % replace bad columns and rows in the original data with the
    % smoothed data from above. Scale the data by the weight matrix
    iso(:,bad_col) = blank(:,bad_col) .* iso2(:,bad_col);
    iso(bad_row,:) = blank(bad_row,:) .* iso2(bad_row,:);
    
    for j = 1:size(bad_single_row,2)
        iso(bad_single_row(j),bad_single_col(j)) = blank(bad_single_row(j),bad_single_col(j)) .* iso2(bad_single_row(j),bad_single_col(j));
    end
    
    % put the spatially filtered data back in
    data(:,:,i) = iso;
    
end

% Send the data back in 2d instead of 3d
data = reshape(data,numRow*numCol,size(data,3));


