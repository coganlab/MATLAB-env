function [noise] = ps_test_demux( filename ) 
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load(filename)
numRow = 18;
OSR = 10;

Fs = 50000 / (numRow * OSR);

start = round(10.1e5/(18*OSR));
stop = round(20.1e5/(18*OSR));

data = data(:,start:stop);
dataf = detrend(data')';
noise = std(dataf') * 1000 * 1000;

noise = reshape(noise,18,12);
noise = mean(noise,1);


% for i = 1:5
%     %figure(i)
%     
%     % Mean EP per analog channel
%     % toplot = mean(avg_eps((i-1)*72+1:i*72,:),1);
%     
%     x = 0:1/Fs:size(data,2)/Fs-1/Fs;
%     % Plot mean raw data per analog channel
%     %toplot = mean(dataf((i-1)*72+1:i*72,:),1);
%     % meanEP(i,:) = toplot;
%     
%     % Plot all EPs
%     %toplot = avg_eps((i-1)*72+1:i*72,:)';
%     
%     
%     %plot(data((i-1)*numRow+1:i*numRow,:)');
%     
%     for j = 1:numRow
%         figure(j)
%         plot(x,dataf((i-1)*numRow+j,:))
%         titleString = strcat('Col ',num2str(i),' Row ',num2str(j));
%         title(titleString);
%         xlabel('Seconds')
%         ylabel('Volts')
%     end
%     
%     
%     pause
%     
% 
% 
% end

