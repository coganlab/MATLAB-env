

% 
% XMIN = round((0.9-.01)*Fs*12);
% XMAX = round((0.9+.025)*Fs*12);
% 
% XMIN_CL = round((0.9-.05)*Fs*12);
% XMAX_CL = round((0.9+.1)*Fs*12);

XMIN = round((1.0)*Fs);
XMAX = round((1.5)*Fs);

XMIN_CL = round((0.1)*Fs);
XMAX_CL = round((1.9)*Fs);

%XMIN = 1;
%XMAX = size(avg_eps,2);


YMIN = -1e-4;
YMAX = 1e-4;


save_fig = 1;

close all;

scrsz = get(0,'ScreenSize');

% 
% numRow = 18;
% numCol = 20;

[PATHSTR,NAME,EXT,VERSN] = fileparts(filename);

mkdir(strcat(NAME,'_figures'))

spacer = 5e-5;
spacer = 0:spacer:spacer*(numRow-1);
spacer = repmat(spacer',1,XMAX_CL-XMIN_CL+1);


for i = 1:25
    figure(1)
    h = gcf;
    set(h,'OuterPosition',[0 0 scrsz(3) scrsz(4)])
    for j = 1:numRow
        
        subplot(4,5,j);
        
        % grab ep for plotting
        signal = avg_eps((i-1)*numRow+j,XMIN:XMAX);
        x_plot = x(XMIN:XMAX);
        
        
        % Power method - RMS power in a window vs background
        %signal1 = rmsPower(avg_eps(i,:),response_window1_start,response_window1_stop);
        
        %background1 = rmsPower(avg_eps(i,:),background_window1_start,background_window1_stop);
        %all_mean_corr(i) = signal1 / background1;
        
        
        % plot average for orientations
        %if plot_en == 1
        plot(x_plot, signal)
        %plot(x_plot, signal,'LineWidth',1,'Color',[0 0 0])
        axis tight
        axis([x_plot(1) x_plot(end) YMIN YMAX])
        % axis off
        
        
        titleString = strcat('Col ',num2str(i),' Row ',num2str(j));
        title(titleString);
    end
    
    if save_fig == 1
        fileString = strcat('.\',NAME,'_figures\individual_col',NAME,'_column_',num2str(i),'.png');
        set(gcf,'PaperPositionMode','auto')
        print(gcf, '-dpng', fileString, '-r 300')
    end
    
    figure(2)
    h = gcf;
    set(h,'OuterPosition',[0 0 scrsz(3) scrsz(4)])
    
    plot(x(XMIN_CL:XMAX_CL),(avg_eps((i-1)*numRow+1:i*numRow,XMIN_CL:XMAX_CL) + spacer)');
    axis tight
    titleString = strcat('Column ',num2str(i));
    title(titleString);
    
    
    if save_fig == 1
        fileString = strcat('.\',NAME,'_figures\multicol_',NAME,'_column_',num2str(i),'_small_time_.png');
        set(gcf,'PaperPositionMode','auto')
        print(gcf, '-dpng', fileString, '-r 300')
    else
        pause
    end
    
end

