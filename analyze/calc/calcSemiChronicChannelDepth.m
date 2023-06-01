function [depth,days,recs] = calcSemiChronicChannelDepth(Session,cumulative,day,ch)
%
%  [depth,days,recs] = getSemiChronicChannelDepth(SESSION,CUMULATIVE,DAY,CH)
%
%  Calculate the depth of all electrodes from the Movement_Database
%  specified by SESSION. The SESSION array should be from one tower.
%  If no parameters are specified, the integrated depth
%  at the end of all recording days is returned.
%  
%  If CUMULATIVE is specified and equals 1, the cumulative depth at the
%  start of each recording is returned for all channels. Default is 0.
% 
%  If DAY is specified, the depth up to and including the end of the
%  specified day is returned.
% 
%  If CH is specified, only the depth for the specified channel is returned.
% 
% Usage:   [ depth ] = getSemiChronicChannelDepth(Session);
%          [ depth ] = getSemiChronicChannelDepth(Session,0,'101225',24);
%          [ depth,days,recs] = getSemiChronicChannelDepth(Session,1);
%          [ depth,days,recs] = getSemiChronicChannelDepth(Session,1,'101225',24);
%          [ depth,days,recs] = getSemiChronicChannelDepth(Session,0,'101225',[]);

global MONKEYDIR

turnThrow = 125; % (um/turn)

tower = sessTower(Session{1});

if isfile([MONKEYDIR '/m/depth/Movement_' tower '_StartDepth'])
  eval(['Movement_' tower '_StartDepth']);  
  cumdepth = StartDepth;
else
  cumDepth = [];
  if length(Session)>0
    cumDepth = zeros(1,length(Session{1}{4}));
  end
end

if ~exist('cumulative','var')
  cumulative = 0; 
end

if exist('day','var') & ~isempty(day)
  for iSess = 1:length(Session)
    curDay = Session{iSess}{1};    
    dayFound = 0;
    if isequal(curDay,day)
      Session = {Session{1:iSess}};
      dayFound = 1;
      break; 
    end
  end
  if ~dayFound
    return; 
  end
end

depth = [];
days = [];
recs = [];
dIndex = 1;
for iSess = 1:length(Session)
  curDay = Session{iSess}{1};
  allRecs = dayrecs(curDay);
  tower = sessTower(Session{iSess});
  ['Movement_' tower '_' curDay]
  eval(['Movement_' tower '_' curDay]);  
  mRecs = [moveIter.rec];
  for iRec = 1:length(allRecs)
    curRec = allRecs{iRec};
    [yn, mLoc] = ismember(str2num(allRecs{iRec}),mRecs);
    if yn
      for k = 1:length(mLoc)
        cumDepth = cumDepth + turnThrow*moveIter(mLoc).moveInc;
      end
    end
    depth = [ depth; cumDepth ];
    days{dIndex} = curDay;
    recs{dIndex} = allRecs{iRec};
    dIndex = dIndex + 1;  
  end
end

if exist('ch','var') & ~isempty(ch)
  cumDepth = cumDepth(:,ch); 
  depth = depth(:,ch); 
end

if cumulative==0
  depth = cumDepth;
end
