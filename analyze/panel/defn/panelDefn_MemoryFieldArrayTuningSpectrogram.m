%  Memory and Delay Field Normalized Spectrogram Tasks panel
clear CondParams AnalParams;

global ELECTRODE_MAP

SessType = 'Field';


fk = 100; tapers = [.5,5]; 
clim = [-2,2]; 
%Norm.Task = ''; Norm.Cond = {[]};
%Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';

for iSess = 1:length(Session)
  Channel = sessChannel(Session{iSess});
  iX = ELECTRODE_MAP(Channel,1);
  iY = ELECTRODE_MAP(Channel,2);
  CondParams(iX,iY).Name = 'MemoryFieldTuningSpectrogram';

  CondParams(iX,iY).Task = {{'MemoryReachFix'}};
  CondParams(iX,iY).conds = {[]};
  %CondParams(1,2).Task = CondParams(1,1).Task;
  %CondParams(1,2).conds = {[Dirs(2)]};

%  CondParams(2,1).Task = {{'MemorySaccadeTouch'}};
%  CondParams(2,1).conds = {[]};
  %CondParams(2,2).Task = CondParams(2,1).Task;
  %CondParams(2,2).conds = {[Dirs(2)]};
end

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = [SessType 'TuningSpectrogram'];
AnalParams(1,1).CLim = clim;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Go';
AnalParams(1,2).bn = [-1e3,1e3];
AnalParams(1,2).Type = [SessType 'TuningSpectrogram'];
AnalParams(1,2).CLim = clim;

