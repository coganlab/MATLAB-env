

function demux_data = demux_data_ch(data,sampRate, NumRows, Osr)

% demux code.... 

% Consts
%sampRate = 50000;         % Raw sampling rate
%Osr = 2;            % Oversampling rate (how many times faster the a2d runs than the muxing speed)
%NumRows = 18;       % How many signals are muxed together
StartVal = 2;       % Which sample to take or start on
Discard = floor(sampRate / (Osr * NumRows)) * Osr * NumRows;
%Discard = 49968;    % Discard the first ~ second (we acquire in this many samples per round)
%NumChans = 20;      % Number of analog channels


% Variables
lastSample = Discard - StartVal + 1;


% Discard the first ~ second of data since it is garbage before the d2a
% starts
data = data(Discard+1:end)';

% Reshape based on OSR to 2d array
data = reshape(data(StartVal:end-lastSample,:),Osr,size(data(StartVal:end-lastSample),1)/Osr);

% take the 2nd value to the end.
% if OSR = 2, this is not good, because the 2nd value may have already
% started to change by the time the later channels get to it
% if OSR = 3, then we should just take the 2nd value to be safe
% If OSR > 3,  we can average the values that are not the first or the last
data = data(2:Osr - 1,:); % discards 1st and last row

% if OSR > 3, average data
if (size(data,1) ~= 1)
    data = mean(data,1);
end

% demultiplex rows now
demux_data = reshape(data,NumRows,size(data,2)/NumRows);

end