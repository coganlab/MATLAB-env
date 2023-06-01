%%
close all
clear all

save_fig = 'TRUE';



numRow = 8;
numCol = 8;
numChan = 8;

pathStr = '\\labreadynas.poly.edu\media\animal data\2014-08-21 Froemke Lab Rat Experiment-DDC';
%pathStr = 'C:\Users\jviventi\Dropbox\2014-08-21 Froemke Lab Experiment';
%filename = '1.5khz-r3-saline-noise-e12.ndata.mat';
%filename = '3khz-r3-saline-noise-e12.ndata.mat';
%filename = '6khz-r3-saline-noise-micro-e2.ndata.mat';
%filename = '6khz-noise-r1-e3-normal-01.ndata.mat';
%filename = '6khz-noise-r3-e3-normal-01.ndata.mat';
filename = '6khz-noise-r3-e3-normal-01-unplugged.ndata.mat';
%filename = '5khz-noise-r3-e12-cap-01-unplugged.ndata.mat';
%filename = '5khz-noise-r1-e12-cap-01-unplugged.ndata.mat';

%filename = '1.5khz-r3-saline-sine-40hz-e12.ndata.mat';
%filename = '3khz-r3-saline-sine-40hz-e12.ndata.mat';
%filename = '6khz-r3-saline-sine-40hz-e12.ndata.mat';
%filename = '6khz-r3-saline-sine-5hz-e12.ndata.mat';
%filename = '6khz-r3-saline-sine-40hz-e12.ndata.mat';
%filename = '6khz-r3-saline-sine-100hz-e12.ndata.mat';

if strfind(filename, '1.5khz')
    Fs = 1500;
end

if strfind(filename, '3khz')
    Fs = 3000;
end

if strfind(filename, '5khz')
    Fs = 5000;
end

if strfind(filename, '6khz')
    Fs = 6000;
end


load([pathStr '\' filename])

data = raw_data';
clear raw_rata;
close all

pathStr = 'C:\Users\jviventi\Dropbox\2014-08-21 Froemke Lab Experiment';

% setup output folder and filename
if strcmp(save_fig, 'TRUE')
    dateString = datestr(now, 29);  % get date in yyyy-mm-dd form for output folder
    mkdir([pathStr,'\Figures ',dateString]);
end

noise_low = 2e-17;
noise_high = 2e-15;

[noise, meanVal, medianVal, dataf]  = current_noise_test(data, numRow, numCol, numChan, Fs, pathStr, filename, noise_low, noise_high);

%%
close all



pathStr = '\\labreadynas.poly.edu\media\animal data\2014-08-21 Froemke Lab Rat Experiment-DDC';
%filename = '1.5khz-r3-saline-sine-40hz-e12.ndata.mat';
%filename = '3khz-r3-saline-sine-40hz-e12.ndata.mat';
%filename = '6khz-r3-saline-sine-40hz-e12.ndata.mat';
%filename = '3khz-r1-saline-sine-5hz-e12.ndata.mat';
%filename = '3khz-r1-saline-sine-40hz-e12.ndata.mat';
%filename = '6khz-r3-saline-sine-1.26mV-5Hz-micro-e2.ndata.mat';
%filename = '6khz-r3-saline-sine-1.26mV-100Hz-micro-e2.ndata.mat';
%filename = '6khz-r3-saline-sine-1.26mV-100Hz-micro-e2.ndata.mat';
filename = '6khz-70db-r3-e3-normal-04.ndata.mat';

if strfind(filename, '1.5khz')
    Fs = 1500;
end

if strfind(filename, '3khz')
    Fs = 3000;
end

if strfind(filename, '5khz')
    Fs = 5000;
end

if strfind(filename, '6khz')
    Fs = 6000;
end


load([pathStr '\' filename])


data = raw_data';
clear raw_rata;
close all

noise_low = 2e-17;
noise_high = 200e-11;

pathStr = 'C:\Users\jviventi\Dropbox\2014-08-21 Froemke Lab Experiment';
[signal, meanVal, medianVal, dataf]  = current_noise_test(data, numRow, numCol, numChan, Fs, pathStr, filename, noise_low, noise_high);

%%

snr = signal ./ noise;

figure
imagesc(snr)
colorbar
titleStr = ['SNR (ratio) ' filename];
title(titleStr);

if strcmp(save_fig, 'TRUE')
    [~,name] = fileparts(filename);
    fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
    saveas(gcf, fileString, 'fig')
end
