function FigureHandle = plotSelectionAccLLR(Onset)
%
%  FigureHandle = plotSelectionAccLLR(Onset)
%
%   Inputs: Onset      = Data structure
%

Session = Onset.Session;
Params = Onset.Params;
sampling = 1e3;

switch ModelType
    case {'Spectral','SVDSpectral'}
        Dt = Params.Lfp.Dn*sampling;
    otherwise
        Dt = 1;
end

% MaxTime = Params.MaximumTimetoOnsetDetection - Params.StartofAccumulation;
% GoCue = Params.StartofAccumulationTime - Params.StartTime;
% Eventbn = Params.Event.bn;
% Nullbn = Params.Null.bn;

FigureHandle = figure;
nType = length(Onset.Results);
for iType = 1:length(Onset.Results)
    Results = Onset.Results(iType);
    Data = Onset.Data(iType);
    Model = Onset.Model(iType);

    nTrial = size(Results.NoHist.Event.AccLLR,1);
    mEvent = mean(Results.NoHist.Event.AccLLR);
    mNull = mean(Results.NoHist.Null.AccLLR);
    sdEvent = std(Results.NoHist.Event.AccLLR)./sqrt(nTrial);
    sdNull = std(Results.NoHist.Null.AccLLR)./sqrt(nTrial);

    Label = '';
    Start =  Params.StartofAccumulationTime./Dt;
    Stop = Params.MaximumTimetoOnsetDetection./Dt;
    tEvent = Start+1:Dt:Stop;

    subplot(nType,1,iType)
    h = plot(tEvent,mEvent,'k-');  set(h,'Linewidth',2);
    h = patch([tEvent,tEvent(end:-1:1)],[mEvent+1*sdEvent, mEvent(end:-1:1)-1*sdEvent(end:-1:1)],0.7*[1,1,1]);
    set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
    hold on;
    h = plot(tEvent,mNull,'k--');  set(h,'Linewidth',2);
    h = patch([tEvent,tEvent(end:-1:1)],[mNull+1*sdNull, mNull(end:-1:1)-1*sdNull(end:-1:1)],0.7*[1,1,1]);
    set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
    set(gca,'Fontsize',14);
    title(Results.Type);
    set(gca,'XLim',[Start,Stop]);
    box off; xlabel('Time (ms)'); ylabel(Label);
end

TaskString = removeUnderscore(plotSelectionTaskStringHelper(Params));
TypeString = removeUnderscore(plotSelectionTypeStringHelper(Results));
SessionString = removeUnderscore(plotSelectionSessionStringHelper(Session));

DirString = ['Direction ' num2str(Params.Event.Target(1))];

str{1} = [TypeString ' Session ' SessionString];
str{2} = [TaskString ' ' DirString];
str{3} = [Params.Selection ' ' Params.Type ' Selection AccLLR'];
supertitle(str);



