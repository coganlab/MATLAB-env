function plotSelectionRasters(Onset, DetectType)
%
%  plotSelectionRasters(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit' or 'Reject'
%                           Defaults to 'Hit'
%

if nargin < 2 || isempty(DetectType)
    DetectType = 'Hit';
end

Results = Onset.Results;
Data = Onset.Data;
Params = Onset.Params;
Session = Onset.Session;
MaxTime = Onset.Params.MaximumTimetoOnsetDetection;

figure;

nTrialEvent = size(Data.Event, 2);
nTrialNull = size(Data.Null, 2);
nTrialTot = nTrialEvent + nTrialNull;

for iTrial = 1:nTrialEvent
  nSpike = length(Data.Event{iTrial});
  if nSpike
    for iSpike = 1:nSpike
      SpTime = round(Data.Event{iTrial}(iSpike)) + Params.Event.bn(1);
      h = line([SpTime,SpTime],[nTrialNull+ iTrial nTrialNull+iTrial+1]);
      set(h,'Color','r');
    end
  end
end

for iTrial = 1:nTrialNull
  nSpike = length(Data.Null{iTrial});
  if nSpike
    for iSpike = 1:nSpike
      SpTime = round(Data.Null{iTrial}(iSpike)) + Params.Null.bn(1);
      h = line([SpTime,SpTime],[iTrial iTrial+1]);
      set(h,'Color','b');
    end
  end
end

Eventbn = Params.Event.bn(1:2);
title(Results.Type);
set(gca,'Fontsize',14);
set(gca,'XLim',Eventbn);
set(gca,'YTick',[0,nTrialNull,nTrialTot])
set(gca,'YTickLabel',{'1',num2str(nTrialNull),num2str(nTrialEvent)});
box off; xlabel('Time (ms)'); ylabel('');

TaskString = removeUnderscore(plotSelectionTaskStringHelper(Params));
TypeString = removeUnderscore(plotSelectionTypeStringHelper(Results));
SessionString = removeUnderscore(plotSelectionSessionStringHelper(Session));

DirString = ['Direction ' num2str(Params.Event.Target(1))];

str{1} = [TypeString ' Session ' SessionString];
str{2} = [TaskString ' ' DirString];
str{3} = [Params.Selection ' ' Params.Type ' Selection Responses'];
supertitle(str);

