function FigureHandle = plotSelectionTimeTrialAverageCurve(Onset, ModelType, DetectType)
%
%  FigureHandle = plotSelectionTimeTimeAverageCurve(Onset, ModelType, DetectType)
%
%   Inputs: Onset      = Data structure
%           ModelType = String. Type of model for analysis 'NoHist' or 'Spectral'
%                           Defaults to 'NoHist'
%           DetectType = String. 'Hit' or 'Correct'
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


switch ModelType
    case 'Spectral'
        Dt = Onset.Params.Lfp.Dn*1e3;
    otherwise
        if isfield(Onset.Params,'Dt')
            Dt = Onset.Params.Dt;
        else
            Dt = 1;
        end
end

Results = Onset.Results;
Params = Onset.Params;
MaxTime = Onset.Params.MaximumTimetoOnsetDetection - Params.StartofAccumulationTime;
MaxTime = MaxTime *Dt;
NumTrials = Results.(ModelType).InputParams.TrialAvNumTrials;
if(iscell(NumTrials))
    NumTrials = NumTrials{1};
end

FigureHandle = figure;
CLIST = 'kbrgmcykbrgmcy';
switch DetectType
    case 'Hit'
        for iNumTrials = 1:length(NumTrials)
            AccLLREvent = Onset.Results.(ModelType).TrialAv.AccLLREvent{iNumTrials};
            AccLLRNull = Onset.Results.(ModelType).TrialAv.AccLLRNull{iNumTrials};
            [p, ST] = ...
                performance_levels(AccLLREvent, AccLLRNull, DetectType);
            ST = ST*Dt;
            hold on; h(1) = plot(p(:,1,1),ST,[CLIST(iNumTrials) 'x']);
            hold on; h(2) = plot(p(:,2,1),ST,[CLIST(iNumTrials) 'o']);
        end
        Labels = {'Hit','False alarm'};
   case 'Correct'
       for iNumTrials = 1:length(NumTrials)
            AccLLREvent = Onset.Results.(ModelType).TrialAv.AccLLREvent{iNumTrials};
            AccLLRNull = Onset.Results.(ModelType).TrialAv.AccLLRNull{iNumTrials};
            [p, ST] = ...
                performance_levels(AccLLREvent, AccLLRNull, DetectType);
            ST = ST*Dt;
            %cut plotting as it is freezing matlab
            t = 1:length(ST)/3;
            hold on; h(1) = plot((p(t,1,1)+p(t,2,2))./2,ST(t),[CLIST(iNumTrials) 'x']);
            hold on; h(2) = plot((p(t,2,1)+p(t,1,2))./2,ST(t),[CLIST(iNumTrials) 'o']);
       end
       Labels = {'Correct','Incorrect'};
    otherwise
        error('DetectType is not Hit or Correct');
end
set(gca, 'Fontsize', 14);
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
str{3} = [Params.Selection ' ' Params.Type ' ' ModelType ' Selection Time Trial Average Curve'];
title(str);

