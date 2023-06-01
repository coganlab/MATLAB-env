function sparse_rms_plot(eps, numRow, numCol, save_fig)




% find saturation values
eps_rms = eps(:,:,:,1:numRow*numCol);
rms_minVal = min(eps_rms(:));
rms_maxVal = max(eps_rms(:));

delay_map = eps(:,:,:,numRow*numCol+1:end);
delay_minVal = min(delay_map(:));
delay_maxVal = max(delay_map(:));

%%%%%%%%%%%%%% RMS Figure %%%%%%%%%%%%%%%%%%%%%%%%
    figure(2)
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
            
            imagesc(reshape(eps_rms(x,y,:,:,:),numRow,numCol), [rms_minVal  rms_maxVal] )
            set(gca,'XTick',[]);
            set(gca,'YTick',[]);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%% Delay Figure %%%%%%%%%%%%%%%%%%%%%%%%
    figure(3)
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
            
            imagesc(reshape(delay_map(x,y,:),numRow,numCol),[delay_minVal delay_maxVal])
            set(gca,'XTick',[]);
            set(gca,'YTick',[]);
            
        end
    end
    
    h = axes('Position', [0.05 0.31 0.91 0.45], 'Visible', 'off');
    caxis([delay_minVal delay_maxVal])
    c=colorbar ('FontSize',16);
    ylabel(c,'delay in ms')
    
    if strcmp(save_fig, 'TRUE')
        [~,name] = fileparts(filename);
        fileString = strcat(pwd,'.\figures\',date,'\',name,'_2dsparse_noise_delay_map.png');
        set(gcf,'PaperPositionMode','auto')
        print(gcf, '-dpng', fileString, '-r 300')
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%