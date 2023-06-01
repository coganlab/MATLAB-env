function psd_plot(data, row, col, numRow, numCol, numChan, Fs, save_fig, pathStr, filename)

figure;

% grab channel of interest
data = reshape( data, numRow , numChan , size(data,2) );
data = squeeze(data(row,col,:));

disp(['  Noise on row ' num2str(row) ' col ' num2str(col) ' (V RMS) :' num2str(std(data)) ]);




nfft = 2^nextpow2(length(data));
Pxx = abs(fft(data, nfft)).^2/length(data)/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);


% setup output folder and filename
if strcmp(save_fig, 'TRUE')
    dateString = datestr(now, 29);  % get date in yyyy-mm-dd form for output folder
    [~,name] = fileparts(filename);
    mkdir([pathStr,'\Figures ',dateString]);
end

    titleStr = 'Power Spectral Density';
        
    if strcmp(save_fig, 'TRUE')
        fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
        saveas(gcf, fileString, 'fig')
    end



end
