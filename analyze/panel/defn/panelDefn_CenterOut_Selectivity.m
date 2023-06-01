
panelDefn_CenterOutTuning;

diffMap = [ 1 1 2 1; 2 1 1 1 ]; % compare memory vs visual task

for m=1:size(CondParams,1)
  for n=1:size(CondParams,2)
    AnalParams(m,n).doSpatialAnalysis = 1;
    AnalParams(m,n).doDiffAnalysis = 1; % must be used in conjunction with the spatial analysis
    AnalParams(m,n).doChoiceAnalysis = 0;
    
    AnalParams(m,n).TargetIDs = 0;
    AnalParams(m,n).TargetLocations = [ 1:8 0 ];
    AnalParams(m,n).wlen = 0.3; % 0.1;
    AnalParams(m,n).dn = 0.05; % 0.02;
    AnalParams(m,n).bn = [ -500 1500; -1500 500; -500 500 ];
    AnalParams(m,n).baselineTime = -300;
    AnalParams(m,n).nPerm = 1e4; % 1e3;
    AnalParams(m,n).rtCategories = [ 0 Inf ];
    AnalParams(m,n).excludeRewardBlockTrials = 0;
    AnalParams(m,n).choiceCategories = 1;
    AnalParams(m,n).scaleFactor = AnalParams(m,n).nPerm;
    
    [tf,diffInd] = ismember([m n],diffMap(:,[1 2]),'rows');
    AnalParams(m,n).Diff = CondParams(diffMap(diffInd,3),diffMap(diffInd,4));
    
    if isequal(sessType(Session{1}),'Field') | ...
       isequal(sessType(Session{1}),'SpikeField') | ...
       isequal(sessType(Session{1}),'FieldField')
      AnalParams(m,n).wlen = 0.5; % 0.2;
      AnalParams(m,n).fk = [ 1/AnalParams(m,n).wlen 100 ];
      AnalParams(m,n).sampling_rate = 1000;
      AnalParams(m,n).pad = 2;
      AnalParams(m,n).tapers = [AnalParams(m,n).wlen,max(1/AnalParams(m,n).wlen,10)]; % max was 5, but estimates were noisy
    end
    
    if isequal(sessType(Session{1}),'SpikeSpike')
      AnalParams(m,n).tau_epsp = 10;
      AnalParams(m,n).synchThresh = 1 + 1/exp(1);
    end    
  end
end