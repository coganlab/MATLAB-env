
function [rmsVals, delay_map] = plot_sparse_noise_ep(eps, filename, numRow, numCol, Fs, response_window_start, response_window_stop, plot_en, save_fig)

% pull electrode data out  (no negate, already done elsewhere)
eps2 = eps;
eps = eps(:,:,:,1:numRow*numCol,:);

meanEp = mean(eps,3);       % average data

% starting sample, stopping sample
response_window_start_samp = floor(response_window_start * Fs)+1;
response_window_stop_samp = floor(response_window_stop * Fs);

% calculate standard deviation (RMS)
rmsVals = std(meanEp(:,:,:,:,response_window_start_samp:response_window_stop_samp),0,5);
rmsVals = reshape(rmsVals,size(rmsVals,1),size(rmsVals,2), size(rmsVals,4));

% find saturation values
sorted = sort(rmsVals(:));
rms_minVal = sorted(round(size(sorted,1) * 0.005));
rms_maxVal = sorted(round(size(sorted,1) * 0.995));
rmsVals(rmsVals < rms_minVal) = rms_minVal;     % saturate min
rmsVals(rmsVals > rms_maxVal) = rms_maxVal;     % saturate max

screen_size = get(0, 'ScreenSize');


%%%%%%%%%%%%%%%%  Calculate delays %%%%%%%%%%%%%%%%%%
interp_factor = 12;
delay_map = zeros(size(eps,1),size(eps,2),size(meanEp,4));

for y = 1:size(eps,2)
    for x = 1:size(eps,1)
        % grab the evoked response data to work on, one display coord at a time
        ep = reshape(meanEp(x,y,:,:,response_window_start_samp:response_window_stop_samp),size(meanEp,4), response_window_stop_samp - response_window_start_samp + 1);
        
        % interpolate the data
        signal = zeros(size(ep,1), size(ep,2) * interp_factor);
        for k = 1 : size(ep,1)
            signal(k,:) = interp(ep(k,:), interp_factor);
        end
        
        % find the minimum point
        [epMin idx] = min(signal,[],2);
        rmsVal = rmsVals(x,y,:);
        rmsVal = reshape(rmsVal,1,size(rmsVal,3));
        
        % convert to milliseconds
        idx = (idx ./ (Fs * interp_factor)) * 1000;
        idx = idx + response_window_start * 1000;       % add in start delay
        
        % threshold and only take channels with significant RMS power
        %thresh = 4.5e-5;
        thresh = rms_maxVal / 2;
        idx(rmsVal < thresh) = NaN;       % threshold by rms values
        %idx(epMin > -1e-4) = NaN;       % threshold by minimum voltage
        
        % build delay map
        delay_map(x,y,:) = idx;
        
        %         t = 0:1/(Fs*interp_factor):(size(signal,2)-1)*1/(Fs*interp_factor);
        %         t = t + response_window_start;
        %
        %         if sum(rmsVal >= thresh) > 0
        %             figure(4)
        %             clf
        %             plot(t,signal((rmsVal >= thresh),:)')
        %             xAvg = mean(signal((rmsVal >= thresh),:),1);
        %             hold on
        %             plot(t,xAvg,'LineWidth',6,'color','black')
        %             hold off
        %             pause
        %         end
        
    end
end

sorted = sort(delay_map(:));
sorted = sorted(isnan(sorted) == 0);
delay_minVal = sorted(round(size(sorted,1) * 0.02));
delay_maxVal = sorted(round(size(sorted,1) * 0.98));

% set all NaNs to minVal
delay_map(delay_map < delay_minVal) = delay_minVal;     % saturate min
delay_map(delay_map > delay_maxVal) = delay_maxVal;     % saturate max
nan_sub = 1;
delay_map(isnan(delay_map)) = delay_minVal - nan_sub;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%% Raw EP figure %%%%%%%%%%%%%%%%%
if strcmp(plot_en, 'TRUE')
    f1 = figure(1);
    set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    clf
    
    count = 0;
    t = 0:1/Fs:(size(eps,5)-1)*1/Fs;
    
    for y = 1:size(eps,2)
        for x = 1:size(eps,1)
            count = count + 1;
            subplot(size(eps,1),size(eps,2), count)
            plot(t,reshape(mean(meanEp(x,y,:,:,:),4),1,size(t,2)))
            axis([0 0.26 -1e-4 1e-4])
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%% RMS Figure %%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(plot_en, 'TRUE')
    f2 = figure(2);
    set(f2, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    clf
    
    count = 0;
    for y = 1:size(eps,2)
        for x = 1:size(eps,1)
            % plot the source data
            count = count + 1;
            h = subplot(size(eps,2),size(eps,1),count);
            
            p = get(h, 'pos');
            p(3) = p(3) + 0.014;        % width extension
            p(4) = p(4) + 0.020;        % height extension
            set(h, 'pos', p);
            
            % saturate min
            iso = rmsVals(x,y,:);
            
            % test code
            iso = reshape(squeeze(std(mean(eps2(x,y,:,1:numRow*numCol,11:44),3),0,5)),numRow,numCol);
            imagesc(iso, [rms_minVal  rms_maxVal] )
            set(gca,'XTick',[]);
            set(gca,'YTick',[]);
            colormap(jet(256))
            axis image
             
            
            %test trigger signals
            %plot(reshape(eps2(x,y,:,(24-1)*numRow+1,:),size(eps2,3),size(eps2,5))')
            %ylim([-0.3 5.3])
            %ylim([-5.3 -3.0])
            
            %imagesc(reshape(iso,numRow,numCol), [rms_minVal  rms_maxVal] )
%             set(gca,'XTick',[]);
%             set(gca,'YTick',[]);
%             colormap(jet(256))
%             
            %title(['dist ' num2str(y(j))]);
        end
    end
    
    h = axes('Position', [0.05 0.31 0.91 0.45], 'Visible', 'off');
    caxis([rms_minVal rms_maxVal])
    c=colorbar ('FontSize',16);
    ylabel(c,'standard deviation')
    
    if strcmp(save_fig, 'TRUE')
        mkdir(strcat(pwd,'.\figures\',date));
        [~,name] = fileparts(filename);
        fileString = strcat(pwd,'.\figures\',date,'\',name,'_2dsparse_noise_rms_map.png');
        set(gcf,'PaperPositionMode','auto')
        print(gcf, '-dpng', fileString, '-r 300')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%% Delay Figure %%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(plot_en, 'TRUE')
    f3 = figure(3);
    set(f3, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    clf
    
    count = 0;
    for y = 1:size(eps,2)
        for x = 1:size(eps,1)
            count = count + 1;
            h = subplot(size(eps,2),size(eps,1),count);
            
            p = get(h, 'pos');
            p(3) = p(3) + 0.014;        % width extension
            p(4) = p(4) + 0.020;        % height extension
            set(h, 'pos', p);
            
            % saturate min
            
            imagesc(reshape(delay_map(x,y,:),numRow,numCol),[(delay_minVal-nan_sub) delay_maxVal])
            set(gca,'XTick',[]);
            set(gca,'YTick',[]);
            cmap = colormap(jet(256));
            cmap(1,:) = [0 0 0];    % replace 1st entry with black value for NaN
            colormap(cmap)
            
        end
    end
    
    h = axes('Position', [0.05 0.31 0.91 0.45], 'Visible', 'off');
    caxis([(delay_minVal-nan_sub) delay_maxVal])
    c=colorbar ('FontSize',16);
    ylabel(c,'delay in ms')
    
    if strcmp(save_fig, 'TRUE')
        [~,name] = fileparts(filename);
        fileString = strcat(pwd,'.\figures\',date,'\',name,'_2dsparse_noise_delay_map.png');
        set(gcf,'PaperPositionMode','auto')
        print(gcf, '-dpng', fileString, '-r 300')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


