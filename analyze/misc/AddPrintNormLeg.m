function Fig=AddPrintNormLeg(Fig,iFig,MarkersInFig,AllMarkers,SpecMarkers,MarkerCode,UseMattscolordefs)

if nargin<7     UseMattscolordefs=1;    end

%Legend Options
Fig(iFig).Legend.HorzBdr=.05;
Fig(iFig).Legend.VertBdr=.05;
Fig(iFig).Legend.linespace=.05;
Fig(iFig).Legend.PlotmarkOffset=.05;
Fig(iFig).Legend.PlotmarkLength=.05;
Fig(iFig).Legend.PlotmarkWidth=3;
Fig(iFig).Legend.MarkerOffset=.2;
Fig(iFig).Legend.MarkerSize=6;
Fig(iFig).Legend.VertOffset=0;

xnum=2-Fig(iFig).minx+1;
ynum=2-Fig(iFig).miny+1;
Fig(iFig).Legend.Handle=axes('Position',[Fig(iFig).Dirxpos(xnum) Fig(iFig).Dirypos(ynum) Fig(iFig).DirWidth Fig(iFig).DirHeight],'Ytick',[],'XTick',[]);
box on
hold on
Fig(iFig).Legend.numlines=1+sum(MarkersInFig)+Fig(iFig).numplots;
Fig(iFig).Legend.fontsize=(1-2*Fig(iFig).Legend.VertBdr-Fig(iFig).Legend.linespace*(Fig(iFig).Legend.numlines-1))/Fig(iFig).Legend.numlines;
Fig(iFig).Legend.Title=AddFittedText('LEGEND',.5,1-Fig(iFig).Legend.VertBdr-Fig(iFig).Legend.fontsize+Fig(iFig).Legend.VertOffset,...
    1-Fig(iFig).Legend.HorzBdr,'normalized',Fig(iFig).Legend.fontsize,'center','bold');
for iplot=1:Fig(iFig).numplots
    vertpos=1-(Fig(iFig).Legend.VertBdr+Fig(iFig).Legend.fontsize*(iplot+1)+Fig(iFig).Legend.linespace*iplot)+Fig(iFig).Legend.VertOffset;
    Fig(iFig).Legend.plotline(iplot)=AddFittedText([Fig(iFig).Task{iplot} ' Data'],.5,vertpos,1-Fig(iFig).Legend.HorzBdr,...
        'normalized',Fig(iFig).Legend.fontsize,'center');
    TempExt=get(Fig(iFig).Legend.plotline(iplot),'Extent');
    disp(['Plotting line for plot: ' num2str(iplot) ' from ' num2str(TempExt(1)-Fig(iFig).Legend.PlotmarkOffset) ' to ' num2str(TempExt(1)-Fig(iFig).Legend.PlotmarkOffset-Fig(iFig).Legend.PlotmarkLength)])
    disp(['Temp Ext is: ' num2str(TempExt)])
    %             disp(['Offset is: ' num2str(Fig(iFig).Legend.PlotmarkOffset)])
    Fig(iFig).Legend.plotmark(iplot)=plot([TempExt(1)-Fig(iFig).Legend.PlotmarkOffset ...
            TempExt(1)-Fig(iFig).Legend.PlotmarkOffset-Fig(iFig).Legend.PlotmarkLength],...
            [vertpos+.5*TempExt(4) vertpos+.5*TempExt(4)]);
    set(Fig(iFig).Legend.plotmark(iplot),'LineWidth',Fig(iFig).Legend.PlotmarkWidth)
    if UseMattscolordefs
        set(Fig(iFig).Legend.plotmark(iplot),'Color',Mattscolordefs(iplot,1))
        set(Fig(iFig).Legend.plotline(iplot),'Color',Mattscolordefs(iplot,1))
    else
        set(Fig(iFig).Legend.plotmark(iplot),'Color',matlabcolordefs(ITcolors(iplot)))
        set(Fig(iFig).Legend.plotline(iplot),'Color',matlabcolordefs(ITcolors(iplot)))
    end
end

Markinds=find(MarkersInFig);
for iMark=1:sum(MarkersInFig)
    vertpos=1-(Fig(iFig).Legend.VertBdr+Fig(iFig).Legend.fontsize*(Fig(iFig).numplots+1+iMark)+...
        Fig(iFig).Legend.linespace*(Fig(iFig).numplots+iMark))+Fig(iFig).Legend.VertOffset;
    Fig(iFig).Legend.Markerline(iMark)=AddFittedText(AllMarkers{SpecMarkers(Markinds(iMark))},.5,...
        vertpos,1-Fig(iFig).Legend.HorzBdr,'normalized',Fig(iFig).Legend.fontsize,'center');
    TempExt=get(Fig(iFig).Legend.Markerline(iMark),'Extent');
    Fig(iFig).Legend.Marker(iMark)=plot(TempExt(1)-Fig(iFig).Legend.MarkerOffset,vertpos+.5*TempExt(4),...
        MarkerCode{SpecMarkers(Markinds(iMark))},'Markersize',Fig(iFig).Legend.MarkerSize);
    if strcmp(AllMarkers{SpecMarkers(Markinds(iMark))},'TargsOn')|strcmp(AllMarkers{SpecMarkers(Markinds(iMark))},'TargsOff')
        set(Fig(iFig).Legend.Marker(iMark),'Color',Mattscolordefs(7))
    elseif strcmp(AllMarkers{SpecMarkers(Markinds(iMark))},'IntGo')|strcmp(AllMarkers{SpecMarkers(Markinds(iMark))},'IntAq')
        set(Fig(iFig).Legend.Marker(iMark),'Color',Mattscolordefs(10))
    end
end
axis([0 1 0 1])