function FigureHandle = plotSelectionTrialAverageOptimalPerformance(Onset, DetectType)
%
%  FigureHandle = plotSelectionTrialAverageOptimalPerformance(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit' or 'Correct'
%                           Defaults to 'Hit'
%

if nargin < 2 || isempty(DetectType)
    DetectType = 'Hit';
end

Params = Onset.Params;
Session = Onset.Session;

switch ModelType
    case 'Spectral'
        Dt = Params.Lfp.Dn*1e3;
    otherwise
        Dt = 1;
end

CLIST = ['krgmcyk'];

FigureHandle = figure;

GraphCount = 0;

nType = length(Onset.Results)
for iType = 1:nType
  Results = Onset.Results(iType);
  NumTrials = Results.NoHist.InputParams.TrialAvNumTrials;


  for iNumTrials = 1:length(NumTrials)
    %  NoHist across Trial Averages
    AccLLREvent = Results.NoHist.TrialAv.AccLLREvent{iNumTrials};
    AccLLRNull = Results.NoHist.TrialAv.AccLLRNull{iNumTrials};
    [p, ST, Levels] = performance_levels(AccLLREvent, AccLLRNull, DetectType);
    [Opt_p(iNumTrials), Opt_ST(iNumTrials), Opt_FA(iNumTrials)] = ...
        optimal_performance(p, ST, DetectType);
  end
  Opt_ST = Opt_ST*Dt;

  GraphCount = GraphCount + 1;
  subplot(3,nType,GraphCount)
  h = plot(NumTrials,Opt_p,[CLIST(iType) '-']); set(h, 'Linewidth',2);
  set(gca,'Fontsize',14);
  ylabel([DetectType 'Probability']);

  GraphCount = GraphCount + 1;
  subplot(3,nType,GraphCount)
  h = plot(NumTrials,Opt_FA,[CLIST(iType) '-']); set(h, 'Linewidth',2);
  set(gca,'Fontsize',14);
  ylabel('Alarm Probability');

  GraphCount = GraphCount + 1;
  subplot(3,nType,GraphCount)
  h = plot(NumTrials,Opt_ST,[CLIST(iType) '-']); set(h, 'Linewidth',2);
  set(gca,'Fontsize',14);
  xlabel('Number of Trials'); ylabel('Selection Time (ms)');
end

TaskString = plotSelectionTaskStringHelper(Params);
TypeString = plotSelectionTypeStringHelper(Results);
SessionString = plotSelectionSessionStringHelper(Session);

DirString = ['Direction ' num2str(Params.Event.Target(1))];

str{1} = [TypeString ' Session ' SessionString];
str{2} = [TaskString ' ' DirString];
str{3} = [Params.Selection ' ' Params.Type ' Selection Trial Average Optimal Performance'];
supertitle(str);

