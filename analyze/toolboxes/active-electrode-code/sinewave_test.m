function sinewave_test(pathStr, filename)

load(strcat(pathStr ,'\',filename));
headstage_gain = 5;
BncChannel = 20; %sine wave channel
gain_working_threshold = 0.05;
[PATHSTR,NAME,EXT] = fileparts(filename);

info.Note

startSec =10;
endSec = 5;

temp = reshape( data, numRow , numChan , size(data,2) );
validCol = [1:3 5:12 14:numChan];
temp = temp(:,validCol,:);
numChan = numChan - 2;          % throw out two columns
numCol = numCol - 2;  % throw out two columns
BncChannel = BncChannel - 2;
temp = temp(1:2:size(temp,1),:,:);      % take every other row data
numRow = 16;
data = reshape(temp,numRow * numChan, size(data,2));

signal = calcSignal(data, 'SIGNAL', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold);

save([pathStr '\' NAME '_gain.mat'],'signal', 'info');



end