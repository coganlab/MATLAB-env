function Fig = InitializePrintDirAxes(Fig, xnum, ynum, numYTicks, maxvalue, CovArea, iFig, iDr, t, t2)
%
%  Fig = InitializePrintDirAxes(Fig, xnum, ynum, numYTicks, maxvalue, CovArea, iFig, iDr, t, t2)
%

Fig(iFig).eax(iDr) = axes('Position',[Fig(iFig).Dirxpos(xnum) ...
                            Fig(iFig).Dirypos(ynum) + 1*Fig(iFig).BetweenGraphSpace2 + 0*Fig(iFig).EHHeight ...
                            Fig(iFig).DirWidth ...
                            2*Fig(iFig).EHHeight]);
axis([0 t2(end) -20 20])
if xnum>1
    set(Fig(iFig).eax(iDr), 'YTickLabel', [])
else
    set(Fig(iFig).eax(iDr), 'YTickLabel', [-20 0 20])
    eyetitlabel = ylabel('EPos');
    set(eyetitlabel, 'FontUnits', 'points', 'FontSize',8)
end

if ynum<Fig(iFig).numydirs
    set(Fig(iFig).eax(iDr), 'XTickLabel', [])
end

hold on
box on

% Fig(iFig).hax(iDr)=axes('Position',[Fig(iFig).Dirxpos(xnum) Fig(iFig).Dirypos(ynum) Fig(iFig).DirWidth Fig(iFig).EHHeight],'YTickLabel',[]);
% handtitlabel=ylabel('HPos');
% set(handtitlabel,'FontUnits','points','FontSize',8)
% hold on
% box on
Pos = [Fig(iFig).Dirxpos(xnum) ...
    Fig(iFig).Dirypos(ynum) + Fig(iFig).BetweenGraphSpace1 + Fig(iFig).BetweenGraphSpace2 + 2*Fig(iFig).EHHeight ...
    Fig(iFig).DirWidth ...
    Fig(iFig).HistHeight];

YValues = linspace(0,maxvalue,numYTicks);
if maxvalue < 10
    for iY = 1:numYTicks
        YTickNames{iY} = sprintf('%0.1f',YValues(iY));
    end
else
    for iY = 1:numYTicks
        YTickNames{iY} = sprintf('%0.f',YValues(iY));
    end
end

                        
Fig(iFig).ax(iDr) = axes('Position', Pos,...
                         'XTickLabel', [], 'YTick', YValues,'YTickLabel',YTickNames);
hold on
axis([t(1) t(end) 0 maxvalue+CovArea])
if xnum > 1
    set(Fig(iFig).ax(iDr), 'YTickLabel', []);
end