function replaceSpikeSessInfo(SessNum);
%
%   replaceSpikeSessInfo(SessNum)
%


global MONKEYDIR
disp(['Replacing Spike Session Info for SessNum = ' num2str(SessNum)]);
Spike_Session = Spike_Database;
load([MONKEYDIR '/mat/Spike_Session.mat'])
Session{SessNum} = Spike_Session{SessNum};
save([MONKEYDIR '/mat/Spike_Session.mat'],'Session')