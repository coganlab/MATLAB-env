function [artTr] = spontFindArtTrials(trDat, sigmaThreshold)

%[data_corrected] = spontFintArtTrials(data, sigmaThreshold)
% remove artifacts in trial-sorted time-series data. Identifies artifacts as times when
% signal exceeds sigmaThreshold STD from the mean. Returns logical
% identifying trials with artifacts

%INPUTS: 
%trDat - array of data (channels x time x trials)
%sigmaThreshold - scalar with # STD from mean to use for artifact ID
%
%OUTPUTS: 
%dartTr - logical (ch x tr), 1 = has artifact; 0 = fine

%calculate mean, STD on full time-series (i.e. not on single-trial basis)
tmp = reshape(trDat, [size(trDat,1) size(trDat,2)*size(trDat,3)]);
datSTD  = std(tmp, [], 2);
datMean = mean(tmp, 2);

tmp = repmat(datMean + sigmaThreshold*datSTD, [1, size(trDat,2), size(trDat,3)]);
hitThresh = abs(trDat) > tmp;
artTr = sq( any( hitThresh, 2));


