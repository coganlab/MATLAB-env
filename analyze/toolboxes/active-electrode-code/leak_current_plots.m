
a = 21; 
b = 22;
conversion_gain = 200000;       % convert volts to amps
bnc1 = mean(data(((a-1)*numRow) + (1:numRow),:)) / conversion_gain;
bnc2 = mean(data(((b-1)*numRow) + (1:numRow),:)) / conversion_gain;

 time = 1/Fs *[1:length(data(a,:))];
 plot([bnc1 ; bnc2]');

figure; plot(time/60^2, bnc1', 'b'); hold on
plot(time/60^2, bnc2', 'r')
xlabel('Time (hr)')
ylabel('Leak Current (A)')
legend('Sys 1 // BNC ch 21', 'Sys 2 // BNC ch 22')
