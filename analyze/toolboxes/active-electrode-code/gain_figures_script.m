
close all
clear all

%pathStr = 'H:\users\jviventi\Data\electrode 1';
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 1';
filename = 'test_001_demux.mat';

tic
load([pathStr,'\',filename]);
Fs = Fs * 2;
signal = calcSignal(data, 'SIGNAL', 55, 5, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);
toc

%%

close all
clear all
%pathStr = 'H:\users\jviventi\Data\electrode 1';
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 1';
filename = 'test_002_demux.mat';

tic
load([pathStr,'\',filename]);
Fs = Fs * 2;


signal = calcSignal(data, 'SIGNAL', 20, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);
toc

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 1-b';
filename = 'test_001_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 2';
filename = 'test_004_demux.mat';
load([pathStr,'\',filename]);
Fs = Fs * 2;
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 2 with old daq sys ver 2';
filename = 'test_001_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 1);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 2-b';
filename = 'test_001_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 20, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 3';
filename = 'test_010_demux.mat';
load([pathStr,'\',filename]);
Fs = Fs * 2;
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 3';
filename = 'test_011_demux.mat';
load([pathStr,'\',filename]);
Fs = Fs * 2;
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 3 - b with old daq sys ver 2';
filename = 'test_001_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 1);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 3 with old daq sys ver 2';
filename = 'test_001_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 1);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 3-b';
filename = 'test_001_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 4';
filename = 'test_001_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 4-b';
filename = 'test_002_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 4-b';
filename = 'test_003_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 4-b';
filename = 'test_004_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);

%%
close all
clear all
pathStr = 'C:\Users\DAQ\Desktop\Data\electrode 4-b';
filename = 'test_005_demux.mat';
load([pathStr,'\',filename]);
signal = calcSignal(data, 'SIGNAL', 10, 10, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, 5);





