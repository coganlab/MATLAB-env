function [to, fo, logB] = spec(sound_in, fband, samprate, dBScale)
% The Theunissen Lab Spectrogram with Guassian window.  Plots the
% spectrogram and oscillogram of the sound

% Parameters for the Spectrogram
nstd = 6;
twindow = 1000*nstd/(fband*2.0*pi);           % Window length in ms - 6 times the standard dev of the gaussian window
winLength = fix(twindow*samprate/1000.0);  % Window length in number of points
winLength = fix(winLength/2)*2;            % Enforce even window length
increment = fix(0.001*samprate);           % Sampling rate of spectrogram in number of points - set at 1 kHz
f_low=0;                                 % Lower frequency bounds to get average amplitude in spectrogram
f_high=5000;                               % Upper frequency bound to get average amplitude in spectrogram
DBNOISE = dBScale;                          % dB in Noise for the log compression - values below will be set to zero.


% Plot the oscillogram
soundlen = length(sound_in);
subplot(3,1,1);
t=1:soundlen;
t = (t-1).*1000/samprate;
plot(t,sound_in);
xlabel('time (ms)');
s_axis = axis;

% Calculate and plot the spectrogram
subplot(3,1,[2 3]);        
[s, to, fo, pg] = GaussianSpectrum(sound_in, increment, winLength, samprate); 
logB = 20*log10(abs(s));
maxB = max(max(logB));
minB = maxB-DBNOISE;            

imagesc(to*1000,fo,logB);          % to is in seconds
axis xy;
caxis('manual');
caxis([minB maxB]); 
v_axis = axis; 
%v_axis(2)=4.0;
v_axis(1) = s_axis(1);
v_axis(2) = s_axis(2);
v_axis(3)=f_low; 
v_axis(4)=f_high;

axis(v_axis);                                
xlabel('time (ms)'), ylabel('Frequency');
cmap = spec_cmap();
colormap(cmap);

end