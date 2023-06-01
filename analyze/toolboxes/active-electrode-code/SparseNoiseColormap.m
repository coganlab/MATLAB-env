
function M = SparseNoiseColormap(avg_eps, count, filename, numRow, numCol, numChan, Fs, response_window_start, response_window_stop)

% avg_eps - the responses (not averaged)
% count - the count of the averaged
% filename - the filename
% response_window_start - the start of the response window (in seconds)
% response_window_stop - the stop of the response window (in seconds)

start_orientation = 1;

number_x_levels = size(avg_eps,1);  % 1st dimension is x axis
number_y_levels = size(avg_eps,2);  % 2nd dimension is y axis
% 3rd dimension is trials

num_channels = size(avg_eps,4);     % 4th dimension is channels
num_samp = size(avg_eps,5);     % 4th dimension is channels
% 5th dimension is samples

% use an equal number of trials from each orientation or coordinate,
% therefore we must use the minimum number from all
min_count = min(min(count));

%subsample_size = 10;
subsample_size = min_count;
%subsample_size = ceil(min_count / 2);

num_shuffle = 1;


save_fig = 'TRUE';
%save_fig = 'FALSE';

% this controls whether the movie is saved to disk or not
%save_mov = 'TRUE';
save_mov = 'FALSE';

movie_en = 'FALSE';
%movie_en = 'TRUE';

[~,NAME,~] = fileparts(filename);


scrsz = get(0,'ScreenSize');

mkdir(strcat('figures'))


response_window_start_samp = floor(response_window_start * Fs)+1;
response_window_stop_samp = floor(response_window_stop * Fs);

% background_window_start_samp = floor(background_window_start * Fs) + 1;
% background_window_stop_samp = floor(background_window_stop * Fs);


% discard extra trials
avg_eps = avg_eps(start_orientation:end,:,1:min_count,:,:);


responses = zeros(num_shuffle,number_x_levels, number_y_levels, num_channels);

for shuffle = 1:num_shuffle
    
    selection_matrix = randperm(min_count);
    selection_matrix = selection_matrix(1:subsample_size);
    
    for x = 1:number_x_levels
        for y = 1:number_y_levels
            % grab the data for one coordinate and average
            ep = mean(avg_eps(x,y,selection_matrix,:,response_window_start_samp:response_window_stop_samp),3);
            ep = reshape(ep,size(ep,4),size(ep,5));
            responses(shuffle,x,y,:) = std(ep,0,2)';   % calculate the standard deviation
        end
    end
    
end


for shuffle = 1:num_shuffle
    
    spacer_pix = 1;
    
    big_map = zeros( (number_x_levels + spacer_pix) * numCol, (number_y_levels + spacer_pix) * numRow);
    
    min_vals = zeros(1,numRow*numCol);
    max_vals = zeros(1,numRow*numCol);
    
    for chan = 1:numRow*numCol
        col = ceil(chan / numRow);
        row = chan - (col - 1)*numRow;
        
        iso = responses(shuffle,:,:,chan);
        iso = reshape(iso,number_x_levels,number_y_levels);
        
        % normalize each response
        min_vals(chan) = min(min(iso));
        max_vals(chan) = max(max(iso));
        %iso_norm = (iso - min(min(iso))) ./ (max(max(iso)) - min(min(iso)));
        
        x = (col-1)*(number_x_levels+spacer_pix)+1;
        y = (row-1)*(number_y_levels+spacer_pix)+1;
        
        %big_map_norm(x:x+number_x_levels-1 , y:y+number_y_levels-1) = iso_norm;
        big_map(x:x+number_x_levels-1 , y:y+number_y_levels-1) = iso;
        
        
    end
    
    
    % figure(1)
    % imagesc(big_map_norm')
    %
    % figure(2)
    % imagesc(big_map')
    
    figure(3)
    set(3,'Position',scrsz)
    sorted_mins = sort(min_vals);
    min_val = sorted_mins(round(size(sorted_mins,2)*0.05))
    
    sorted_maxs = sort(max_vals);
    max_val = sorted_maxs(round(size(sorted_maxs,2)*0.95))
    imagesc(big_map', [min_val max_val]);
    
    title_str = strcat(NAME,' start ',num2str(response_window_start,'%6.2f'),' stop ',num2str(response_window_stop,'%6.2f'), ' shuffle ', num2str(shuffle),' recept field');
    title(title_str);
    
    if strcmp(save_fig, 'TRUE')
    fileString = strcat('.\figures\',title_str,'.png');
    set(gcf,'PaperPositionMode','auto')
    print(gcf, '-dpng', fileString, '-r 300')
    end
    
    frame = 1;
    
    if strcmp(movie_en, 'FALSE')
        num_samp = 1;
    end
    
   if strcmp(movie_en, 'TRUE')    
    % average all the evoked responses
    mean_ep = mean(avg_eps(:,:,:,1:numRow*numCol,:),3);
    min_ep = min(mean_ep,[],5);      % take the minimum over all the samples
    min_ep = sort(min_ep(:));       % sort the minimum values
    min_val = min_ep(round(size(min_ep(:),1) * 0.02)) % take the 1% voltage as min
 
    max_ep = max(mean_ep,[],5);      % take the maximum over all the samples, for each channel, each location
    max_ep = sort(max_ep(:));       % sort the maximum values
    max_val = max_ep(round(size(max_ep(:),1) * 0.98)) % take the 99% voltage as max

%     

     min_val = -1e-4;
%      min_val = 0;
     max_val = 2e-4;
   end
%     
    
    for samp = 1:num_samp
        
        
        big_map = ones( (numRow + spacer_pix) * number_y_levels, (numCol + spacer_pix) * number_x_levels) .* min_val;
        
        for x = 1:number_x_levels
            for y = 1:number_y_levels
                
                
                
                if strcmp(movie_en, 'TRUE')
                    iso = avg_eps(x,y,:,1:numRow*numCol,samp);
                    iso = -mean(iso,3);
                else
                    iso = responses(shuffle,x,y,1:numRow*numCol);
                end
                
                iso = reshape(iso,numRow,numCol);
                 
                % normalize each response
                %min_vals(x,y) = min(min(iso));
                %max_vals(x,y) = max(max(iso));
                %iso_norm = (iso - min(min(iso))) ./ (max(max(iso)) - min(min(iso)));
                
                col = (x-1)*(numCol+spacer_pix)+1;
                row = (y-1)*(numRow+spacer_pix)+1;
                
                %big_map_norm(x:x+number_x_levels-1 , y:y+number_y_levels-1) = iso_norm;
                big_map(row:row+numRow-1,col:col+numCol-1) = iso;
                
            end
            
        end
        
        figure(4)
        if number_y_levels > 1
            %set(4,'Position',scrsz)
            set(4,'Position',[1 50 1280 800])
        else
            set(4,'Position',[scrsz(1) 500 scrsz(3) scrsz(4)/5])
        end
        %sorted_mins = sort(min_vals);
        %min_val = sorted_mins(round(size(sorted_mins,2)*0.05));
        
        
        %sorted_maxs = sort(max_vals);
        %max_val = sorted_maxs(round(size(sorted_maxs,2)*0.95));

        

        imagesc(big_map, [min_val max_val]);
        colorbar
        
        if strcmp(movie_en, 'TRUE')
            
            title_str = strcat(NAME,' time  ',num2str(samp / Fs,'%6.2f'), ' seconds');
        else
            title_str = strcat(NAME,' start ',num2str(response_window_start,'%6.2f'),' stop ',num2str(response_window_stop,'%6.2f'), ' shuffle ', num2str(shuffle),' full array');
        end
        title(title_str);
        
        M(frame) = getframe(gcf);
        frame = frame + 1;
        
        
        if strcmp(movie_en, 'FALSE')
            fileString = strcat('.\figures\',title_str,'.png');
            set(gcf,'PaperPositionMode','auto')
            print(gcf, '-dpng', fileString, '-r 300')
        end
    end
end

% if saving data
if strcmp(save_mov, 'TRUE')
[PATHSTR,NAME,EXT,VERSN] = fileparts(filename);
    
    mkdir(strcat(PATHSTR, '\movies'));
    
    title_str = strcat(NAME,' start ',num2str(response_window_start,'%6.2f'),' stop ',num2str(response_window_stop,'%6.2f'));
    %title(title_str);
    
    fileString = strcat(strcat(PATHSTR, '\movies\'),title_str,'.avi');
    
    disp(['Writing out movie ' fileString])
    
    movie2avi(M,fileString, 'COMPRESSION', 'none', 'FPS', 5);
    
end
    



% figure(4)
% imagesc(big_map', [median(min_vals) median(max_vals)])


% for chan = 1:num_channels
%     for shuffle = 1:num_shuffle
%
%         iso = responses(shuffle,:,:,chan);
%         iso = reshape(iso,number_x_levels,number_y_levels);
%         subplot(3,3,shuffle)
%         imagesc(iso)
%
%     end
%
%     [ax4,h3]=suplabel(strcat('Column ', num2str(ceil(chan / numRow)), ' Row ', num2str(chan - (ceil(chan / numRow) - 1)*numRow )),'t');
%     set(h3,'FontSize',30)
%
%     if strcmp(save_fig, 'TRUE')
%         fileString = strcat('.\figures\',NAME,'_chan_',num2str(chan),'.png');
%         set(gcf,'PaperPositionMode','auto')
%         print(gcf, '-dpng', fileString, '-r 100')
%     else
%         pause
%     end
%
%
% end
%








%     [y, idx] = max(response_ratios, [], 1);
%
%     iso = reshape(idx(1:numRow*numCol),numRow,numCol);
%
%     % knock out bad columns
%     iso(:,[9 12]) = 0;
%
%     % knock out bad rows
%     iso([6],:) = 0;
%
%     % smooth
%     iso2 = filter2(h, iso);
%
%     % replace bad columns in the original data with the smoothed data from
%     % above
%     iso(:,[9 12]) = (3/2) * iso2(:,[9 12]);
%     iso([6],:) = (3/2) * iso2([6],:);
%
%     % plot the new combined data
%     imagesc(iso);
%     colorbar
%
%
%
%
%     figure(2)
%     subplot(3,3,shuffle)
%     rad_scale = repmat( -pi+pi/4:pi/4:pi, size(response_ratios,2), 1)';
%     [x, y] = pol2cart(rad_scale,response_ratios);
%     x = sum(x,1);
%     y = sum(y,1);
%
%     [th, r] = cart2pol(x,y);
%     degrees = radtodeg(th);
%
%     iso = reshape(degrees(1:numRow*numCol),numRow,numCol);
%
%     % knock out bad columns
%     iso(:,[9 12]) = 0;
%
%     % knock out bad rows
%     iso([6],:) = 0;
%
%     % smooth
%     iso2 = filter2(h, iso);
%
%     % replace bad columns in the original data with the smoothed data from
%     % above
%     iso(:,[9 12]) = (3/2) * iso2(:,[9 12]);
%     iso([6],:) = (3/2) * iso2([6],:);
%
%     % plot the new combined data
%     imagesc(iso);
%     colorbar
%
%
%
% end
%     if strcmp(save_fig, 'TRUE')
%         figure(1)
%         fileString = strcat('.\figures\',NAME,'_discrete_angle.png');
%         set(gcf,'PaperPositionMode','auto')
%         print(gcf, '-dpng', fileString, '-r 300')
%     end
%
%     if strcmp(save_fig, 'TRUE')
%         figure(2)
%         fileString = strcat('.\figures\',NAME,'_continuous_angle.png');
%         set(gcf,'PaperPositionMode','auto')
%         print(gcf, '-dpng', fileString, '-r 300')
%     end
%
end

