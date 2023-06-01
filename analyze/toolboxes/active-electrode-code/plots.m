function plots(data, numCol, numRow, startCol, stopCol, Fs, minValV, maxValV, pub_fig, lineXpos, lineXsize, lineYpos, lineYsize, bgColor, lineColor, scalebarColor )

%meanEP = zeros(24,size(avg_eps,2));

screen_size = get(0, 'ScreenSize');
% pub_fig = 'TRUE';

if exist('pub_fig', 'var') == 0
 pub_fig = 'FALSE';
end 

if exist('bgColor', 'var') == 0
 bgColor = 'white';
end 

if exist('lineColor', 'var') == 0
 lineColor = 'red';
end 

if exist('scalebarColor', 'var') == 0
 scalebarColor = 'black';
end 

% lineXpos = 6;   % position of scale bar origin in seconds
% lineXsize = 0.5;  % size of horizontal scale bar in seconds
% lineYpos = 1e-3;    % position of scale bar origin in volts
% lineYsize = 2e-3;   % size of vertical scale bar in volts

for i = startCol:stopCol
    %figure(i)
    
    % Mean EP per analog channel
    % toplot = mean(avg_eps((i-1)*72+1:i*72,:),1);
    
    x = 0:1/Fs:size(data,2)/Fs-1/Fs;
    % Plot mean raw data per analog channel
    %toplot = mean(dataf((i-1)*72+1:i*72,:),1);
    % meanEP(i,:) = toplot;
    
    % Plot all EPs
    %toplot = avg_eps((i-1)*72+1:i*72,:)';
    
    
    %plot(data((i-1)*numRow+1:i*numRow,:)');
    
    
    
    
    for j = 1:numRow
        figure(j)
        %set(j, 'Position', [0 0 screen_size(3) screen_size(4) ] );
        set(j, 'Position', [0 100 screen_size(3) 500 ] );
        
        %set(j,'Position',[1 100 1920 500])
        
        titleString = strcat('Col ',num2str(i),' Row ',num2str(j));
        
        if strcmp(pub_fig, 'TRUE')
            set(j, 'color', bgColor);
            plot(x,data((i-1)*numRow+j,:),'LineWidth',4,'Color',lineColor)
            line([lineXpos lineXpos+lineXsize], [lineYpos lineYpos], 'LineWidth',6, 'Color', scalebarColor)
            line([lineXpos lineXpos]          , [lineYpos lineYpos+lineYsize], 'LineWidth',6, 'Color', scalebarColor)
            axis off
        else
            plot(x,data((i-1)*numRow+j,:))
            title(titleString);
            xlabel('Seconds')
            ylabel('Volts')            
            
        end
        
        if (exist('minValV', 'var') == 1) && (size(minValV,1) > 0)
            ylim([minValV maxValV])
        end
        
        
        %num_orientations = size(data,1);
        %plotdata = reshape(data(:,(i-1)*numRow+j,:), num_orientations, size(data,3));
        %plot(x,plotdata)
        
  
    end
    
    
    pause
    
end