function [WAVEPAR, spec] = tfwavelet(X, sampling, FREQPAR, waveflag)
% TFWavelet  Moving window time-frequency decomposition using Morlet wavelets
%
% [WAVEPAR, SPEC] = TFWAVELET(X, FREQPAR, sampling, waveflag)
%
% INPUTS:
% X        | Time series array in [Trials,Time] form.
%          |
% FREQPAR  | Structure containing frequency transform parameters
%          | FREQPAR.foi: Frequencies of interest, defaults to 2.^[1:1/4:8]
%          | FREQPAR.bw: Frequency smoothing in fractional octaves, defaults to 0.5
%          |             0.5 octaves roughly correspond to foi/dfoi~5.83
%          |             dfoi = 1/timewin: higher smoothing, shorter time windows
%          |             The size of the analysis window for the
%          |             the distance of the first and last window centers to
%          |             the start and end of the data for all frequencies
%          | FREQPAR.stepsize: Stepsize of the analysis windows in s, defaults to
%          |                   half overlapping windows for the highest frequency
%          | FREQPAR.win_centers: A vector of samples that specify the analysis window centers.
%          |                     Defaults to steps half of the size of the analysis window 
%          |                     for the highest frequency
%          |
%          |
% SAMPLING | Sampling rate of time series X in Hz. Defaults to 1
% WAVELAG  | If 1 spectral decomposition is not done and only WAVEPAR is returned
%
% OUTPUTS:
% WAVEPAR    | Structure containing wavelet parameters
%            | WAVEPAR.foi: Same as FREQPAR.foi
%            | WAVEPAR.bw: Same as FREQPAR.bw
%            | WAVEPAR.dfoi: Bandwidth around center frequencies
%            | WAVEPAR.timewin: Time window size for each frequency in s
%            | WAVEPAR.win_centers: Samples of analysis window centers, not returned with waveflag ==1
% SPEC	     | Spectrum of X in [Trials, Time, Freq] form.
%   Author: David Hawellek, version date April 23, 2013.

ntr = size(X,1); % number of trials/channels
nti = size(X,2); % number of timepoints
if nargin < 4; waveflag = 0;end
if waveflag == 0; tic,fprintf('TFWAVELET: Data Transform\n'); elseif waveflag ==1;tic,fprintf('TFWAVELET: Checking Parameters\n');  end
if nargin <2; sampling = 1; end
if nargin <3
    FREQPAR.foi = 2.^[1:1/4:8]; % % Center frequencies
    FREQPAR.bw = 0.5; % Frequency resolution
    fprintf('Setting foi/bw to default\n');
end
if ~isfield(FREQPAR,'foi'); FREQPAR.foi = 2.^[1:1/4:8]; fprintf('Setting foi to default\n'); end
if ~isfield(FREQPAR,'bw'); FREQPAR.bw = 0.5; fprintf('Setting bw to default\n'); end
if ~isfield(FREQPAR,'win_centers') ; FREQPAR.win_centers = []; fprintf('Setting window centers to default\n'); end

fprintf('%.2fHz to %.2fHz')
% Parameters
foi =  FREQPAR.foi;
bw = FREQPAR.bw;
foi_min = 2*foi/(2^bw+1);
foi_max = 2*foi/(2^-bw+1);
dfoi = foi_max-foi_min; % 2*std in foi domain
timewin = 6/pi./dfoi;
timewin = round(timewin*1000)/1000;
toffset = timewin(1)/2;

% Outpt structure
WAVEPAR.foi = foi;
WAVEPAR.bw = bw;
WAVEPAR.dfoi = dfoi;
WAVEPAR.timewin = timewin;

if waveflag ==1
    fprintf('%.2fHz to %.2fHz with %.2f oct smoothing\n%.2fs largest to %.4fs smallest analysis window\n', foi(1),foi(end),bw,timewin(1),timewin(end))
    dospec = 0;
else
    dospec = 1;
end

if dospec
    if nti < timewin(1).*sampling
        error('At east %.2fs needed for analyzing %.2fHz with the specified parameters\nTrials just have %.2fs. Consider data padding.',timewin(1),foi(1),nti./sampling)
    end
    
    % Parameters in samples
    if isempty(FREQPAR.win_centers)
        tshift = timewin(end)/2;
        nshift = round(tshift*sampling);
        noff = ceil(toffset.*sampling);
        win_centers = noff+1:nshift:nti-(noff+1);
        nsection = numel(win_centers);
    else
        win_centers = FREQPAR.win_centers;
        nsection = numel(win_centers);
    end

    % Update output parameters
    WAVEPAR.win_centers = win_centers;
    
    % Memory allocation
    spec = complex(nan(ntr,nsection,numel(foi),'single'));
    for ifoi = 1:numel(foi)
        % Define frequency kernel
        n_win   = round(timewin(ifoi)*sampling);
        TAPER   = gausswin(n_win,3)'; TAPER = TAPER/sum(TAPER);
        iEXP    = exp(sqrt(-1) * ((1:n_win)-n_win/2-0.5) /sampling*foi(ifoi)*2*pi);
        KERNEL  = (TAPER.*iEXP).';
        % Transform
        seccount=0;
        for isection = win_centers
            section = double(X(:,isection-floor(n_win/2):isection+ceil(n_win/2)-1));
            seccount=seccount+1;
            spec(:,seccount,ifoi) = single(section*KERNEL);
        end
    end
end
fprintf('done (%.2fs)\n',toc)
