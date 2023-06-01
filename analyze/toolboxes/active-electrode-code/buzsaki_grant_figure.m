lineXpos = 10.5;   % position of scale bar origin in seconds
lineXsize = 1;  % size of horizontal scale bar in seconds
lineYpos = -0.3e-3;    % position of scale bar origin in volts
lineYsize = 500e-6;   % size of vertical scale bar in volts
seizure_start = 2; % seconds
seizure_stop = 12; % seconds

bgColor = 'white';
lineColor = 'black';
scalebarColor = 'black';

gain_factor = 10;
column_num = 3;

%plots(dataf ./10, numCol, numRow, 1, numChan, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize)

plots(dataf(:,round(Fs * seizure_start):round(Fs * seizure_stop)) ./ gain_factor, numCol, numRow, column_num, column_num, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize, bgColor, lineColor, scalebarColor)