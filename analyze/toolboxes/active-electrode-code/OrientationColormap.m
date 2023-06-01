
function iso = OrientationColormap(avg_eps, count, filename, numRow, numCol, numChan, Fs, response_window_start, response_window_stop)


%response_window_start = 1.1;
%response_window_stop = 1.25;

background_window_start = 0.0;
background_window_stop = 1.0;

start_orientation = 2;

save_fig = 'TRUE';

[PATHSTR,NAME,EXT,VERSN] = fileparts(filename);


mkdir(strcat('figures'))

response_window_start_samp = floor(response_window_start * Fs);
response_window_stop_samp = floor(response_window_stop * Fs);

background_window_start_samp = floor(background_window_start * Fs) + 1;
background_window_stop_samp = floor(background_window_stop * Fs);


avg_eps = avg_eps(start_orientation:end,:,:,:);
count = count(start_orientation:end);

min_count = min(count);


num_orientations = size(avg_eps,1);
num_channels = size(avg_eps,3);

subsample_size = floor(min_count / 2);

for shuffle = 1:9
    
    selection_matrix = zeros(num_orientations,min_count);
    for i = 1:num_orientations
        selection_matrix(i,:) = randperm(min_count);
    end
    
    selection_matrix = selection_matrix(:,1:subsample_size);
    
    responses = zeros(num_orientations, num_channels);
    for i = 1:num_orientations
        responses(i,:) = reshape(std(mean(avg_eps(i,selection_matrix(i,:),:,response_window_start_samp:response_window_stop_samp),2),0,4),1,num_channels);
    end        
        
   % responses = std(avg_eps(:,:,response_window_start_samp:response_window_stop_samp),0,3);
   % background = std(avg_eps(:,:,background_window_start_samp:background_window_stop_samp),0,3);
    
    %response_ratios = responses ./ background;
    response_ratios = responses;
    
    
    scrsz = get(0,'ScreenSize');
    
    
    
    % for i = 1:numChan
    %     figure(3)
    %     h = gcf;
    %     set(h,'OuterPosition',[0 0 scrsz(3) scrsz(4)])
    %     for j = 1:numRow
    %
    %         subplot(4,5,j);
    %
    %         plot(response_ratios(:,(i-1)*numRow+j))
    %
    %         %polar(-pi+pi/4:pi/4:pi,response_ratios(:,(i-1)*numRow+j)')
    %         %plot(x_plot, signal,'LineWidth',1,'Color',[0 0 0])
    %         axis tight
    %
    %     end
    %     pause
    % end
    
    % create spatial averaging filter to use for dead rows and columns
    h = fspecial('average', [3 3]);
    
    figure(1)
    subplot(3,3,shuffle)
    [y, idx] = max(response_ratios, [], 1);
    
    iso = reshape(idx(1:numRow*numCol),numRow,numCol);
    
    % knock out bad columns
    iso(:,[9 12]) = 0;
    
    % knock out bad rows
    iso([6],:) = 0;
    
    % smooth
    iso2 = filter2(h, iso);
    
    % replace bad columns in the original data with the smoothed data from
    % above
    iso(:,[9 12]) = (3/2) * iso2(:,[9 12]);
    iso([6],:) = (3/2) * iso2([6],:);
    
    % plot the new combined data
    imagesc(iso);
    colorbar
    

    
    
    figure(2)
    subplot(3,3,shuffle)
    rad_scale = repmat( -pi+pi/4:pi/4:pi, size(response_ratios,2), 1)';
    [x, y] = pol2cart(rad_scale,response_ratios);
    x = sum(x,1);
    y = sum(y,1);
    
    [th, r] = cart2pol(x,y);
    degrees = radtodeg(th);
    
    iso = reshape(degrees(1:numRow*numCol),numRow,numCol);
    
    % knock out bad columns
    iso(:,[9 12]) = 0;
    
    % knock out bad rows
    iso([6],:) = 0;
    
    % smooth
    iso2 = filter2(h, iso);
    
    % replace bad columns in the original data with the smoothed data from
    % above
    iso(:,[9 12]) = (3/2) * iso2(:,[9 12]);
    iso([6],:) = (3/2) * iso2([6],:);
    
    % plot the new combined data
    imagesc(iso);
    colorbar
    

    
end
    if strcmp(save_fig, 'TRUE')
        figure(1)
        fileString = strcat('.\figures\',NAME,'_discrete_angle.png');
        set(gcf,'PaperPositionMode','auto')
        print(gcf, '-dpng', fileString, '-r 300')
    end

    if strcmp(save_fig, 'TRUE')
        figure(2)
        fileString = strcat('.\figures\',NAME,'_continuous_angle.png');
        set(gcf,'PaperPositionMode','auto')
        print(gcf, '-dpng', fileString, '-r 300')
    end

end
