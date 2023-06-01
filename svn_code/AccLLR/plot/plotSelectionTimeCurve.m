function FigureHandle = plotSelectionTimeCurve(Onset, ModelType, DetectType)
%
%  FigureHandle = plotSelectionTimeCurve(Onset, ModelType, DetectType)
%
%   Inputs: Onset      = Data structure
%           ModelType = String. Type of model for analysis 'NoHist' or 'Spectral'
%                           Defaults to 'NoHist'
%           DetectType = String. 'Hit', 'Reject' or 'Correct'
%                           Defaults to 'Hit'
%

if nargin < 2 || isempty(ModelType)
    ModelType = 'NoHist';
end

if nargin < 3 || isempty(DetectType)
    DetectType = 'Hit';
end

if isfield(Onset,'Session')
    Session = Onset.Session;
else
    Session = {};
end
Results = Onset.Results;
Params = Onset.Params;
MaxTime = Params.MaximumTimetoOnsetDetection;

Dt = 1;
switch ModelType
    case 'Spectral'
        Dt = Params.Lfp.Dn*1e3;
end

CLIST = ['brgmcyk'];

FigureHandle = figure;

TotAccLLREvent = zeros(size(Onset.Results(1).(ModelType).Event.AccLLR));
TotAccLLRNull = zeros(size(Onset.Results(1).(ModelType).Null.AccLLR));
Labels = {};

GraphCount = 1;
for iType = 1:length(Onset.Results)
  Results = Onset.Results(iType);
  AccLLRNull = Results.(ModelType).Null.AccLLR;
  AccLLREvent = Results.(ModelType).Event.AccLLR;
  TotAccLLRNull = TotAccLLRNull + AccLLRNull;
  TotAccLLREvent = TotAccLLREvent + AccLLREvent;

  switch DetectType
    case 'Hit'
        [p, ST, Levels] = ...
            performance_levels(AccLLREvent, AccLLRNull);
        ST = ST*Dt;
        Labels = [Labels {[Results.Type ' hit'],[Results.Type ' false alarm']}];
        hold on; h(GraphCount) = plot(p(:,1,1),ST,[CLIST(iType) 'x']);
        GraphCount = GraphCount + 1;
        hold on; h(GraphCount) = plot(p(:,2,1),ST,[CLIST(iType) 'o']);
        GraphCount = GraphCount + 1;
    case 'Reject'
        [p, ST, Levels] = ...
            performance_levels(-AccLLRNull, -AccLLREvent);
        ST = ST*Dt;
        Labels = [Labels {[Results.Type ' reject'],[Results.Type ' false reject']}];
        hold on; h(GraphCount) = plot(p(:,1,1),ST,[CLIST(iType) 'x']);
        GraphCount = GraphCount + 1;
        hold on; h(GraphCount) = plot(p(:,2,1),ST,[CLIST(iType) 'o']);
        GraphCount = GraphCount + 1;
   case 'Correct'
        [p, ST, Levels] = ...
            performance_levels(AccLLREvent, AccLLRNull);
        ST = ST*Dt;
        Labels = [Labels {[Results.Type ' correct'],[Results.Type ' incorrect']}];
        hold on; h(GraphCount) = plot((p(:,1,1)+p(:,2,2))./2,ST,[CLIST(iType) 'x']);
        GraphCount = GraphCount + 1;
        hold on; h(GraphCount) = plot((p(:,2,1)+p(:,1,2))./2,ST,[CLIST(iType) 'o']);
        GraphCount = GraphCount + 1;
    otherwise
        error('DetectType is not Hit, Reject or Correct');
    end
end
%set(gca,'Fontsize',14);

if length(Onset.Results) > 1
  [p, ST, Levels] = ...
    performance_levels(TotAccLLREvent, TotAccLLRNull);
    ST = ST*Dt;
  switch DetectType
    case 'Hit'
      Labels = [Labels {['Pooled hit'],['Pooled false alarm']}];
      hold on; h(GraphCount) = plot(p(:,1,1),ST,[CLIST(end) 'x']);
      GraphCount = GraphCount + 1;
      hold on; h(GraphCount) = plot(p(:,2,1),ST,[CLIST(end) 'o']);
      GraphCount = GraphCount + 1;
    case 'Correct'
      Labels = [Labels {'Pooled correct','Pooled incorrect'}];
      hold on; h(GraphCount) = plot((p(:,1,1)+p(:,2,2))./2,ST,[CLIST(end) 'x']);
      GraphCount = GraphCount + 1;
      hold on; h(GraphCount) = plot((p(:,2,1)+p(:,1,2))./2,ST,[CLIST(end) 'o']);
      GraphCount = GraphCount + 1;
  end
end

axis([0 1 0 MaxTime]); legend(h,Labels);
ylabel('Selection time (ms)'); xlabel('Probability');

TaskString = plotSelectionTaskStringHelper(Params);
TypeString = plotSelectionTypeStringHelper(Results);
if isfield(Onset,'Session')
    SessionString = plotSelectionSessionStringHelper(Session);
else
    SessionString = '';
end

DirString = ['Direction ' num2str(Params.Event.Target(1))];

str{1} = [TypeString ' Session ' SessionString];
str{2} = [TaskString ' ' DirString];
str{3} = [Params.Selection ' ' Params.Type ' ' ModelType ' Selection Time Curve'];
title(str);


