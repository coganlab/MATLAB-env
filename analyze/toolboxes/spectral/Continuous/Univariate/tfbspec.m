% TFBSPEC Drop in replacement for tfspec using "basic" Hann windows
% vim: ts=4:sw=4:expandtab
function [y,nil]=tfbspec(x, window, sampling, dn, fk, pad, pval, flag, contflag, errorbar)
disp('WARNING: SLEPIAN WINDOWS DISABLED');

for iCh=1:size(x,1)
    %y(iCh,:,:) = spectrogram(x(iCh,:),hann(50), 0)';
    y(iCh,:,:) = stft_hann(x(iCh,:));    
end 
    y = abs(y);

nil = [];

end



function z=stft_hann(x)
    nWinLen = 1500;
    nHalfWinLen = floor(nWinLen/2);
    nWinStep = nWinLen;
    nDataLen = length(x);
    nAnalWindow = hann(nWinLen);
    
    nSteps = floor((nDataLen - nWinLen)/nWinStep);
    z=zeros(nSteps,nWinLen);
    %z=zeros(nSteps,nWinLen+1450);

    
    
    for iStep=1:nSteps
        start = ((iStep-1).*nWinStep)+1;
        stop  = start + nWinLen - 1;
        
        %data = [x(start:stop).*nAnalWindow' zeros(1,1450)];
        %z(iStep, :) = fft(data);
        
        z(iStep, :) = fft(x(start:stop).*nAnalWindow');
    end
end