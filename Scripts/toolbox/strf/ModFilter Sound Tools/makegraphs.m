function[]=makegraphs(whichgraph, whichfile);

% makegraphs creates spectrograms and other graphs from data obtained when
% using modfilter (usually stored in folder DataFiles). Whichfile is the name of the .mat file storing the 
% data, and is created when modfilter is run. 

figurefile = sprintf('%s', whichfile); 
load(figurefile);
DBSPECT = 50;
DBNOISE = 80;

switch whichgraph
    
    case 1 %Create Spectrogram
        maxsabs = max(max(sabs));
        ph = imagesc(toInitial, foInitial, sabs, [maxsabs-DBSPECT maxsabs]);
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        axis xy;
        ylim([0 10000])
        cmap = spec_cmap();
        colormap(cmap);
        title('Initial Spectrogram');
        xlabel('Time(s)');
        ylabel('Frequency(Hz)');
        colorbar;

    case 2 %Display initial amplitude spectrum 
        meanf = mean(sabs');
        meant = mean(sabs);
        nb = size(sabs,1);
        nt = length(toInitial);
        % calculate the 2D fft
        fabs = fft2(sabs);   
        % calculate amplitude and phase
        amp_fabs = abs(fabs);
        phase_fabs = angle(fabs);
        amp_fabs = 20*log10(amp_fabs);
        max_amp_fabs = max(max(amp_fabs));
        DBAMPMOD = 50;
        ph = imagesc(fftshift(dwtInitial), fftshift(dwfInitial).*1000, fftshift(amp_fabs), [max_amp_fabs-DBAMPMOD max_amp_fabs]);
        title('Initial Amplitude Spectrum');
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        axis xy;
        axis([-50 50 0 10]);
        cmap = spec_cmap();
        colormap(cmap);
        xlabel('Temporal Modulation (Hz)');
        ylabel('Spectral Modulation (cycl/kHz)');
        colorbar;
        
    case 3 %display initial phase spectrum 

        meanf = mean(sabs');
        meant = mean(sabs);
        % calculate the 2D fft
        fabs = fft2(sabs);   
        % calculate amplitude and phase
        phase_fabs = angle(fabs);

        ph = imagesc(fftshift(dwtInitial), fftshift(dwfInitial).*1000, fftshift(phase_fabs));
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        title('Initial Phase Spectrum');
        axis xy;
        axis([-50 50 -16 16]);
        cmap = colormap('HSV');
        cmap(1,:) = [1 1 1];
        colormap(cmap);
        xlabel('Temporal Modulation (Hz)');
        ylabel('Spectral Modulation (cycl/kHz)');
        colorbar;
        
    case 4 %Resultant Amplitude Spectrum 
        savednewamp_fabs = 20*log10(savednewamp_fabs);
        max_newamp_fabs=max(max(savednewamp_fabs));
        DBAMPMOD = 50;
        ph = imagesc(fftshift(dwtInitial), fftshift(dwfInitial).*1000, fftshift(savednewamp_fabs),[max_newamp_fabs - DBAMPMOD max_newamp_fabs]);
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        title('Resultant Amplitude Spectrum');
        axis xy;
        axis([-50 50 0 10]);
        cmap = spec_cmap();
        colormap(cmap);
        xlabel('Temporal Modulation (Hz)');
        ylabel('Spectral Modulation (cycl/kHz)');
        colorbar;
        
    case 5  %Resultant Phase Spectrum: 
       
        ph = imagesc(fftshift(dwtInitial), fftshift(dwfInitial).*1000, fftshift(savednewphase_fabs));
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        title('Resultant Phase Spectrum');
        axis xy;
        axis([-50 50 -16 16]);
        cmap = colormap('HSV');
        cmap(1,:) = [1 1 1];
        colormap(cmap);
        xlabel('Temporal Modulation (Hz)');
        ylabel('Spectral Modulation (cycl/kHz)');
        colorbar;
      
    case 6 %Plot Mean Amplitude vs Frequency
        new_fabs = savednewamp_fabs.*exp(complex(0,savednewphase_fabs));
        new_sabs = real(ifft2(new_fabs));
        meanf = mean(sabs');
        new_meanf = mean(new_sabs,2)';
        ph = plot(meanf,'k');
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        hold on;
        plot(new_meanf,'r');
        hold off;
        title('Mean amplitude vs Frequency');
        
    case 7 %Plot Mean amplitude vs Time
        new_fabs = savednewamp_fabs.*exp(complex(0,savednewphase_fabs));
        new_sabs = real(ifft2(new_fabs));
        meant = mean(sabs);
        new_meant = mean(new_sabs);
        ph = plot(meant,'k');
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        hold on;
        plot(new_meant,'r');
        hold off;
        title('Mean amplitude vs Time');
        
   case 8 %Desired Spectrogram:
        new_fabs = savednewamp_fabs.*exp(complex(0,savednewphase_fabs));
        new_sabs = real(ifft2(new_fabs));;
        maxnew_sabs = max(max(new_sabs));
        ph = imagesc(toInitial, foInitial, new_sabs, [maxnew_sabs-DBSPECT maxnew_sabs]);
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        cmap = spec_cmap();
        colormap(cmap);
        title('Desired Spectrogram');
        ylim([0 10000]);
        axis xy;
        xlabel('Time(s)');
        ylabel('Frequency(Hz)');
        colorbar;
        
    case 9 %Obtained Spectrogram 
        maxobtained_sabs = max(max(obtained_sabs));
        ph = imagesc(toObtained, foObtained, obtained_sabs, [maxobtained_sabs-DBSPECT maxobtained_sabs]);
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        title('Obtained Spectrogram');
        xlabel('Time(s)');
        ylabel('Frequency(Hz)');
        cmap = spec_cmap();
        colormap(cmap);
        ylim([0 10000])
        axis xy;
        xlabel('Time(s)');
        ylabel('Frequency(Hz)');
        colorbar;

    case 10 % Obtained Amplitude Spectrum 
        ofabs = fft2(obtained_sabs);
        amp_ofabs = abs(ofabs);
        amp_ofabs = 20*log10(amp_ofabs);
        max_amp_ofabs = max(max(amp_ofabs));
        DBAMPMOD = 50;
        ph = imagesc(fftshift(dwtInitial), fftshift(dwfInitial).*1000, fftshift(amp_ofabs),[max_amp_ofabs - DBAMPMOD max_amp_ofabs]);
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        title('Obtained Amplitude Spectrum');
        axis xy;
        axis([-50 50 0 10]);
        cmap = spec_cmap();
        colormap(cmap);
        xlabel('Temporal Modulation (Hz)');
        ylabel('Spectral Modulation (cycl/kHz)');
        colorbar;
    case 11 % Obtained Phase Spectrum 
        ofabs = fft2(obtained_sabs);
        phase_ofabs = angle(ofabs);
        ph = imagesc(fftshift(dwtInitial), fftshift(dwfInitial).*1000, fftshift(phase_ofabs));
        set(get(ph, 'Parent'), 'Position', [0.1790    0.1200    0.7394    0.6459]);
        title('Obtained Phase Spectrum');
        axis xy;
        axis([-50 50 -16 16]);
        cmap = colormap('HSV');
        cmap(1,:) = [1 1 1];
        colormap(cmap);
        xlabel('Temporal Modulation (Hz)');
        ylabel('Spectral Modulation (cycl/kHz)');
        colorbar();
end
