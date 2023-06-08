%  Select all LRS trials

clear CondParams AnalParams;

rowind = 1;
colind = 1;

CondParams = [];
CondParams(rowind,colind).Name = 'All LRS Trials';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;

AnalParams = [];
AnalParams(rowind,colind).Fields = {'TargsOn','SaccStart'};
AnalParams(rowind,colind).bn = [ -600 600 ];
AnalParams(rowind,colind).wlen = 0.1; % sliding window length
AnalParams(rowind,colind).dn = 0.02; % sliding window increment
AnalParams(rowind,colind).nPerm = 1e3;    
