function [FigureHandle, ROC, se] = plotSelectionROC(Onset)
%  Plot choice probabality analysis (a la Fig )
%
%  [FigureHandle, ROC, se] = plotSelectionROC(Onset)
%
%   Inputs: Onset      = Data structure
%


if isfield(Onset,'Session')
    Session = Onset.Session;
else
    Session = {};
end
Params = Onset.Params;
MaxTime = Onset.Params.MaximumTimetoOnsetDetection;
FigureHandle = figure;
    
CLIST = ['brgmcyk'];
p = zeros(1,length(Onset.Results));
Labels = {};
for iType = 1:length(Onset.Results)
    Results = Onset.Results(iType);
    AccLLRNull = Results.NoHist.Null.AccLLR;
    AccLLREvent = Results.NoHist.Event.AccLLR;

    z = [-ones(1,MaxTime) ones(1,MaxTime)];
    ROC = zeros(1,MaxTime); se = zeros(1,MaxTime);
    for iT = 1:MaxTime
        [ROC(iT),se(iT)] = myroc(AccLLRNull(:,iT)'+rand(1,size(AccLLRNull,1))*0.04, ...
            AccLLREvent(:,iT)' + rand(1,size(AccLLREvent,1))*0.04);
    end

    t = [1:MaxTime];
    hold on;
    h = patch([t,t(end:-1:1)],[ROC+2*se,ROC(MaxTime:-1:1)-2*se(MaxTime:-1:1)],0.7*[1,1,1]);
    set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
    hold on;
    p(iType) = plot(t,ROC,[CLIST(iType) '-']);  set(h,'Linewidth',2);
    Labels = [Labels {Results.Type}];
    axis([0 MaxTime 0.4 1.]);
    h = line([0 MaxTime],[0.5,0.5]); set(h,'Linewidth',1,'Linestyle','--','Color',CLIST(iType));
end

legend(p,Labels);

set(gca,'Fontsize',14);
xlabel('Time from onset (ms)'); ylabel('Probability');

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
str{3} = [Params.Selection ' ' Params.Type ' Selection ROC'];
title(str);
