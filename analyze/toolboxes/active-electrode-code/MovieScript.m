


step = 5; % seconds
startMin = 41    ;
startSec = 41  ;
start = startMin * 60 + startSec;

stopMin = 42  ;
stopSec = 21  ;
stop = stopMin * 60 + stopSec;

for i = start:step:stop
    convert2Movie (data, filename, i, i+step, 0, numRow, numCol, Fs);
end



