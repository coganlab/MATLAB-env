


%% Sine wave test analysis
close all
clear all
pathStr = 'C:\Users\jviventi\Desktop\temp\Sample 4';
filename = 'test_004.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 5;
BncChannel = 23; %sine wave channel
gain_working_threshold = 0.2;

startSec =10;
endSec = 5;

signal = calcSignal(data, 'SIGNAL', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold);

 %%
 
 
 close all
clear all
pathStr = 'C:\Users\jviventi\Desktop\temp\Sample 4';
filename = 'test_004.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 5;
BncChannel = 13; %sine wave channel
gain_working_threshold = 0.1;

startSec =10;
endSec = 5;

 
 % Pull out 160 ch electrode data
 
temp = reshape( data(1:numRow*numCol,:) , numRow , numCol , size(data,2) );
temp = temp(:,1:2:end,:);
reshape(temp,numRow* numCol /2, size(data,2));
data = [ans;data(361:end,:)];

numCol = 10;

signal = calcSignal(data, 'SIGNAL', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold);

%%
% % %% Leak current analysis
% % 
% % %from leak_current plots
% 
% a = 21; 
% b = 22;
% conversion_gain = 200000;       % convert volts to amps
% bnc1 = mean(data(((a-1)*numRow) + (1:numRow),:)) / conversion_gain;
% bnc2 = mean(data(((b-1)*numRow) + (1:numRow),:)) / conversion_gain;
% 
% time = 1/Fs *[1:length(data(a,:))];
% % plot([bnc1 ; bnc2]');
% 
% 
% figure; plot(time/60, bnc1', 'b'); hold on
% plot(time/60, bnc2', 'r')
% xlabel('Time (min)')
% ylabel('Leak Current (A)')
% legend('Sys 1 // BNC ch 21', 'Sys 2 // BNC ch 22')