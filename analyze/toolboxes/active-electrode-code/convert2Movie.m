
function M = convert2Movie (data, filename, startSec, stopSec, triggerTime, numRow, numCol, Fs, minValV, maxValV, save_mov)

% data - provide the data here
% filename - the filename of the data, used when writing out the movie
% startSec - the start time of the movie, in seconds
% stopSec - the stop time of the movie, in seconds
% triggerTime - the offset applied to the time axis in the movie.
%               set this equal to startSec if you want your movie to start at 0 seconds
% numRow - number of electrode rows
% numCol - number of electrode columns
% Fs - sampling rate of the data
% minValV - (OPTIONAL) - minimum value for the movie color scale
% maxValV - (OPTIONAL) - minimum value for the movie color scale
%       If you do not provide minValV or maxValV, they will be calculated
%       from 5% to 95% of the amplitude in the data
% save_mov - (OPTIONAL) - set equal to 'TRUE' to write out the movie

% by default, if the user has not said to explicitly do it, don't write the
% movie
if exist('save_mov', 'var') == 0
    save_mov = 'FALSE';
end

% pull electrode data out  (no negate, already done elsewhere)
data = data(1:numRow*numCol,:);

% if start / stop provided, grab data
if (~isempty(startSec)) && (~isempty(stopSec))
    data = data(:,floor(startSec*Fs)+1:floor(stopSec*Fs));
else
    startSec = 0;
end

% create average trace
xAvg = mean(data,1);

% if the user has not provided saturation thresholds
if (exist('minValV', 'var') == 0) || (size(minValV,1) == 0)
    %compute saturation thresholds
    sorted_min = sort(min(data,[],2));
    minValV = sorted_min(round(size(sorted_min,1) * 0.05));
    disp(['Movie mininum voltage for colormap: ' num2str(minValV)])
end

if (exist('maxValV', 'var') == 0) || (size(maxValV,1) == 0)
    %compute saturation thresholds
    sorted_max = sort(max(data,[],2));
    maxValV = sorted_max(round(size(sorted_max,1) * 0.95));
    disp(['Movie maximum voltage for colormap: ' num2str(maxValV)])
end

% reshape to physical arrangement
data = reshape(data,numRow,numCol,size(data,2));

% create figure
figure(1)
close(1)
f1 = figure('color','white');

% set the size of the movie frame
set(f1,'Position',[100 100 464 560])


% init time vector
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

% subtract off trigger time to event start at time = 0
% add back in startSec, so that triggerTime is entered relative to the
% original data
t = t + triggerTime + startSec;

% if saving data, open the output file
if strcmp(save_mov, 'TRUE')
    [PATHSTR,NAME,EXT] = fileparts(filename);
    
    mkdir(strcat(PATHSTR, '\movies'));
    
    title_str = strcat(NAME,' start ',num2str(startSec,'%6.2f'),' stop ',num2str(stopSec,'%6.2f'));
    %title(title_str);
    
    fileString = strcat(strcat(PATHSTR, '\movies\'),title_str,'.avi');
    
    disp(['Writing to movie ' fileString])
    
    % Prepare the new file.
    %vidObj = VideoWriter(fileString, 'Uncompressed AVI');
    
    vidObj = VideoWriter(fileString, 'Motion JPEG AVI');
    vidObj.Quality = 100;
    
    vidObj.FrameRate = 15;
    open(vidObj);
end

% Do everything for frame 1 first to pre-init... prevents strange bug
% create a standard plot of the average data on the bottom of the frame
h2 = subplot(2,1,2);
set(h2,'position',[.04 .04 .92 .2])   % make the plot window small

plot(t,xAvg');  % plot the average data
set(gca,'FontWeight','bold');
vline(t(1))

% generate subplot for the image data (top of frame)
h1 = subplot(2,1,1);
set(h1,'position',[.04 .28 .92 .70])

% grab one frame of the data, one data point in time
% plot the movie
imagesc(data(:,:,1),[minValV maxValV]);
colormap(jet(256))
axis image;
set(gca,'XTick',[]);
set(gca,'YTick',[]);

M(1) = getframe(f1);



% loop over all the data points in the movie
for i = 1:size(xAvg,2)
    
    % create a standard plot of the average data on the bottom of the frame
    h2 = subplot(2,1,2);
    set(h2,'position',[.04 .04 .92 .2])   % make the plot window small
    
    plot(t,xAvg');  % plot the average data
    set(gca,'FontWeight','bold');
    vline(t(i))
    
    % generate subplot for the image data (top of frame)
    h1 = subplot(2,1,1);
    set(h1,'position',[.04 .28 .92 .70])
    
    % grab one frame of the data, one data point in time
    % plot the movie
    imagesc(data(:,:,i),[minValV maxValV]);
    colormap(jet(256))
    axis image;
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    % grab the entire frame
    M(i) = getframe(f1);
    
    % grab just the color map
    %M(i) = getframe;
    
    % Write each frame to the file.
    % if saving data
    if strcmp(save_mov, 'TRUE')
        writeVideo(vidObj,M(i));
    end
    
end

% Close the file.
if strcmp(save_mov, 'TRUE')
    close(vidObj);
end









