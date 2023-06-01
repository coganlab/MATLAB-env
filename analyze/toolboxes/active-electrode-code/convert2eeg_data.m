function convert2eeg_data(filename,eeg_chan, eeg_gain)

%filename = strcat(path,'\',files(i).name);   % get filename

load(filename);

demux_afe_data;     % JV hack
data = data ./ 10;  % JV hack

 highpass_Hz = 1;
 lowpass_Hz = 50;

 
 % eeg channel
 %eeg_gain = -2000;
 
 satVal = 0.05; %Volts
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% clip the file
%data = data(:,round(3*Fs):end);

% bandpass the electrode data
data(1:( numRow*numCol),:) = EEGbandpass(data(1: ( numRow*numCol),:), highpass_Hz, lowpass_Hz, Fs);

% clip low pass settling part of the file, take 2x the cut off time
% constant
%data = data(:,round(2*Fs/highpass_Hz):end-round(2*Fs/highpass_Hz));

% Scale EEG channel
eeg = data((eeg_chan-1)*numRow+1:eeg_chan*numRow,:);   
eeg = mean(eeg,1) / eeg_gain;

% just electrode channels
data = data(1:( numRow*numCol),:);
%data = [data;eeg];

% Saturate
data(data > satVal) = satVal;
data(data < -satVal) = -satVal;

eeg(eeg > satVal) = satVal;
eeg(eeg < -satVal) = -satVal;


maxVoltage = max(max(abs([data;eeg])))   % scale by abs max
scaleFactor = (2 ^ 15) / maxVoltage;
data = data .* scaleFactor;
eeg = eeg .* scaleFactor;
uVperBit = (1000000/ scaleFactor)

NumChansPerEEGFile = 144;

% get filename parts
[pathstr, name] = fileparts(filename);

% temp null date / time
numDate = datevec(now);

% put eeg files in their own folders
pathstr = [pathstr '\' name];
mkdir(pathstr);

for i = 1:floor(size(data,1)/NumChansPerEEGFile)
    
    
    % Setup the channel labels
    str = '';
    for j = (i-1)*NumChansPerEEGFile+1:i*NumChansPerEEGFile     % channel labels start with 1, like matlab
        str = strvcat(str, ['Ch' num2str(ceil(j/numRow)) 'R' num2str(j - (ceil(j/numRow)-1) * numRow)]);
    end
    
    str = strvcat(str,'EEG');
    
    
    % channels in matlab start with 1, like labels above
    signal = data((i-1)*NumChansPerEEGFile+1:i*NumChansPerEEGFile,:);
    signal = [signal;eeg];
    
    write2bni(signal,[name '_p' num2str(i)],round(Fs),[numDate(4) numDate(5) numDate(6)],[numDate(1) numDate(2) numDate(3)], str, uVperBit,'null', pathstr);
    write2bni(signal);
    write2bni([]);
    
end

% if there are less than NumChansPerEEGFilc channels, then the above code does not run
% init i = 0 and run the below code to get the remainder
if size(data,1) < NumChansPerEEGFile
    i = 0;
end

if mod(size(data,1),NumChansPerEEGFile) ~= 0
% cleanup extra channels
start = i*NumChansPerEEGFile+1;
stop = size(data,1);
    str = '';
    
    for j = start:stop     % channel labels start with 1, like matlab
        str = strvcat(str, ['Ch' num2str(ceil(j/numRow)) 'R' num2str(j - (ceil(j/numRow)-1) * numRow)]);
    end

    str = strvcat(str,'EEG');
    
      % channels in matlab start with 1, like labels above
    signal = data(start:stop,:);
    signal = [signal;eeg];
    
    write2bni(signal,[name '_p' num2str(i+1)],round(Fs),[numDate(4) numDate(5) numDate(6)],[numDate(1) numDate(2) numDate(3)], str, uVperBit,'null', pathstr);
    write2bni(signal);
    write2bni([]);  
end   


end
