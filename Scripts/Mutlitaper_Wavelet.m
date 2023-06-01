logy = 0; %?
xscaling = 0.5; %?

            nRep=size(testsig,1);
            
            tvals=256:32:5888-256;

 cfg =[];

    % we use logspaced frequencies from 4 to 181 Hz
    cfg.foi = logspace(log10(4),log10(181),23);

    % The windows should have 3/4 octave smoothing in frequency domain
    cfg.tapsmofrq = (cfg.foi*2^(3/4/2) - cfg.foi*2^(-3/4/2)) /2; % /2 because fieldtrip takes +- tapsmofrq

    % The timewindow should be so, that for freqs below 16, it results in n=1
    % Taper used, but for frequencies higher, it should be a constant 250ms.
    % To get the number of tapers we use:  round(cfg.tapsmofrq*2.*cfg.t_ftimwin-1)
    cfg.t_ftimwin = [2./(cfg.tapsmofrq(cfg.foi<16)*2),repmat(0.25,1,length(cfg.foi(cfg.foi>=16)))];

    max_tapers = ceil(max(cfg.t_ftimwin.*cfg.tapsmofrq*2));
color_tapers = parula(max_tapers);


for fIdx = 1:length(cfg.t_ftimwin)
    
    timwin = cfg.t_ftimwin(fIdx);
    tapsmofrq = cfg.tapsmofrq(fIdx); % this is the fieldtrip standard, +- the taper frequency
    freqoi = cfg.foi(fIdx);
    
    fsample = 2048/4; % sample Fs 
            % This part is copied together from ft_specest_mtmconvol
            timwinsample = round(timwin .* fsample); % the number of samples in the timewin
            for iT=1:length(tvals);
                testsig2=testsig(:,tvals(iT)-floor(0.5*timwinsample):tvals(iT)+floor(0.5*timwinsample));
                testsig2=testsig2(:,1:timwinsample);

            % get the tapers
            tap = dpss(timwinsample, timwinsample .* (tapsmofrq ./ fsample))';
            tap = tap(1:(end-1), :); % the kill the last one because 'it is weird'

            % don't fully understand, something about keeping the phase
            anglein  = (-(timwinsample-1)/2 : (timwinsample-1)/2)'   .*  ((2.*pi./fsample) .* freqoi);

            % The general idea (I think) is that instead of windowing the
            % time-signal and shifting the wavelet per timestep, we can multiply the frequency representation of
            % wavelet and the frequency representation of the data. this
            % masks all non-interesting frequencies and we can go back to
            % timespace and select the portions of interest. In formula:
            % ifft(fft(signal).*fft(wavelet))
            %
            % here we generate the wavelets by windowing sin/cos with the
            % tapers. We then calculate the spectrum
            wltspctrm = [];
            for itap = 1:size(tap,1)
                coswav  = tap(itap,:) .* cos(anglein)';
                sinwav  = tap(itap,:) .* sin(anglein)';
                wavelet = complex(coswav, sinwav);
                % store the fft of the complex wavelet
                wltspctrm(itap,:) = fft(wavelet,[],2);
            end


%           % We do this nRep times because a single random vector does not
%           have a flat spectrum.
           % datAll = nan(nRep,timwinsample);
            datAll=testsig2;
            for rep = 1:nRep
                sig=datAll(rep,:)';
             %   sig = randi([0 1],timwinsample,1)*2-1; %http://dsp.stackexchange.com/questions/13194/matlab-white-noise-with-flat-constant-power-spectrum
                spec = bsxfun(@times,fft(sig),wltspctrm'); % multiply the spectra 
                datAll(rep,:) = sum(abs(spec),2); %save only the power
            end
            dat = mean(datAll); %average over reps


            % normalize the power
            dat = dat- min(dat);
            dat = dat./max(dat);
            
            
            specALL(iT,fIdx)=mean(dat);
            end
end

            t0 = 0 + fIdx*xscaling;
            t = t0 + dat*timwin/2;
            tNeg = t0 - dat*timwin/2;

            f = linspace(0,fsample-1/timwin,timwinsample);%0:1/timwin:fsample-1;
            if logy
                f = log10(f);
            end
            % this is a bit hacky violin plot, but looks good.
         %   patch([t tNeg(end:-1:1)],[f f(end:-1:1)],color_tapers(2*round(timwin*tapsmofrq),:),'FaceAlpha',.7)
         end

         
         
         
         
         
         
         
         [SPECA, F] = tfspec(testsig, AnalParams.Tapers, experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,AnalParams.pad, [], AnalParams.TrialPooling, [], []);