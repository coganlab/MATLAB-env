

function demux_data(filename,Fs, NumChans, NumRows, Osr)

% demux code.... Only good for OSR = 2!

% Consts
%Fs = 50000;         % Raw sampling rate
%Osr = 2;            % Oversampling rate (how many times faster the a2d runs than the muxing speed)
%NumRows = 18;       % How many signals are muxed together
StartVal = 2;       % Which sample to take or start on
Discard = floor(Fs / (Osr * NumRows)) * Osr * NumRows;
%Discard = 49968;    % Discard the first ~ second (we acquire in this many samples per round)
%NumChans = 20;      % Number of analog channels

% clear data
data = [];

% Variables
lastSample = Discard - StartVal + 1;

% Get file parts
[pathstr, name, ext, versn] = fileparts(filename);

load(filename);  % load the data

% Loop over all channels
for i = 0:NumChans-1
    
    % First channel is not Untitled0, so need to adjust
    if i == 0
        data2 = Untitled.data;
    else
        data2 = eval(['Untitled' num2str(i) '.data']);
    end
    
    % Discard the first ~ second of data since it is garbage before the d2a
    % starts
    data2 = data2(Discard+1:end);
    
    % Reshape based on OSR to 2d array
    data2 = reshape(data2(StartVal:end-lastSample,:),Osr,size(data2(StartVal:end-lastSample),1)/Osr);
    
    % take the 2nd value to the end. 
    % if OSR = 2, this is not good, because the 2nd value may have already
    % started to change by the time the later channels get to it
    % if OSR = 3, then we should just take the 2nd value to be safe
    % If OSR > 3, I think we can average the values that are not the first
    % or the last
    data2 = data2(2:Osr - 1,:);
    
    if (size(data2,1) ~= 1)
        %keyboard    % not yet tested on osr > 3
        data2 = mean(data2,1);
    end
    
    % demultiplex rows now
    data2 = reshape(data2,NumRows,size(data2,2)/NumRows);
    
    % Grow...
    data = [data; data2];
    
end

% new filename
filename = [name '_demux'];

% save to disk
save(filename,'data', '-v7.3');

end