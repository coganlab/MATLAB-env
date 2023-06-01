function dataf = EEGbandstop(data, lowF, highF, Fs)
%BANDPASS Returns a discrete-time filter object.

%
% M-File generated by MATLAB(R) 7.9 and the Signal Processing Toolbox 6.12.
%
% Generated on: 18-Oct-2009 19:22:31
%

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
%Fs = 925.9259;  % Sampling Frequency

N   = 6;   % Order
Fc1 = lowF;   % First Cutoff Frequency
Fc2 = highF;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandstop('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

% Get the transfer function values.
[b_60hz, a_60hz] = tf(Hd);

dataf = zeros(size(data));

for i = 1:size(data,1)
    dataf(i,:) = filtfilt(b_60hz,a_60hz,data(i,:));
end




% [EOF]